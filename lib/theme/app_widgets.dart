import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Lingkaran dekorasi soft (dipakai di header lama & sebagai fallback)
Widget buildDecorCircle(double size, Color color) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

/// Blob/lingkaran organik dengan gradasi radial, dipakai di background
/// Splash Screen supaya terlihat seperti bentuk abstrak yang lembut.
Widget buildBlobCircle({
  required double size,
  required List<Color> colors,
  double opacity = 1,
}) {
  return Opacity(
    opacity: opacity,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: colors,
          center: const Alignment(-0.3, -0.3),
        ),
      ),
    ),
  );
}

/// Label kecil di atas text field, misalnya "NIM", "Password"
Widget buildFieldLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: AppColors.teksGelap,
      fontSize: 12.5,
      fontWeight: FontWeight.w600,
    ),
  );
}

/// Text field bergaya minimalis modern (label di atas, kotak biru muda
/// lembut, sudut membulat, border tipis) — dipakai di semua form.
Widget buildAuthTextField({
  required TextEditingController controller,
  required String hint,
  IconData? icon,
  bool obscureText = false,
  Widget? suffixIcon,
  TextInputType keyboardType = TextInputType.text,
  bool enabled = true,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    decoration: BoxDecoration(
      color: enabled
          ? AppColors.fieldBackground
          : AppColors.fieldBackground.withOpacity(0.5),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.fieldBorder),
    ),
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      cursorColor: AppColors.primaryMid,
      style: const TextStyle(fontSize: 14, color: AppColors.teksGelap),
      decoration: InputDecoration(
        prefixIcon: icon == null
            ? null
            : Icon(icon, color: AppColors.primaryMid, size: 20),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.abuTeks, fontSize: 13),
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      ),
    ),
  );
}

/// Tombol utama solid gradient biru (Sign In / Sign Up / Simpan)
Widget buildPrimaryButton({
  required String text,
  required VoidCallback? onPressed,
  bool isLoading = false,
}) {
  return Container(
    height: 54,
    decoration: BoxDecoration(
      gradient: AppColors.gradientTombol,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryMid.withOpacity(0.35),
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isLoading ? null : onPressed,
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.4,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                  ),
                ),
        ),
      ),
    ),
  );
}

/// Tombol sekunder outline (mis. "Bersihkan Form", "Logout", "Hapus Akun").
/// `color` opsional untuk mewarnai teks & border (mis. merah untuk aksi hapus).
Widget buildSecondaryButton({
  required String text,
  required VoidCallback onPressed,
  Color? color,
}) {
  final Color c = color ?? AppColors.primaryDark;
  return Container(
    height: 50,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: c.withOpacity(0.45), width: 1.2),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: c,
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    ),
  );
}

/// Tombol panah kembali bulat putih, dipakai di pojok kiri atas
/// halaman Login & Register.
Widget buildAuthBackButton(VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.fieldBackground,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: const Icon(Icons.arrow_back_ios_new,
          size: 16, color: AppColors.teksGelap),
    ),
  );
}

/// Tombol bulat putih kecil berisi ikon "more/menu", dipakai di header
/// Profile (mis. untuk logout).
Widget buildMoreButton({required VoidCallback onPressed}) {
  return InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.logout_rounded, size: 18, color: Colors.white),
    ),
  );
}

/// Kartu putih dengan sudut membulat besar & shadow lembut biru,
/// dipakai untuk membungkus konten utama (mis. info profil).
class AuthCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const AuthCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 24, 20, 24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Baris checkbox kecil (mis. "Remember me" / "I agree to the processing
/// of Personal data").
Widget buildAuthCheckboxRow({
  required bool value,
  required ValueChanged<bool?> onChanged,
  required Widget label,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: 22,
        height: 22,
        child: Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryMid,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(child: label),
    ],
  );
}

/// Baris ikon sosial dekoratif ("Sign in with" / "Sign up with").
/// Tap menampilkan info bahwa fitur belum tersedia.
Widget buildSocialRow(BuildContext context) {
  Widget socialIcon(IconData icon) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => showAppSnackBar(context, "Fitur belum tersedia"),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.fieldBackground,
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Icon(icon, size: 19, color: AppColors.primaryMid),
      ),
    );
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      socialIcon(Icons.facebook),
      const SizedBox(width: 14),
      socialIcon(Icons.alternate_email),
      const SizedBox(width: 14),
      socialIcon(Icons.g_mobiledata),
      const SizedBox(width: 14),
      socialIcon(Icons.apple),
    ],
  );
}

/// SnackBar bergaya rounded floating, dipakai untuk notifikasi ringan
/// (bukan validasi form — untuk validasi gunakan [showAppAlertDialog]).
void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? AppColors.error : AppColors.primaryDark,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ),
  );
}

/// Alert/dialog validasi form yang muncul rapi di TENGAH layar,
/// dengan ikon bulat, animasi pop, dan tombol "OK" bergradient.
/// Dipakai untuk semua validasi form (field kosong, password tidak
/// cocok, dsb) maupun pesan sukses (login/registrasi berhasil).
Future<void> showAppAlertDialog(
  BuildContext context, {
  required String message,
  String? title,
  bool isError = false,
  VoidCallback? onOk,
}) {
  final Color mainColor = isError ? AppColors.error : AppColors.sukses;
  final String dialogTitle = title ?? (isError ? "Oops!" : "Berhasil");

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Tutup",
    barrierColor: Colors.black.withOpacity(0.35),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
    transitionBuilder: (context, anim, secondaryAnim, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
      return Opacity(
        opacity: anim.value.clamp(0, 1),
        child: Transform.scale(
          scale: 0.85 + (0.15 * curved.value.clamp(0.0, 1.2)),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 36),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withOpacity(0.20),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isError
                            ? Icons.priority_high_rounded
                            : Icons.check_rounded,
                        color: mainColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      dialogTitle,
                      style: const TextStyle(
                        color: AppColors.teksGelap,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.abuTeks,
                        fontSize: 13.5,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: isError
                              ? LinearGradient(
                                  colors: [
                                    AppColors.error,
                                    AppColors.error.withOpacity(0.85),
                                  ],
                                )
                              : AppColors.gradientTombol,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              Navigator.of(context).pop();

                              Future.delayed(Duration.zero, () {
                                onOk?.call();
                              });
                            },
                            child: const Center(
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// Clipper untuk membuat lengkungan lembut di bawah header gradient
/// (tersedia bila dibutuhkan halaman lain).
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 18,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 40,
      size.width,
      size.height - 10,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
