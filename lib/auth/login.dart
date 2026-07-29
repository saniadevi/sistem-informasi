import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'register.dart';
import '/dashboard.dart';
import '/theme/app_colors.dart';
import '/theme/app_widgets.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final NIMControl = TextEditingController();
  final PasswordControl = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    NIMControl.dispose();
    PasswordControl.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Mengambil isi TextField lalu menghapus spasi kosong
    String NIM = NIMControl.text.trim();
    String Password = PasswordControl.text.trim();

    // Jika NIM atau Password kosong -> tampilkan alert validasi di tengah
    if (NIM.isEmpty || Password.isEmpty) {
      showAppAlertDialog(
        context,
        title: "Form Belum Lengkap",
        message: "Maaf, Anda harus mengisi NIM dan Password terlebih dahulu.",
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    // AMBIL DATA DARI FIREBASE
    _databaseReference
        .child("Mahasiswa") // Masuk folder Mahasiswa
        .child(NIM) // Cari berdasarkan NIM
        .get() // Ambil data
        .then((snapshot) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (!snapshot.exists) {
        showAppAlertDialog(
          context,
          title: "NIM Tidak Ditemukan",
          message: "NIM yang Anda masukkan belum terdaftar di sistem.",
          isError: true,
        );
        return;
      }

      // Mengubah hasil Firebase menjadi Map
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      // Mengambil password dari database
      String dbPass = data['password'];

      if (Password == dbPass) {
        // Jika password benar
        showAppAlertDialog(
          context,
          title: "Login Berhasil",
          message: "Selamat datang kembali!",
          isError: false,
          onOk: () {
            // Pindah ke halaman Profile
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardPage(NIM: NIM),
              ),
            ).then((value) {
              NIMControl.clear();
              PasswordControl.clear();
              setState(() {});
            });
          },
        );
      } else {
        // Jika password salah
        showAppAlertDialog(
          context,
          title: "Login Gagal",
          message: "Password yang Anda masukkan salah, silakan coba lagi.",
          isError: true,
        );
      }
    })

        // =========================
        // JIKA TERJADI ERROR
        // =========================
        .catchError((error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showAppAlertDialog(
        context,
        title: "Terjadi Kesalahan",
        message: "NIM tidak ditemukan atau terjadi kesalahan pada jaringan.",
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
                  child: const Icon(Icons.school_rounded,
                      color: Colors.white, size: 34),
                ),
              ),
              const SizedBox(height: 22),

              // ===================== JUDUL =====================
              const Text(
                "Welcome back",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.teksGelap,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Masuk menggunakan NIM & password akun Anda",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.abuTeks, fontSize: 13),
              ),
              const SizedBox(height: 30),

              // ===================== FORM =====================
              buildFieldLabel("NIM"),
              const SizedBox(height: 8),
              buildAuthTextField(
                controller: NIMControl,
                hint: "Masukkan NIM Anda",
                icon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 18),
              buildFieldLabel("Password"),
              const SizedBox(height: 8),
              buildAuthTextField(
                controller: PasswordControl,
                hint: "Masukkan Password Anda",
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
              const SizedBox(height: 12),

              // ===================== REMEMBER ME & LUPA PASSWORD =====================
              Row(
                children: [
                  Expanded(
                    child: buildAuthCheckboxRow(
                      value: _rememberMe,
                      onChanged: (val) =>
                          setState(() => _rememberMe = val ?? false),
                      label: const Text(
                        "Remember me",
                        style: TextStyle(
                            color: AppColors.teksGelap, fontSize: 12.5),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showAppSnackBar(context, "Fitur belum tersedia");
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: AppColors.primaryMid,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ===================== TOMBOL SIGN IN =====================
              buildPrimaryButton(
                text: "Sign in",
                isLoading: _isLoading,
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 30),

              // ===================== LINK KE REGISTER =====================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: AppColors.abuTeks, fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Sign up",
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
