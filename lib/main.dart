import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screen/intro_screen.dart';
import 'theme/app_colors.dart';

/// Saklar global mode terang/gelap. Diimport & diubah dari halaman
/// mana saja (mis. tombol toggle di Profile) lewat `themeNotifier.value = ...`.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'Sistem Informasi Mahasiswa';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: _title,
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.background,
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryMid,
              primary: AppColors.primaryMid,
              secondary: AppColors.primaryLight,
              surface: Colors.white,
            ),
            splashColor: AppColors.primaryLight.withOpacity(0.15),
            highlightColor: Colors.transparent,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.backgroundDark,
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryMid,
              brightness: Brightness.dark,
              surface: AppColors.surfaceDark,
            ),
            splashColor: AppColors.primaryLight.withOpacity(0.10),
            highlightColor: Colors.transparent,
          ),
          // IntroScreen (animasi logo & judul) ditampilkan pertama kali,
          // lalu otomatis berpindah ke SplashScreen. Dari Splash, tombol
          // "Login" membuka LoginPage dan "Register" membuka RegisterPage.
          home: const IntroScreen(),
        );
      },
    );
  }
}
