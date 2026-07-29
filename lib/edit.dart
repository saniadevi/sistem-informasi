import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'theme/app_colors.dart';
import 'theme/app_widgets.dart';
import 'auth/login.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

class EditProfilePage extends StatefulWidget {
  const EditProfilePage(
      {super.key, required this.NIM, required this.Nama, required this.Email});
  final String NIM;
  final String Nama;
  final String Email;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String NIM = "";
  String Nama = "";
  String Email = "";
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    NIM = widget.NIM;
    Nama = widget.Nama;
    Email = widget.Email;

    NIMControl.text = NIM;
    NamaControl.text = Nama;
    EmailControl.text = Email;
  }

  final NIMControl = TextEditingController();
  final NamaControl = TextEditingController();
  final EmailControl = TextEditingController();
  final PasswordControl = TextEditingController();

  @override
  void dispose() {
    NIMControl.dispose();
    NamaControl.dispose();
    EmailControl.dispose();
    PasswordControl.dispose();
    super.dispose();
  }

  void _simpanPerubahan() {
    String nim = NIMControl.text.trim();
    String nama = NamaControl.text.trim();
    String email = EmailControl.text.trim();
    String password = PasswordControl.text.trim();

    // Validasi jika ada field yang masih kosong -> alert di tengah layar
    if (nim.isEmpty || nama.isEmpty || email.isEmpty || password.isEmpty) {
      showAppAlertDialog(
        context,
        title: "Form Belum Lengkap",
        message: "Semua field harus diisi sebelum menyimpan perubahan!",
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    Map<String, String> data = {
      'nim': nim,
      'nama': nama,
      'email': email,
      'password': password,
    };

    _databaseReference.child('Mahasiswa').child(nim).set(data).then((value) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showAppAlertDialog(
        context,
        title: "Berhasil Disimpan",
        message: "Profil Anda berhasil diperbarui.",
        isError: false,
        onOk: () => Navigator.pop(context, true),
      );
    }).catchError((error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showAppAlertDialog(
        context,
        title: "Gagal Menyimpan",
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
              // ===================== BACK BUTTON & TITLE =====================
              Row(
                children: [
                  buildAuthBackButton(() => Navigator.pop(context)),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      "Ubah Profil Mahasiswa",
                      style: TextStyle(
                        color: AppColors.teksGelap,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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
                  child: const Icon(Icons.manage_accounts_rounded,
                      color: Colors.white, size: 32),
                ),
              ),
              const SizedBox(height: 26),

              // ===================== FORM =====================
              buildFieldLabel("NIM"),
              const SizedBox(height: 8),
              buildAuthTextField(
                controller: NIMControl,
                hint: "NIM",
                icon: Icons.badge_outlined,
                enabled: false,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              buildFieldLabel("Nama Lengkap"),
              const SizedBox(height: 8),
              buildAuthTextField(
                controller: NamaControl,
                hint: "Masukkan Nama Lengkap",
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 16),

              buildFieldLabel("Email"),
              const SizedBox(height: 8),
              buildAuthTextField(
                controller: EmailControl,
                hint: "Masukkan Email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              buildFieldLabel("Password"),
              const SizedBox(height: 8),
              buildAuthTextField(
                controller: PasswordControl,
                hint: "Masukkan Password Baru",
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
              const SizedBox(height: 28),

              // ===================== TOMBOL SIMPAN & BATAL =====================
              buildPrimaryButton(
                text: "Simpan Perubahan",
                isLoading: _isLoading,
                onPressed: _simpanPerubahan,
              ),
              const SizedBox(height: 14),
              buildSecondaryButton(
                text: "Batal",
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
