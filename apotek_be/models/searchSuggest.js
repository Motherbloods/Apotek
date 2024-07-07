const mongoose = require("mongoose");

const searchSugestSchema = new mongoose.Schema({
  suggest: {
    type: String,
  },
  jmlDicari: {
    type: Number,
  },
});
const SearchSugest = mongoose.model("SearchSugestApotek", searchSugestSchema);

module.exports = SearchSugest;
