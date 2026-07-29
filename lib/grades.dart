import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'theme/app_colors.dart';
import 'theme/theme_aware.dart';

final DatabaseReference _dbNilai = FirebaseDatabase.instance.ref();

const Map<String, double> bobotNilai = {
  "A": 4.0,
  "AB": 3.5,
  "B": 3.0,
  "BC": 2.5,
  "C": 2.0,
  "D": 1.0,
  "E": 0.0,
};

/// Halaman Kartu Hasil Studi (KHS) khusus role MAHASISWA — sifatnya
/// read-only. Nilai diinput oleh dosen/admin lewat Firebase Console
/// (node Mahasiswa/{NIM}/nilai), mahasiswa di sini hanya melihat nilai
/// dan IPK yang otomatis terhitung.
class GradesPage extends StatefulWidget {
  final String NIM;
  const GradesPage({super.key, required this.NIM});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  DatabaseReference get _nilaiRef =>
      _dbNilai.child("Mahasiswa").child(widget.NIM).child("nilai");

  double _hitungIPK(List<Map<dynamic, dynamic>> semua) {
    double totalBobot = 0, totalSks = 0;
    for (final n in semua) {
      final sks = (n["sks"] as num?)?.toDouble() ?? 0;
      final bobot = bobotNilai[n["nilaiHuruf"]] ?? 0;
      totalBobot += sks * bobot;
      totalSks += sks;
    }
    return totalSks == 0 ? 0 : totalBobot / totalSks;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeAware(
      builder: (context, isDark) {
        final bg = isDark ? AppColors.backgroundDark : AppColors.background;
        final surface = isDark ? AppColors.surfaceDark : Colors.white;
        final border = isDark ? AppColors.abuBorderDark : AppColors.abuBorder;
        final textPrimary =
            isDark ? AppColors.teksGelapDark : AppColors.teksGelap;
        final textSecondary =
            isDark ? AppColors.abuTeksDark : AppColors.abuTeks;

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            title: const Text("Kartu Hasil Studi"),
            backgroundColor: AppColors.primaryMid,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: StreamBuilder<DatabaseEvent>(
            stream: _nilaiRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primaryMid));
              }

              List<Map<dynamic, dynamic>> semua = [];
              if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                final data = Map<dynamic, dynamic>.from(
                    snapshot.data!.snapshot.value as Map);
                semua = data.values
                    .map((e) => Map<dynamic, dynamic>.from(e))
                    .toList();
              }
              final ipk = _hitungIPK(semua);
              final totalSks = semua.fold<int>(
                  0, (a, n) => a + ((n["sks"] as num?)?.toInt() ?? 0));

              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientUtama,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text("IPK",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 6),
                            Text(ipk.toStringAsFixed(2),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(width: 1, height: 46, color: Colors.white24),
                        Column(
                          children: [
                            const Text("Total SKS",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 6),
                            Text("$totalSks",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(width: 1, height: 46, color: Colors.white24),
                        Column(
                          children: [
                            const Text("Mata Kuliah",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 6),
                            Text("${semua.length}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: semua.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.school_outlined,
                                    size: 54, color: textSecondary),
                                const SizedBox(height: 12),
                                Text("Belum ada data nilai",
                                    style: TextStyle(
                                        color: textPrimary,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(
                                    "Nilai akan tampil di sini setelah diinput oleh dosen/admin",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: textSecondary, fontSize: 12.5)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: semua.length,
                            itemBuilder: (context, i) {
                              final n = semua[i];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: border),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(n["matkul"] ?? "-",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: textPrimary)),
                                          const SizedBox(height: 2),
                                          Text("${n["sks"]} SKS",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: textSecondary)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryMid
                                            .withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(n["nilaiHuruf"] ?? "-",
                                          style: const TextStyle(
                                              color: AppColors.primaryMid,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
