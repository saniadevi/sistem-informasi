import 'package:flutter/material.dart';

/// Palet warna tema aplikasi — nuansa biru muda & putih yang lembut,
/// bersih, dan modern. Dipakai bersama di Splash, Login, Register,
/// Profile & Edit Profile supaya seluruh aplikasi terasa satu kesatuan.
class AppColors {
  AppColors._();

  // ===== Biru (warna utama) =====
  static const Color primaryLight = Color(0xFF6FB3F7); // biru muda cerah
  static const Color primaryMid = Color(0xFF2E86F0); // biru sedang (brand)
  static const Color primaryDark = Color(0xFF0B4A9C); // biru tua elegan

  // Alias lama supaya tetap konsisten dipakai di semua layar
  static const Color indigoGelap = primaryDark;
  static const Color indigoSedang = primaryMid;
  static const Color indigoMuda = primaryLight;
  static const Color indigoSoft = Color(0xFFBFDDFB); // biru pastel lembut

  // Warna teks/label aksen (dipakai untuk label field, judul kecil & link)
  static const Color merahTua = primaryDark;
  static const Color aksen = primaryMid;

  // ===== Netral / Putih =====
  static const Color putih = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF3F8FE); // putih kebiruan lembut
  static const Color fieldBackground = Color(0xFFF0F6FE);
  static const Color fieldBorder = Color(0xFFDCE9FA);
  static const Color abuTeks = Color(0xFF8996A8);
  static const Color abuBorder = Color(0xFFE1EBF7);
  static const Color teksGelap = Color(0xFF1C2B3A);

  // ===== Status =====
  static const Color sukses = Color(0xFF2FAE60);
  static const Color error = Color(0xFFE0554D);

  // ===== Varian Dark Mode =====
  static const Color backgroundDark = Color(0xFF0E1621);
  static const Color surfaceDark = Color(0xFF1A2530);
  static const Color fieldBackgroundDark = Color(0xFF212E3B);
  static const Color fieldBorderDark = Color(0xFF2E3D4C);
  static const Color abuTeksDark = Color(0xFF93A4B5);
  static const Color abuBorderDark = Color(0xFF2A3947);
  static const Color teksGelapDark = Color(0xFFECF2F8);

  /// Gradient utama untuk header & background (biru muda -> biru tua)
  static const LinearGradient gradientUtama = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primaryDark],
  );

  /// Gradient tombol (biru sedang -> biru tua, lembut & elegan)
  static const LinearGradient gradientTombol = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryMid, primaryDark],
  );

  /// Gradient khusus Splash Screen — nuansa biru muda yang smooth & fresh
  static const LinearGradient gradientSplash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryLight, primaryMid, primaryDark],
  );
}
