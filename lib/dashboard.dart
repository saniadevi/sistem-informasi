import 'package:flutter/material.dart';
import 'profile.dart';
import 'schedule.dart';
import 'grades.dart';
import 'theme/app_colors.dart';
import 'theme/theme_aware.dart';

/// Halaman utama setelah login — berisi 3 tab untuk role MAHASISWA:
/// Profil (kelola akun sendiri), Jadwal (lihat jadwal kuliah),
/// Nilai (lihat KHS & IPK). Jadwal & Nilai bersifat read-only karena
/// datanya diinput oleh dosen/admin.
class DashboardPage extends StatefulWidget {
  final String NIM;
  const DashboardPage({super.key, required this.NIM});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _index = 0;

  late final List<Widget> _pages = [
    ProfilePage(NIM: widget.NIM),
    SchedulePage(NIM: widget.NIM),
    GradesPage(NIM: widget.NIM),
  ];

  @override
  Widget build(BuildContext context) {
    return ThemeAware(
      builder: (context, isDark) {
        return Scaffold(
          body: IndexedStack(index: _index, children: _pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
            indicatorColor: AppColors.primaryMid.withOpacity(0.15),
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.person_outline,
                    color: isDark ? AppColors.abuTeksDark : AppColors.abuTeks),
                selectedIcon:
                    const Icon(Icons.person, color: AppColors.primaryMid),
                label: "Profil",
              ),
              NavigationDestination(
                icon: Icon(Icons.schedule_outlined,
                    color: isDark ? AppColors.abuTeksDark : AppColors.abuTeks),
                selectedIcon:
                    const Icon(Icons.schedule, color: AppColors.primaryMid),
                label: "Jadwal",
              ),
              NavigationDestination(
                icon: Icon(Icons.school_outlined,
                    color: isDark ? AppColors.abuTeksDark : AppColors.abuTeks),
                selectedIcon:
                    const Icon(Icons.school, color: AppColors.primaryMid),
                label: "Nilai",
              ),
            ],
          ),
        );
      },
    );
  }
}
