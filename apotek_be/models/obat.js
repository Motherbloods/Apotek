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
    name: "Amoxicillin",
    description: "Antibiotik untuk mengobati infeksi bakteri",
    price: 25000,
    category: "Obat Pilek",
    imageUrl: ["/images/Amoxicillin.jpeg", "/images/Amoxicillin 2.jpeg"],
    stock: 50,
  },
  {
    name: "Vitamin C",
    description: "Suplemen untuk meningkatkan daya tahan tubuh",
    price: 30000,
    category: "Obat Batuk",
    imageUrl: ["/images/Vitamin C.jpeg", "/images/Vitamin C 2.jpeg"],
    stock: 200,
  },
  {
    name: "Omeprazole",
    description: "Obat untuk mengurangi produksi asam lambung",
    price: 15000,
    category: "Obat Panas",
    imageUrl: [
      "/images/Omeprazole.jpeg",
      "/images/Omeprazole 2.jpeg",
      "/images/Omeprazole 3.jpeg",
    ],
    stock: 75,
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
    name: "Acetylcysteine",
    description: "Obat untuk mengencerkan dahak",
    price: 35000,
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    category: "Obat Pilek",
    stock: 60,
  },
  {
    name: "Metformin",
    description: "Obat untuk mengontrol kadar gula darah",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 18000,
    category: "Obat Batuk",
    stock: 40,
  },
  {
    name: "Loratadine",
    description: "Antihistamin untuk mengatasi alergi",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 12000,
    category: "Obat Pilek",
    stock: 90,
  },
  {
    name: "Ibuprofen",
    description: "Obat anti-inflamasi non-steroid untuk meredakan nyeri",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 8000,
    category: "Obat Pilek",
    stock: 120,
  },
  {
    name: "Multivitamin",
    description: "Suplemen yang mengandung berbagai vitamin esensial",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 40000,
    category: "Obat Batuk",
    stock: 150,
  },

  {
    name: "Cetirizine",
    description: "Antihistamin untuk mengatasi gejala alergi",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 10000,
    category: "Obat Pilek",
    stock: 85,
  },
  {
    name: "Lansoprazole",
    description: "Obat untuk mengurangi asam lambung dan mengobati GERD",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 28000,
    category: "Obat Batuk",
    stock: 55,
  },
  {
    name: "Kunyit Asam",
    description: "Minuman herbal untuk meredakan nyeri haid",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 15000,
    category: "Obat Panas",
    stock: 70,
  },
  {
    name: "Simvastatin",
    description: "Obat untuk menurunkan kadar kolesterol",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 22000,
    category: "Obat Panas",
    stock: 45,
  },
  {
    name: "Probiotik",
    description: "Suplemen untuk menjaga kesehatan pencernaan",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 35000,
    category: "Obat Batuk",
    stock: 110,
  },
  {
    name: "Salbutamol",
    description: "Obat untuk mengatasi serangan asma",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 30000,
    category: "Obat Pilek",
    stock: 40,
  },
  {
    name: "Glucosamine",
    description: "Suplemen untuk kesehatan sendi",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 45000,
    category: "Obat Batuk",
    stock: 65,
  },
  {
    name: "Dexamethasone",
    description: "Obat steroid untuk mengurangi peradangan",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 20000,
    category: "Obat Batuk",
    stock: 30,
  },
  {
    name: "Temulawak",
    description: "Jamu untuk meningkatkan nafsu makan",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 12000,
    category: "Obat Panas",
    stock: 95,
  },
  {
    name: "Amlodipine",
    description: "Obat untuk mengontrol tekanan darah tinggi",
    imageUrl: [
      "/images/Paracetamol.jpeg",
      "/images/Paracetamol 2.jpg",
      "/images/Paracetamol 3.png",
    ],
    price: 18000,
    category: "Obat Panas",
    stock: 60,
  },
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
