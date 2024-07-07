const mongoose = require("mongoose");

const searchHistorySchema = new mongoose.Schema({
  searchValue: {
    type: String,
  },
  userId: {
    type: String,
    ref: "Users",
  },
  date: {
    type: Date,
    default: Date.now,
  },
});
const SearchHistory = mongoose.model(
  "SearchHistoryApotek",
  searchHistorySchema
);

module.exports = SearchHistory;
