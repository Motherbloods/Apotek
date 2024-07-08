const express = require("express");
const router = express.Router();
const upload = require("../utils/multer");

const {
  login,
  register,
  getSuggest,
  getUser,
  getDetailObat,
  updateUser,
  getObats,
  updateObat,
  deleteObats,
  getObatSearch,
} = require("../controllers/index.controller");

router.post("/api/login", login);
router.post("/api/register", register);

router.get("/api/get-obat", getObats);
router.get("/api/user", getUser);
router.get("/api/search-obats", getObatSearch);
router.get("/api/suggest", getSuggest);

router.put("/api/user/:userId", upload.single("image"), updateUser);
router.put("/api/update-obat/:id", upload.array("images", 100), updateObat);

router.delete("/api/delete-obat/:id", deleteObats);

module.exports = router;
