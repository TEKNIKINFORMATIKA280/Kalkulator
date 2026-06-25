# 🧮 Kalkulator Pintar (Smart Calculator)

![Kalkulator Preview](assets/screenshots/preview.png)

Kalkulator Pintar adalah aplikasi kalkulator multi-platform yang dibangun menggunakan **Flutter**. Aplikasi ini dirancang dengan antarmuka yang modern, responsif, dan kaya akan fitur, mulai dari operasi matematika dasar hingga perhitungan ilmiah yang kompleks.

## 🚀 Fitur Utama

- **Operasi Dasar & Ilmiah**: Mendukung penambahan, pengurangan, perkalian, pembagian, serta fungsi ilmiah seperti Trigonometri (Sin, Cos, Tan), Logaritma (Log, Ln), Pangkat, Akar Kuadrat, Faktorial, dan konstanta matematika (π, e).
- **Mode Gelap & Terang**: Mendukung peralihan tema secara manual melalui menu pengaturan yang tersimpan secara permanen.
- **Efek Suara & Bayangan**: Tombol dilengkapi dengan efek suara klik yang elegan dan desain bayangan (shadow) modern untuk memberikan sensasi tombol fisik.
- **Riwayat Perhitungan**: Menyimpan riwayat perhitungan sebelumnya lengkap dengan waktu, memudahkan pengguna untuk melihat kembali hasil kerja mereka.
- **Desain Responsif**: Antarmuka adaptif yang bekerja sempurna di perangkat Mobile (Android/iOS) dan Desktop (Windows).
- **Lokalisasi Indonesia**: Menggunakan tanda koma (`,`) sebagai pemisah desimal sesuai standar Indonesia.
- **Tombol Bulat Modern**: Desain tombol lingkaran yang estetik dan nyaman untuk disentuh.

## 🛠️ Teknologi yang Digunakan

- **Framework**: [Flutter](https://flutter.dev/)
- **Bahasa**: Dart
- **Manajemen Data**: `shared_preferences` (untuk pengaturan dan riwayat)
- **Logika Matematika**: `math_expressions`
- **Audio**: `audioplayers`
- **CI/CD**: GitHub Actions (Otomatisasi build APK dan Windows)

## 📥 Cara Mengunduh

Anda dapat mengunduh versi terbaru aplikasi langsung dari halaman **Releases** di repository GitHub ini:

1.  Buka tab **Releases** di sebelah kanan halaman.
2.  Pilih versi terbaru.
3.  Unduh file sesuai perangkat Anda:
    - **Android**: Download `app-release.apk`
    - **Windows**: Download `kalkulator-windows.zip` (Ekstrak lalu jalankan file `.exe`)

## ⚙️ Instalasi & Pengembangan

Jika Anda ingin menjalankan proyek ini secara lokal atau melakukan pengembangan:

1.  **Clone repository**:
    ```bash
    git clone https://github.com/TEKNIKINFORMATIKA280/Kalkulator.git
    ```
2.  **Masuk ke direktori**:
    ```bash
    cd Kalkulator
    ```
3.  **Ambil dependensi**:
    ```bash
    flutter pub get
    ```
4.  **Jalankan aplikasi**:
    ```bash
    flutter run
    ```

## 🤖 Build Otomatis (CI/CD)

Proyek ini telah dikonfigurasi dengan GitHub Actions. Setiap kali Anda melakukan `push` ke branch `main`, GitHub akan otomatis:
- Menghasilkan icon aplikasi (`mipmap`).
- Membangun file installer untuk Android (APK).
- Membangun file executable untuk Windows (ZIP).
- Membuat draft release secara otomatis.

---
Dibuat dengan ❤️ menggunakan Flutter.
