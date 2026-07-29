import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '/theme/app_colors.dart';
import '/theme/app_widgets.dart';
import 'login.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

/// Halaman Register bergaya "Get Started" — nuansa biru muda & putih yang
/// lembut. Kolom & logika (NIM, Nama, Email, Password, simpan ke Firebase)
/// tetap sama seperti versi sebelumnya, hanya tampilan yang diperbarui.
/// Field Konfirmasi Password telah dihapus sesuai permintaan.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final NIMControl = TextEditingController();
  final NamaControl = TextEditingController();
  final Emailontrol = TextEditingController();
  final PasswordControl = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _agreePersonalData = false;

  @override
  void dispose() {
    NIMControl.dispose();
    NamaControl.dispose();
    Emailontrol.dispose();
    PasswordControl.dispose();
    super.dispose();
  }

  void _bersihkanForm() {
    NIMControl.text = "";
    NamaControl.text = "";
    Emailontrol.text = "";
    PasswordControl.text = "";
    setState(() => _agreePersonalData = false);
  }

  void _handleDaftar() {
    String NIM = NIMControl.text.trim();
    String Nama = NamaControl.text.trim();
    String Email = Emailontrol.text.trim();
    String Password = PasswordControl.text.trim();

    // Validasi jika ada field yang masih kosong -> alert di tengah layar
    if (NIM.isEmpty || Nama.isEmpty || Email.isEmpty || Password.isEmpty) {
      showAppAlertDialog(
        context,
        title: "Form Belum Lengkap",
        message: "Semua field wajib diisi sebelum melanjutkan pendaftaran.",
        isError: true,
      );
      return;
    }

    // Validasi persetujuan pemrosesan data pribadi
    if (!_agreePersonalData) {
      showAppAlertDialog(
        context,
        title: "Persetujuan Diperlukan",
        message:
            "Anda harus menyetujui pemrosesan data pribadi terlebih dahulu.",
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    // Petakan data ke Dictionary
    Map<String, String> data = {
      'nim': NIM,
      'nama': Nama,
      'email': Email,
      'password': Password,
    };
    // Masukkan Data Mahasiswa dalam folder NIM
    _databaseReference.child('Mahasiswa').child(NIM).set(data).then((value) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showAppAlertDialog(
        context,
        title: "Registrasi Berhasil",
        message: "Akun Anda berhasil dibuat, silakan masuk untuk melanjutkan.",
        isError: false,
        onOk: () {
          _bersihkanForm();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        },
      );
    }).catchError((error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showAppAlertDialog(
        context,
        title: "Registrasi Gagal",
        message: error.toString(),
        isError: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===================== BACK BUTTON =====================
              Align(
                alignment: Alignment.centerLeft,
                child: buildAuthBackButton(() => Navigator.pop(context)),
              ),
              const SizedBox(height: 24),

              // ===================== ICON DEKORATIF =====================
              Center(
                child: Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientUtama,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryMid.withOpacity(0.30),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.person_add_alt_1_rounded,
                      color: Colors.white, size: 32),
                ),
              ),
              const SizedBox(height: 20),

              // ===================== JUDUL =====================
              const Text(
                "Get Started",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.teksGelap,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Buat akun mahasiswa untuk mulai menggunakan aplikasi",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.abuTeks, fontSize: 13),
              ),
              const SizedBox(height: 26),

              // ===================== FORM =====================
              buildFieldLabel("NIM"),
              const SizedBox(height: 8),
              buildAuthTextField(
                controller: NIMControl,
                hint: "Masukkan NIM Anda",
                icon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              buildFieldLabel("Full Name"),
              const SizedBox(height: 8),
              buildAuthTextField(
                controller: NamaControl,
                hint: "Enter Full Name",
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 16),

              buildFieldLabel("Email"),
              const SizedBox(height: 8),
              buildAuthTextField(
                controller: Emailontrol,
                hint: "Enter Email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              buildFieldLabel("Password"),
              const SizedBox(height: 8),
              buildAuthTextField(
                controller: PasswordControl,
                hint: "Enter Password",
                icon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.abuTeks,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              const SizedBox(height: 14),

              // ===================== CHECKBOX PERSETUJUAN =====================
              buildAuthCheckboxRow(
                value: _agreePersonalData,
                onChanged: (val) =>
                    setState(() => _agreePersonalData = val ?? false),
                label: RichText(
                  text: const TextSpan(
                    style:
                        TextStyle(color: AppColors.teksGelap, fontSize: 12.5),
                    children: [
                      TextSpan(text: "I agree to the processing of "),
                      TextSpan(
                        text: "Personal data",
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // ===================== TOMBOL DAFTAR =====================
              buildPrimaryButton(
                text: "Sign up",
                isLoading: _isLoading,
                onPressed: _handleDaftar,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: _bersihkanForm,
                  child: const Text(
                    "Bersihkan Form",
                    style: TextStyle(
                      color: AppColors.abuTeks,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              const SizedBox(height: 26),

              // ===================== LINK KE LOGIN =====================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: AppColors.abuTeks, fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
