import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'edit.dart';
import 'theme/app_colors.dart';
import 'theme/app_widgets.dart';
import 'auth/login.dart';
import 'main.dart'; // <-- tambahkan ini, supaya themeNotifier bisa dipakai

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

class ProfilePage extends StatefulWidget {
  final String NIM;
  const ProfilePage({super.key, required this.NIM});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<dynamic, dynamic> mappedData = {};
  String NIM = "";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    NIM = widget.NIM;
    fetchData(NIM);
  }

  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> fetchData(String NIM) async {
    setState(() => _loading = true);
    final ref = _databaseReference.child("Mahasiswa").child(NIM);
    final data = await ref.get();
    if (!mounted) return;
    setState(() {
      mappedData = (data.value as Map<dynamic, dynamic>?) ?? {};
      _loading = false;
    });
  }

  final confirmController = TextEditingController();

  void _openConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: AppColors.error),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Konfirmasi Hapus Akun',
                  style: TextStyle(
                      color: AppColors.teksGelap,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Masukkan password Anda untuk menghapus akun secara permanen.',
                style: TextStyle(fontSize: 13, color: AppColors.abuTeks),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.fieldBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.fieldBorder),
                ),
                child: TextField(
                  controller: confirmController,
                  obscureText: true,
                  style: const TextStyle(color: AppColors.teksGelap),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: AppColors.abuTeks),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                confirmController.clear();
              },
              child: const Text('Batal',
                  style: TextStyle(color: AppColors.abuTeks)),
            ),
            TextButton(
              onPressed: () {
                String curPass = confirmController.text;

                _databaseReference
                    .child("Mahasiswa")
                    .child(NIM)
                    .get()
                    .then((snapshot) {
                  if (snapshot.exists && snapshot.value != null) {
                    // Menggunakan Map.from jauh lebih aman untuk menghindari crash cast tipe data
                    Map<dynamic, dynamic> data =
                        Map.from(snapshot.value as Map);
                    String dbPass = data['password'] ?? '';

                    if (curPass == dbPass) {
                      _databaseReference
                          .child("Mahasiswa")
                          .child(NIM)
                          .remove()
                          .then((result) {
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        showAppAlertDialog(
                          context,
                          title: "Akun Dihapus",
                          message:
                              "Akun Anda berhasil dihapus secara permanen.",
                          isError: false,
                          onOk: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                        );
                      }).catchError((error) {
                        if (!mounted) return;
                        showAppAlertDialog(context,
                            title: "Gagal Menghapus",
                            message: error.toString(),
                            isError: true);
                      });
                    } else {
                      showAppAlertDialog(context,
                          title: "Password Salah",
                          message: "Password yang Anda masukkan tidak sesuai.",
                          isError: true);
                    }
                  } else {
                    showAppAlertDialog(context,
                        title: "Data Tidak Ditemukan",
                        message: "Data mahasiswa tidak ditemukan.",
                        isError: true);
                  }
                }).catchError((error) {
                  showAppAlertDialog(context,
                      title: "Terjadi Kesalahan",
                      message: error.toString(),
                      isError: true);
                });
              },
              child: const Text('Hapus',
                  style: TextStyle(
                      color: AppColors.error, fontWeight: FontWeight.bold)),
            )
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  String _initials(String nama) {
    if (nama.trim().isEmpty) return "?";
    final parts = nama.trim().split(RegExp(r"\s+"));
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.abuBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryMid.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryMid, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.abuTeks, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        color: AppColors.teksGelap,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String nama = (mappedData['nama'] ?? '-').toString();
    final String email = (mappedData['email'] ?? '-').toString();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===================== HEADER GRADIENT =====================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
              decoration:
                  const BoxDecoration(gradient: AppColors.gradientUtama),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "My Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            // Tombol toggle dark mode (baru)
                            IconButton(
                              icon: Icon(
                                themeNotifier.value == ThemeMode.light
                                    ? Icons.dark_mode_outlined
                                    : Icons.light_mode_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  themeNotifier.value =
                                      themeNotifier.value == ThemeMode.light
                                          ? ThemeMode.dark
                                          : ThemeMode.light;
                                });
                              },
                            ),
                            buildMoreButton(onPressed: _logout),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: AppColors.primaryMid,
                                ),
                              )
                            : Text(
                                _initials(nama),
                                style: const TextStyle(
                                  color: AppColors.primaryMid,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _loading ? "Memuat..." : nama,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "NIM $NIM",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===================== CARD INFO =====================
            Transform.translate(
              offset: const Offset(0, -30),
              child: AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Informasi Akun",
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _infoTile(Icons.badge_outlined, "NIM", NIM),
                    _infoTile(Icons.person_outline, "Nama", nama),
                    _infoTile(Icons.email_outlined, "Email", email),
                    const SizedBox(height: 12),
                    buildPrimaryButton(
                      text: "UBAH PROFIL",
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              NIM: NIM,
                              Nama: nama,
                              Email: email,
                            ),
                          ),
                        );

                        if (result == true) {
                          await fetchData(NIM);
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    buildSecondaryButton(
                      text: "LOGOUT",
                      onPressed: _logout,
                    ),
                    const SizedBox(height: 14),
                    buildSecondaryButton(
                      text: "HAPUS AKUN",
                      color: AppColors.error,
                      onPressed: _openConfirmationDialog,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
