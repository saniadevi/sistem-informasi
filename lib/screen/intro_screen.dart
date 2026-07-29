import 'dart:math' as math;
import 'package:flutter/material.dart';

import '/theme/app_colors.dart';
import 'splash_screen.dart';

/// Halaman animasi pembuka (intro) yang tampil PERTAMA KALI sebelum
/// [SplashScreen]. Menampilkan cincin melingkar yang "menggambar" dirinya
/// sendiri secara elegan di atas background biru gelap bernuansa sama
/// dengan tema aplikasi, lalu logo UNW muncul di tengah, disusul teks
/// "SISTEM INFORMASI MAHASISWA" yang fade-in dari bawah.
///
/// Setelah seluruh animasi selesai (± 3 detik), halaman otomatis
/// berpindah ke [SplashScreen] dengan transisi fade yang lembut.
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  // Kontrol animasi cincin yang "digambar" (0 -> 1 = 0 -> 360 derajat)
  late final AnimationController _ringController;
  late final Animation<double> _ringProgress;

  // Kontrol animasi logo & teks yang muncul setelah cincin selesai
  late final AnimationController _contentController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _glowFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _ringProgress = CurvedAnimation(
      parent: _ringController,
      curve: Curves.easeInOutCubic,
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoScale = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.75, curve: Curves.elasticOut),
      ),
    );
    _logoFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
    );
    _glowFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _textFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.45, 1.0, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    // 1) Cincin "menggambar" dirinya sendiri
    await _ringController.forward();
    if (!mounted) return;

    // 2) Logo & teks muncul dengan animasi elegan
    await _contentController.forward();
    if (!mounted) return;

    // 3) Jeda sejenak agar terbaca, lalu pindah ke Splash Screen
    await Future.delayed(const Duration(milliseconds: 750));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: const SplashScreen(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ringController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF04101F),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Gradient radial biru gelap elegan — tetap senada dengan
          // AppColors.primaryDark, tapi lebih pekat untuk kesan premium.
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.15,
            colors: [
              Color(0xFF0B4A9C), // AppColors.primaryDark
              Color(0xFF041226),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ===================== CINCIN + LOGO =====================
              SizedBox(
                width: 190,
                height: 190,
                child: AnimatedBuilder(
                  animation:
                      Listenable.merge([_ringProgress, _contentController]),
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow lembut di belakang logo
                        Opacity(
                          opacity: _glowFade.value,
                          child: Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primaryLight.withOpacity(0.45),
                                  blurRadius: 40,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Cincin yang "digambar" secara animatif
                        CustomPaint(
                          size: const Size(190, 190),
                          painter: _RingPainter(progress: _ringProgress.value),
                        ),
                        // Logo UNW di tengah, muncul dengan scale + fade
                        Opacity(
                          opacity: _logoFade.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: Container(
                              width: 124,
                              height: 124,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Image.asset(
                                "images/newlogopt.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 36),

              // ===================== TEKS JUDUL =====================
              FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: _textSlide,
                  child: Column(
                    children: [
                      const Text(
                        "SISTEM INFORMASI",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "MAHASISWA",
                        style: TextStyle(
                          color: AppColors.primaryLight,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 42,
                        height: 1.4,
                        color: AppColors.primaryLight.withOpacity(0.65),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Universitas Ngudi Waluyo",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 12.5,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter yang menggambar cincin tipis secara progresif,
/// dengan shimmer gradient biru muda -> putih -> biru muda, meniru
/// gaya animasi "logo reveal" elegan pada video referensi.
class _RingPainter extends CustomPainter {
  final double progress; // 0.0 -> 1.0

  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2 - 4;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    // Track redup sebagai dasar cincin (selalu terlihat penuh, samar)
    final Paint trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawCircle(center, radius, trackPaint);

    // Busur progres dengan gradient shimmer, digambar sesuai [progress]
    final Paint sweepPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + 2 * math.pi,
        colors: [
          AppColors.primaryLight,
          Colors.white,
          AppColors.primaryLight,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      sweepPaint,
    );

    // Titik kecil bercahaya di ujung busur (efek "kepala komet")
    if (progress > 0.02 && progress < 0.999) {
      final double angle = -math.pi / 2 + 2 * math.pi * progress;
      final Offset dotCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final Paint dotPaint = Paint()
        ..color = Colors.white
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(dotCenter, 4.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
