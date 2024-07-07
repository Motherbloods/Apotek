const express = require("express");
const router = express.Router();

const {
  login,
  register,
  forgotPassword,
  getSuggest,
  getUser,
  getDetailObat,
  updateUser,
  getObats,
  updateObat,
} = require("../controllers/index.controller");

router.post("/api/login", login);
router.post("/api/register", register);
router.post("/api/forgot-pass", forgotPassword);
router.get("/api/getSuggest", getSuggest);
router.get("/api/get-obat", getObats);
router.get("/api/getUser/:userId", getUser);
router.get("/api/getUser/:id", getDetailObat);
router.put("/api/updateUser", updateUser);
router.put("/api/update-obat/:id", updateObat);

module.exports = router;
