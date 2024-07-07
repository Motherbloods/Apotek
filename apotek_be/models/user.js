const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  email: { type: String, required: true },
  fullname: { type: String },
  password: { type: String, required: true },
  image: { type: String, required: false, default: "../images/default.jpeg" },
  token: { type: String },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

const Users = mongoose.model("Users", userSchema);

module.exports = Users;
