# Aplikasi Apotek

Aplikasi Apotek adalah sebuah aplikasi mobile yang memungkinkan pengguna untuk mencari, melihat, dan mengelola informasi obat-obatan.

## Fitur Utama

- Pencarian obat
- Tampilan detail obat
- Manajemen stok obat
- Autentikasi pengguna
- CRUD Obat
- Profil pengguna

## Teknologi yang Digunakan

- Flutter untuk pengembangan aplikasi mobile
- Node.js untuk backend
- MongoDB untuk database

## Cara Memulai

### Prasyarat

- Flutter SDK
- Node.js
- MongoDB

### Instalasi

1. Clone repositori ini

```bash
git clone https://github.com/Motherbloods/Apotek.git
cd Apotek
```

2. Instal dependencies untuk backend (Node JS):

```bash
cd apotek_be
npm install
```

3. Instal dependencies untuk frontend (Flutter):

```bash
cd apotek_fe
flutter pub get
```

4. Atur variabel lingkungan di file `.env`
5. Jalankan server backend:

```bash
node app.js
```

6. Jalankan aplikasi Flutter:

```bash
flutter run
```

## Struktur Proyek
- `apotek_be/`: Berisi kode server Node.js
- `apotek_fe/`: Berisi kode Flutter untuk frontend
- `models/`: Definisi model data
- `controllers/`: Logic bisnis 
- `utils/`: Fungsi utilitas dan helper

## Kontribusi
Kontribusi selalu diterima dengan baik. Silakan buat pull request atau buka issue untuk saran dan perbaikan.

## Kontak
[Habib Risky Kurniawan] - [motherbloodss]
