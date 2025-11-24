# GoSport(mobile) - A08 PBP

## Anggota Kelompok
- Carmella Geraldine Sutrisna
- Sherin Khaira Alya Mirabel
- Muhammad Yufan Jonni
- Johannes Nichola Simatupang
- Muhammad Ibaadi Ilmi

## Deskripsi Aplikasi
**GoSport** adalah aplikasi e-commerce yang menjual berbagai **peralatan olahraga** seperti sepatu, raket, bola, dan perlengkapan gym. Aplikasi ini memudahkan pengguna untuk mencari, membandingkan, dan membeli produk olahraga dari berbagai kategori.
Tujuan utama kami adalah mendukung gaya hidup sehat masyarakat dengan menyediakan platform digital yang mudah digunakan dan informatif.

## Daftar Modul
1. Autentikasi + Dashboard Profile: Login, register. (Carmella)
   - Create: Simpan data user baru: username, password (hashed), dan role (pembeli atau penjual).
   - Read: Lihat data profile sendiri.
   - Update: Ubah username dan/atau password.
   - Delete: Hapus akun.
4. Produk: Menampilkan daftar produk olahraga (initial dataset 100+ produk). (Sherin)
   - Create: Tambah produk baru (nama produk, harga, kategori, thumbnail).
   - Read: Lihat daftar atau detail produk.
   - Update: Edit produk oleh penjual produk tsb atau admin.
   - Delete: Hapus produk oleh penjual produk tsb atau admin.
5. Keranjang Belanja: Menyimpan produk yang ingin dibeli pengguna sebelum checkout. (Johannes)
   - Create: Tambah produk ke keranjang (hanya untuk user dengan role pembeli).
   - Read: Lihat isi keranjang user (pembeli) tsb.
   - Update: Ubah jumlah item yang ingin dibeli di keranjang.
   - Delete: Hapus item dari keranjang.
6. Pembayaran - Mengelola proses transaksi dan pembayaran. (Ilmi)
   - Create: Buat pesanan baru saat checkout.
   - Read: Lihat detail transaksi.
   - Update: Update status pembayaran.
   - Delete: Batalkan pembayaran.
7. Ulasan Produk - Pengguna dapat memberi rating dan review pada produk. (Yufan)
   - Create: Tambah ulasan & rating (bintang 1-5) produk.
   - Read: Lihat daftar ulasan produk.
   - Update: Edit ulasan yang diberi user (pembeli) tsb.
   - Delete: Hapus ulasan.

## Sumber Dataset
Dataset awal diambil dari [Kaggle](https://www.kaggle.com/datasets/shouvikdey21/sports-ecommerce-products-dataset) — *Sports ECommerce Products Dataset* 

Dataset mencakup 100+ produk olahraga dengan atribut seperti:
- Product Name: Nama produk olahraga.
- Old Price: Harga asli produk sebelum diskon.
- Special Price: Harga produk setelah diskon diterapkan.
- Discount: Persentase potongan harga dari harga asli.
- Product: Kategori atau jenis produk olahraga (misalnya: Sepatu, Bola, Raket, dll).

## Jenis Pengguna
1. Admin - Mengelola data produk, dan transaksi.
2. Penjual - Dapat login, register, dan menambah produk.
3. Pembeli - Dapat login, register, membeli produk, dan memberikan ulasan.

## Alur Pengintegrasian
Pengintegrasian aplikasi Flutter dengan web service (backend Django waktu Proyek Tengah Semester) dilakukan melalui serangkaian request–response berbasis JSON. Alurnya sebagai berikut:
1. Login
   - Flutter mengirim POST JSON berisi kredensial (email/username & password).
   - Server mengembalikan JSON user berisi status login, token/session, dan data profil dasar.
2. Register
   - Flutter melakukan POST JSON data pendaftaran.
   - Server membalas dengan JSON sukses atau pesan kesalahan.
3. Produk
   - Flutter melakukan GET JSON ke endpoint produk.
   - Server mengembalikan JSON list produk yang ditampilkan di UI aplikasi.
4. Keranjang – Tambah
   - Flutter mengirim POST JSON dengan informasi produk yang ingin dimasukkan ke keranjang.
   - Server menyimpan update dan merespon JSON status sukses.
5. Keranjang – Lihat Isi
   - Flutter menembak GET JSON untuk mengambil daftar item keranjang.
   - Server mengembalikan JSON isi keranjang untuk ditampilkan pada halaman Cart.
6. Keranjang – Update
   - Flutter mengirim POST JSON perubahan kuantitas.
   - Server membalas dengan JSON kondisi terbaru keranjang.
7. Checkout
   - Flutter mengirim POST JSON permintaan checkout.
   - Server membuat transaksi dan mengembalikan JSON transaksi, termasuk ID transaksi, total harga, dan status.
8. Transaksi – Riwayat
   - Flutter melakukan GET JSON untuk mengambil riwayat transaksi user.
   - Server membalas dengan JSON list transaksi.
9. Review – Tambah
    - Flutter mengirim POST JSON berisi ulasan untuk suatu produk.
    - Server menyimpan review dan mengembalikan JSON sukses.
10. Review – List
    - Flutter melakukan GET JSON ke endpoint review.
    - Server mengembalikan JSON list ulasan terkait produk.
   
## Link Figma
https://www.figma.com/design/fJYS62TdZ2JrQ0HYZ1bBDr/GoSport?node-id=0-1&t=Gurqi3k1Xt31KbDU-1

## Link Progress Plan
https://docs.google.com/spreadsheets/d/1MuF_YgV212tpJbHWSp8vy-Kh_pzi_pVWmywyIWC_wN8/edit?usp=sharing
