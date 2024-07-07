const Obats = require("../models/obat");
const Users = require("../models/user");
const SearchHistory = require("../models/searchHistory");
const SearchSugest = require("../models/searchSuggest");

const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    console.log(email, password);
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: "Email dan password harus diisi.",
      });
    }

    const user = await Users.findOne({ email: email });
    if (!user) {
      return res.status(401).json({
        success: false,
        message: "Email atau password salah.",
      });
    }

    const validateUser = await bcrypt.compare(password, user.password);
    if (!validateUser) {
      return res.status(401).json({
        success: false,
        message: "Email atau password salah.",
      });
    }

    const secretToken = process.env.SECRET_TOKEN;
    if (!secretToken) {
      throw new Error(
        "SECRET_TOKEN tidak ditemukan dalam environment variables."
      );
    }

    const token = jwt.sign(
      {
        id: user._id,
        email: user.email,
        fullname: user.fullname,
      },
      secretToken,
      {
        expiresIn: "1d",
      }
    );

    user.token = token;
    await user.save();

    return res.status(200).json({
      success: true,
      message: "Login berhasil.",
      token,
      id: user._id,
    });
  } catch (err) {
    console.error("Error saat login:", err);
    return res.status(500).json({
      success: false,
      message:
        "Terjadi kesalahan saat memproses permintaan login. Silakan coba lagi nanti.",
      error: process.env.NODE_ENV === "development" ? err.message : undefined,
    });
  }
};

const register = async (req, res) => {
  try {
    const { email, password, confirmPassword } = req.body;
    console.log("Register", email, password, confirmPassword);
    if (!email || !password || !confirmPassword) {
      return res.status(400).json({
        success: false,
        status: 400,
        message:
          "Semua field harus diisi: email, password, dan confirm password.",
      });
    }
    if (password !== confirmPassword) {
      return res.status(400).json({
        success: false,
        status: 400,
        message: "Password dan confirm password harus sama.",
      });
    }
    const alreadyUser = await Users.findOne({ email });
    if (alreadyUser) {
      return res.status(409).json({
        success: false,
        status: 409,
        message: "Pengguna dengan email ini sudah terdaftar.",
      });
    }

    const hashPassword = await bcrypt.hash(password, 10);

    const newUser = new Users({
      email,
      password: hashPassword,
    });
    await newUser.save();
    return res.status(201).json({
      success: true,
      status: 201,
      message: "Pengguna berhasil didaftarkan.",
      detail: "User created successfully.",
      id: newUser._id,
    });
  } catch (err) {
    console.error("Error dalam register:", err);
    return res.status(500).json({
      success: false,
      status: 500,
      message: "Terjadi kesalahan saat mendaftarkan pengguna.",
      error: process.env.NODE_ENV === "development" ? err.message : undefined,
    });
  }
};

const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({
        success: false,
        message: "Alamat email harus disediakan",
      });
    }

    const user = await Users.findOne({ email });

    if (!user) {
      // Untuk keamanan, kita tidak memberitahu apakah email ada atau tidak
      return res.status(200).json({
        success: true,
        message: "Jika email terdaftar, instruksi reset password akan dikirim",
      });
    }

    // Generate token untuk reset password
    const resetToken = crypto.randomBytes(20).toString("hex");
    user.resetPasswordToken = resetToken;
    user.resetPasswordExpires = Date.now() + 3600000; // 1 jam
    await user.save();

    // Kirim email dengan token
    // Catatan: Implementasi pengiriman email sebenarnya harus ditambahkan di sini
    console.log(`Reset token untuk ${email}: ${resetToken}`);

    res.status(200).json({
      success: true,
      message: "Instruksi reset password telah dikirim ke email Anda",
    });
  } catch (err) {
    console.error("Error dalam forgotPassword:", err);
    res.status(500).json({
      success: false,
      message: "Terjadi kesalahan saat memproses permintaan lupa password",
      error: process.env.NODE_ENV === "development" ? err.message : undefined,
    });
  }
};

const getSuggest = async (req, res) => {
  try {
    let query = req.query.q;
    const user = req.query.userId;
    let response = [];

    query = query?.trim();

    if (user) {
      const historySuggest = await SearchHistory.find({
        userId: { $regex: user, $options: "i" },
      })
        .sort({ date: -1 }) // Mengurutkan berdasarkan jmlDicari tertinggi
        .limit(5);
      response = historySuggest;
    } else if (query && !user) {
      const suggest = await SearchSugest.find({
        suggest: { $regex: query, $options: "i" },
      })
        .sort({ jmlDicari: -1 }) // Mengurutkan berdasarkan jmlDicari tertinggi
        .limit(5);
      response = suggest;
    }
    res.status(200).json(response);
  } catch (err) {
    console.error("Error dalam getSuggest:", err);
    res.status(500).json({
      success: false,
      message: "Terjadi kesalahan saat mengambil saran pencarian.",
      error: process.env.NODE_ENV === "development" ? err.message : undefined,
    });
  }
};

const getObatSearch = async (req, res) => {
  try {
    let query = req.query.q?.trim();

    if (!query) {
      return res.status(400).json({
        success: false,
        message: "Parameter pencarian tidak boleh kosong.",
      });
    }

    const userId = req.query?.userId;

    if (!userId) {
      return res.status(401).json({
        success: false,
        message: "Pengguna tidak terautentikasi.",
      });
    }

    // Update atau tambah riwayat pencarian
    await SearchHistory.findOneAndUpdate(
      { userId, searchValue: query },
      { $set: { date: new Date() } },
      { upsert: true, new: true }
    );

    const obats = await Obats.find({
      name: { $regex: query, $options: "i" },
    });
    console.log(obats);
    res.status(200).json({
      success: true,
      data: obats || [],
    });
  } catch (err) {
    console.error("Error dalam getObatSearch:", err);
    res.status(500).json({
      success: false,
      message: "Terjadi kesalahan saat mencari produk.",
      error: process.env.NODE_ENV === "development" ? err.message : undefined,
    });
  }
};

const getUser = async (req, res) => {
  try {
    const userId = req.query.id;
    if (!userId) {
      return res.status(400).json({
        success: false,
        message: "ID pengguna diperlukan",
      });
    }

    const user = await Users.findById(userId);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "Pengguna tidak ditemukan",
      });
    }

    return res.status(200).json({
      success: true,
      data: {
        id: user._id,
        email: user.email,
        fullname: user.fullname,
        imageUrl: user.image,
      },
    });
  } catch (err) {
    console.error("Error dalam getUser:", err);
    return res.status(500).json({
      success: false,
      message: "Terjadi kesalahan saat mengambil data pengguna",
      error: process.env.NODE_ENV === "development" ? err.message : undefined,
    });
  }
};

const getDetailObat = async (req, res) => {
  try {
    const obatId = req.params.obatId;
    if (!obatId) {
      return res.status(400).json({
        success: false,
        message: "ID obat diperlukan",
      });
    }

    const obat = await Obats.findById(obatId);
    if (!obat) {
      return res.status(404).json({
        success: false,
        message: "Obat tidak ditemukan",
      });
    }

    return res.status(200).json({
      success: true,
      data: obat,
    });
  } catch (err) {
    console.error("Error dalam getDetailObat:", err);
    return res.status(500).json({
      success: false,
      message: "Terjadi kesalahan saat mengambil detail obat",
      error: process.env.NODE_ENV === "development" ? err.message : undefined,
    });
  }
};

const updateUser = async (req, res) => {
  try {
    const userId = req.params.userId;
    const { email, fullname, imageurl } = req.body;
    console.log(`User ${userId}`);

    if (!userId) {
      return res.status(400).json({
        success: false,
        message: "ID pengguna diperlukan",
      });
    }
    const updateData = {};
    if (email) updateData.email = email;
    if (fullname) updateData.fullname = fullname;
    console.log(req.file);
    console.log("ini req body", req.body.imageUrl);
    if (req.file) {
      // If a new image is uploaded
      updateData.image = `/images/${req.file.filename}`;
    } else if (req.body.imageUrl) {
      // If keeping the existing image
      updateData.image = req.body.imageUrl;
    }

    const updatedUser = await Users.findByIdAndUpdate(userId, updateData, {
      new: true,
    });

    if (!updatedUser) {
      return res.status(404).json({
        success: false,
        message: "Pengguna tidak ditemukan",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Data pengguna berhasil diperbarui",
      data: {
        id: updatedUser._id,
        email: updatedUser.email,
        fullName: updatedUser.fullname,
        imageUrl: updatedUser.image,
      },
    });
  } catch (err) {
    console.error("Error dalam updateUser:", err);
    return res.status(500).json({
      success: false,
      message: "Terjadi kesalahan saat memperbarui data pengguna",
      error: process.env.NODE_ENV === "development" ? err.message : undefined,
    });
  }
};
const updateObat = async (req, res) => {
  try {
    const id = req.params.id;
    if (!id) {
      return res.status(404).json({ error: "ID not provided" });
    }

    const { name, desc, price, category, stock } = req.body;
    let imageUrl = JSON.parse(req.body.imageUrl);
    console.log(req.body);
    if (req.files && req.files.length > 0) {
      const newImages = req.files.map((file) => `/images/${file.filename}`);
      imageUrl = [...imageUrl, ...newImages];
    }
    imageUrl = imageUrl.filter((url) => url.startsWith("/images"));
    console.log(imageUrl);
    // Cek apakah semua field yang diperlukan ada
    if (!name || !desc || !price || !category || !imageUrl || !stock) {
      return res.status(400).json({ error: "All fields are required" });
    }

    // Update data obat berdasarkan ID
    const obat = await Obats.findByIdAndUpdate(
      id,
      { name, description: desc, price, category, imageUrl, stock },
      { new: true, runValidators: true }
    );
    console.log(obat);

    if (!obat) {
      return res.status(404).json({ error: "Medicine not found" });
    }

    res.status(200).json({ message: "Medicine updated successfully", obat });
  } catch (err) {
    res
      .status(500)
      .json({ error: "An error occurred while updating the medicine" });
  }
};

const getObats = async (req, res) => {
  try {
    const obats = await Obats.find();
    res.status(200).json(obats);
  } catch (err) {
    console.error("Error fetching medicines:", err);
    res.status(500).json({ message: "Error fetching medicines" });
  }
};

const deleteObats = async (req, res) => {
  const id = req.params.id;
  console.log(id);
  try {
    const deletedObat = await Obats.findByIdAndDelete(id);
    if (!deletedObat) {
      return res.status(404).json({ message: "Obat tidak ditemukan" });
    }
    res.status(200).json({ message: "Obat berhasil dihapus" });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Terjadi kesalahan", error: error.message });
  }
};
module.exports = {
  login,
  register,
  forgotPassword,
  getSuggest,
  getObatSearch,
  getUser,
  getDetailObat,
  updateUser,
  getObats,
  updateObat,
  deleteObats,
};
