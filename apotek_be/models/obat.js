const mongoose = require("mongoose");

const obatSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  category: {
    type: String,
    enum: ["Obat Pilek", "Obat Batuk", "Obat Panas"],
    required: true,
  },
  imageUrl: {
    type: [String],
    default: "",
  },
  stock: {
    type: Number,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

const Obats = mongoose.model("Obats", obatSchema);

module.exports = Obats;

const obatsSample = [
  //Panas
  {
    name: "Paracetamol",
    description: "Obat untuk meredakan demam dan nyeri ringan",
    price: 5000,
    category: "Obat Panas",
    stock: 100,
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
  },
  {
    name: "Jahe Merah",
    description: "Obat Panas untuk meredakan masuk angin",
    price: 20000,
    category: "Obat Panas",
    imageUrl: [
      "/images/Omeprazole.jpeg",
      "/images/Omeprazole 2.jpeg",
      "/images/Omeprazole 3.jpeg",
    ],
    stock: 80,
  },

  {
    name: "Ibuprofen",
    description: "Obat anti-inflamasi non-steroid untuk meredakan nyeri",
    imageUrl: [
      "/images/Ibuprofen 1.jpeg",
      "/images/Ibuprofen 3.jpeg",
      "/images/Ibuprofen 2.png",
    ],
    price: 8000,
    category: "Obat Panas",
    stock: 120,
  },
  {
    name: "Aspirin",
    description:
      "Obat yang digunakan untuk meredakan nyeri dan demam serta mengurangi peradangan.",
    imageUrl: ["/images/Aspirin 1.jpg", "/images/Aspirin 2.jpg"],
    price: 9000,
    category: "Obat Panas",
    stock: 120,
  },
  {
    name: "Meclizine",
    description:
      "Obat untuk mengatasi mual, muntah, dan pusing yang disebabkan oleh mabuk perjalanan atau vertigo",
    imageUrl: ["/images/Meclizine 1.jpg", "/images/Meclizine 2.jpg"],
    price: 8000,
    category: "Obat Panas",
    stock: 120,
  },
  {
    name: "Dimenhydrinate",
    description:
      "Obat untuk mencegah dan mengobati mual, muntah, serta pusing akibat mabuk perjalanan",
    imageUrl: ["/images/Dimenhydrinate 1.jpg", "/images/Dimenhydrinate 2.jpg"],
    price: 8000,
    category: "Obat Panas",
    stock: 120,
  },
  {
    name: "Prochlorperazine",
    description:
      "Obat untuk mengobati mual dan muntah serta gejala psikosis seperti skizofrenia",
    imageUrl: [
      "/images/Prochlorperazine 1.jpg",
      "/images/Prochlorperazine 2.jpg",
    ],
    price: 8000,
    category: "Obat Panas",
    stock: 120,
  },
  {
    name: "Diazepam",
    description:
      "Obat untuk mengatasi kecemasan, kejang otot, dan gejala penarikan alkohol",
    imageUrl: ["/images/Diazepam 1.jpg", "/images/Diazepam 2.jpg"],
    price: 8000,
    category: "Obat Panas",
    stock: 120,
  },
  {
    name: "Metoclopramide",
    description:
      "Obat untuk mengobati mual dan muntah serta masalah pergerakan perut seperti gastroparesis",
    imageUrl: ["/images/Metoclopramide 1.jpg", "/images/Metoclopramide 2.jpg"],
    price: 8000,
    category: "Obat Panas",
    stock: 120,
  },
  //End Panas
  //Pilek
  {
    name: "Cetirizine",
    description: "Antihistamin untuk mengatasi gejala alergi",
    imageUrl: [
      "/images/Cetirizine 1.jpeg",
      "/images/Cetirizine 3.jpg",
      "/images/Cetirizine 2.png",
    ],
    price: 10000,
    category: "Obat Pilek",
    stock: 85,
  },
  {
    name: "Intunal",
    description:
      "Obat untuk mengatasi gejala pilek dan flu seperti hidung tersumbat dan demam",
    imageUrl: [
      "/images/Intunal 1.jpg",
      "/images/Intunal 3.jpg",
      "/images/Intunal 2.jpg",
    ],
    price: 10000,
    category: "Obat Pilek",
    stock: 85,
  },
  {
    name: "Panadol",
    description:
      "Obat untuk meredakan nyeri ringan hingga sedang serta mengurangi demam",
    imageUrl: [
      "/images/Panadol 1.jpg",
      "/images/Panadol 3.jpg",
      "/images/Panadol 2.jpg",
    ],
    price: 10000,
    category: "Obat Pilek",
    stock: 85,
  },
  {
    name: "Anadex",
    description:
      " Obat untuk meredakan gejala pilek dan alergi seperti hidung tersumbat dan bersin-bersin",
    imageUrl: [
      "/images/Anadex 1.jpg",
      "/images/Anadex 3.jpg",
      "/images/Anadex 2.jpg",
    ],
    price: 10000,
    category: "Obat Pilek",
    stock: 85,
  },
  {
    name: "Demacolin",
    description:
      "Obat kombinasi untuk meredakan gejala pilek dan flu seperti hidung tersumbat dan demam",
    imageUrl: [
      "/images/Demacolin 1.jpg",
      "/images/Demacolin 3.jpg",
      "/images/Demacolin 2.jpg",
    ],
    price: 10000,
    category: "Obat Pilek",
    stock: 85,
  },
  {
    name: "Rhinofed",
    description:
      "Obat untuk mengatasi gejala hidung tersumbat akibat pilek atau alergi",
    imageUrl: ["/images/Rhinofed.jpg", "/images/Rhinofed 2.jpg"],
    price: 10000,
    category: "Obat Pilek",
    stock: 85,
  },
  {
    name: "Rhinos",
    description:
      "Obat untuk meredakan gejala hidung tersumbat, bersin, dan gatal-gatal akibat pilek atau alergi",
    imageUrl: [
      "/images/Rhinos 1.jpg",
      "/images/Rhinos 3.jpg",
      "/images/Rhinos 2.jpg",
    ],
    price: 10000,
    category: "Obat Pilek",
    stock: 85,
  },
  {
    name: "Nalgestan",
    description:
      "Obat untuk meredakan gejala pilek dan flu seperti hidung tersumbat, bersin, dan sakit kepala",
    imageUrl: [
      "/images/Nalgestan 1.jpg",
      "/images/Nalgestan 3.jpg",
      "/images/Nalgestan 2.jpg",
    ],
    price: 10000,
    category: "Obat Pilek",
    stock: 85,
  },
  {
    name: "Alpara",
    description:
      "Obat untuk mengatasi gejala pilek dan flu seperti hidung tersumbat dan demam",
    imageUrl: [
      "/images/Alpara 1.jpg",
      "/images/Alpara 3.jpg",
      "/images/Alpara 2.jpg",
    ],
    price: 10000,
    category: "Obat Pilek",
    stock: 85,
  },

  //End Pilek
  //Batuk
  {
    name: "Dexamethasone",
    description: "Obat steroid untuk mengurangi peradangan",
    imageUrl: ["/images/Dexamethasone 1.jpeg", "/images/Dexamethasone 2.jpeg"],
    price: 20000,
    category: "Obat Batuk",
    stock: 30,
  },
  {
    name: "BroncoStop",
    description: "Sirup batuk dengan ekstrak herbal",
    imageUrl: ["/images/BroncoStop 1.jpg", "/images/BroncoStop 2.jpeg"],
    price: 35000,
    category: "Obat Batuk",
    stock: 50,
  },
  {
    name: "CoughEase",
    description: "Tablet hisap pereda batuk kering",
    imageUrl: ["/images/CoughEase1.jpeg", "/images/CoughEase2.jpeg"],
    price: 15000,
    category: "Obat Batuk",
    stock: 100,
  },
  {
    name: "Vicks",
    description: "Ekspektoran untuk batuk berdahak",
    imageUrl: ["/images/Vicks1.jpg", "/images/Vicks2.jpg"],
    price: 25000,
    category: "Obat Batuk",
    stock: 40,
  },
  {
    name: "Laserin",
    description: "Sirup batuk khusus malam hari",
    imageUrl: ["/images/Laserin1.jpeg", "/images/Laserin2.jpg"],
    price: 30000,
    category: "Obat Batuk",
    stock: 60,
  },
  {
    name: "OBH Combi",
    description: "Sirup batuk rasa buah untuk anak-anak",
    imageUrl: ["/images/Combi1.jpg", "/images/Combi2.jpeg"],
    price: 28000,
    category: "Obat Batuk",
    stock: 75,
  },
  {
    name: "Bisolvon",
    description: "Obat batuk alami dari ramuan herbal",
    imageUrl: ["/images/Bisolvon1.jpeg", "/images/Bisolvon2.jpeg"],
    price: 22000,
    category: "Obat Batuk",
    stock: 45,
  },
  {
    name: "WOODS",
    description: "Obat batuk tablet dengan efek cepat",
    imageUrl: ["/images/WOODS1.jpeg", "/images/WOODS2.jpeg"],
    price: 18000,
    category: "Obat Batuk",
    stock: 90,
  },
  {
    name: "PEIPAKOA",
    description: "Spray tenggorokan untuk meredakan batuk",
    imageUrl: ["/images/PEIPAKOA1.jpeg", "/images/PEIPAKOA2.jpeg"],
    price: 40000,
    category: "Obat Batuk",
    stock: 35,
  },
  //End Batuk
];

// mongoose
//   .connect(
//     "mongodb+srv://motherbloodss:XKFofTN9qGntgqbo@cluster0.ejyrmvc.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0",
//     {
//       useNewUrlParser: true,
//       useUnifiedTopology: true,
//     }
//   )
//   .then(async () => {
//     console.log("Connected to MongoDB");
//     await Obats.insertMany(obatsSample);

//     console.log("Dummy seller created:", obatsSample);

//     mongoose.disconnect();
//   })
//   .catch((err) => {
//     console.error("Error connecting to MongoDB", err);
//   });
