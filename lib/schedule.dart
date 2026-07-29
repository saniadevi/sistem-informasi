import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'theme/app_colors.dart';
import 'theme/theme_aware.dart';

final DatabaseReference _dbJadwal = FirebaseDatabase.instance.ref();

/// Halaman Jadwal Kuliah khusus role MAHASISWA — sifatnya read-only.
/// Data jadwal diinput oleh dosen/admin lewat Firebase Console (node
/// Mahasiswa/{NIM}/jadwal), mahasiswa di sini hanya melihat.
class SchedulePage extends StatefulWidget {
  final String NIM;
  const SchedulePage({super.key, required this.NIM});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DatabaseReference get _jadwalRef =>
      _dbJadwal.child("Mahasiswa").child(widget.NIM).child("jadwal");

  final List<String> urutanHari = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];

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
            title: const Text("Jadwal Kuliah"),
            backgroundColor: AppColors.primaryMid,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: StreamBuilder<DatabaseEvent>(
            stream: _jadwalRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primaryMid));
              }
              if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                return _emptyState(textPrimary, textSecondary);
              }

              final data = Map<dynamic, dynamic>.from(
                  snapshot.data!.snapshot.value as Map);
              final items =
                  data.values.map((e) => Map<dynamic, dynamic>.from(e)).toList()
                    ..sort((a, b) {
                      final ai = urutanHari.indexOf(a["hari"] ?? "");
                      final bi = urutanHari.indexOf(b["hari"] ?? "");
                      return ai.compareTo(bi);
                    });

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryMid.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item["hari"] ?? "-",
                            style: const TextStyle(
                              color: AppColors.primaryMid,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["matkul"] ?? "-",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${item["dosen"] ?? "-"} • Ruang ${item["ruang"] ?? "-"}",
                                style: TextStyle(
                                    fontSize: 12, color: textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _emptyState(Color textPrimary, Color textSecondary) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy_rounded, size: 54, color: textSecondary),
          const SizedBox(height: 12),
          Text("Belum ada jadwal kuliah",
              style:
                  TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text("Jadwal akan tampil di sini setelah diinput oleh admin/dosen",
              textAlign: TextAlign.center,
              style: TextStyle(color: textSecondary, fontSize: 12.5)),
        ],
      ),
    );
  }
}
