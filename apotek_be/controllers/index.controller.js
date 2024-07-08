const Obats = require("../models/obat");
const Users = require("../models/user");
const SearchHistory = require("../models/searchHistory");
const SearchSugest = require("../models/searchSuggest");

const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

const cloudinary = require("cloudinary").v2;

cloudinary.config({
  cloud_name: process.env.CLOUD_NAME,
  api_key: process.env.API_KEY,
  api_secret: process.env.API_SECRET,
});

const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: "Email dan password harus diisi.",
      });
    }

    const user = await Users.findOne(
      { email },
      { email: 1, password: 1, fullname: 1 }
    ).lean();
    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({
        success: false,
        message: "Email atau password salah.",
      });
    }

    const token = jwt.sign(
      { id: user._id, email: user.email, fullname: user.fullname },
      process.env.SECRET_TOKEN,
      { expiresIn: "1d" }
    );

    await Users.updateOne({ _id: user._id }, { $set: { token } });

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
      message: "Terjadi kesalahan saat memproses permintaan login.",
      error: process.env.NODE_ENV === "development" ? err.message : undefined,
    });
  }
};

const register = async (req, res) => {
  try {
    const { email, password, confirmPassword } = req.body;
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

    const existingUser = await Users.findOne({ email }, { _id: 1 }).lean();
    if (existingUser) {
      return res.status(409).json({
        success: false,
        status: 409,
        message: "Pengguna dengan email ini sudah terdaftar.",
      });
    }

    const hashPassword = await bcrypt.hash(password, 10);
    const newUser = await Users.create({ email, password: hashPassword });

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

const getSuggest = async (req, res) => {
  try {
    const { q: query, userId } = req.query;
    let response = [];

    if (userId) {
      response = await SearchHistory.find({ userId })
        .sort({ date: -1 })
        .limit(5)
        .lean();
    } else if (query?.trim()) {
      response = await SearchSugest.find({
        suggest: { $regex: query.trim(), $options: "i" },
      })
        .sort({ jmlDicari: -1 })
        .limit(5)
        .lean();
    }

    res.status(200).json(response);
  } catch (err) {
    console.error("Error dalam getSuggest:", err);
    res.status(500).json({
      success: false,
      message: "Terjadi kesalahan saat mengambil saran pencarian.",
    });
  }
};

const getObatSearch = async (req, res) => {
  try {
    const { q: query, userId } = req.query;

    if (!query?.trim()) {
      return res.status(400).json({
        success: false,
        message: "Parameter pencarian tidak boleh kosong.",
      });
    }

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
    }).lean();
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
    const { userId } = req.params;
    const { email, fullname, imageurl } = req.body;

    if (!userId) {
      return res.status(400).json({
        success: false,
        message: "ID pengguna diperlukan",
      });
    }
    const updateData = { email, fullname };

    if (req.file) {
      try {
        const result = await uploadToCloudinary(req.file);
        updateData.image = result.secure_url;
      } catch (uploadError) {
        console.error("Error uploading image to Cloudinary:", uploadError);
        return res.status(500).json({
          success: false,
          message: "Terjadi kesalahan saat mengunggah gambar",
          error:
            process.env.NODE_ENV === "development"
              ? uploadError.message
              : undefined,
        });
      }
    } else if (req.body.imageUrl) {
      updateData.image = req.body.imageUrl;
    }

    const updatedUser = await Users.findByIdAndUpdate(userId, updateData, {
      new: true,
    }).lean();

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

const uploadToCloudinary = (file) => {
  return new Promise((resolve, reject) => {
    const uploadStream = cloudinary.uploader.upload_stream(
      { resource_type: "auto" },
      (error, result) => {
        if (error) reject(error);
        else resolve(result);
      }
    );
    uploadStream.end(file.buffer);
  });
};

const updateObat = async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(404).json({ error: "ID not provided" });
    }

    const { name, desc, price, category, stock } = req.body;
    let imageUrl = JSON.parse(req.body.imageUrl || "[]");

    // Handle new image uploads
    if (req.files && req.files.length > 0) {
      const uploadPromises = req.files.map(
        (file) =>
          new Promise((resolve, reject) => {
            const uploadStream = cloudinary.uploader.upload_stream(
              { resource_type: "auto" },
              (error, result) => {
                if (error) reject(error);
                else resolve(result.secure_url);
              }
            );
            uploadStream.end(file.buffer);
          })
      );
      const newCloudinaryUrls = await Promise.all(uploadPromises);
      imageUrl = [...imageUrl, ...newCloudinaryUrls];
    }
    imageUrl = imageUrl.filter(
      (url) => url.startsWith("/images") || url.startsWith("https")
    );

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
    const obats = await Obats.find().lean();
    res.status(200).json(obats);
  } catch (err) {
    console.error("Error fetching medicines:", err);
    res.status(500).json({ message: "Error fetching medicines" });
  }
};

const deleteObats = async (req, res) => {
  const id = req.params.id;

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

  getSuggest,
  getObatSearch,
  getUser,
  getDetailObat,
  updateUser,
  getObats,
  updateObat,
  deleteObats,
};
