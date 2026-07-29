import 'package:flutter/material.dart';

import '/auth/login.dart';
import '/auth/register.dart';
import '/theme/app_colors.dart';
import '/theme/app_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Logo: muncul duluan dengan scale + fade
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;

  // Teks judul: fade + naik sedikit, muncul setelah logo
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  // Card putih: slide up + fade, muncul paling akhir
  late final Animation<double> _cardFade;
  late final Animation<Offset> _cardSlide;

  // Glow halus di belakang logo (efek "bernapas")
  late final Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
    );

    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.30, 0.65, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _cardFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _glowPulse = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Warna paling bawah dari gradient, dipakai juga sebagai backgroundColor
    // Scaffold supaya TIDAK ADA celah/garis warna beda di sudut mana pun,
    // termasuk di balik sudut membulat card putih.
    const Color gradientBottomColor = Color(0xff3989f1);

    return Scaffold(
      backgroundColor: gradientBottomColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double h = constraints.maxHeight;
          final double topAreaHeight = h * 0.56;

          return Stack(
            fit: StackFit.expand,
            children: [
              // ===================== BACKGROUND GRADIENT FULL LAYAR =====================
              // Mengisi SELURUH layar (bukan cuma area atas), jadi warna di
              // balik sudut card yang membulat tetap gradient biru, bukan
              // warna lain yang kontras.
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff49B9F6),
                      gradientBottomColor,
                    ],
                  ),
                ),
              ),

              // ----- Dekorasi lingkaran transparan (hanya di area atas) -----
              Positioned(top: -60, right: -40, child: _decoCircle(180, 0.10)),
              Positioned(top: 40, left: -70, child: _decoCircle(140, 0.08)),
              Positioned(
                top: topAreaHeight - 130,
                left: -40,
                child: _decoCircle(90, 0.07),
              ),

              // ===================== LOGO + TEKS =====================
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: topAreaHeight,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ----- Logo dengan efek glow "bernapas" -----
                          FadeTransition(
                            opacity: _logoFade,
                            child: ScaleTransition(
                              scale: _logoScale,
                              child: AnimatedBuilder(
                                animation: _glowPulse,
                                builder: (context, child) {
                                  return Container(
                                    width: 158,
                                    height: 158,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.22),
                                          blurRadius: 34 * _glowPulse.value,
                                          spreadRadius: 4 * _glowPulse.value,
                                        ),
                                      ],
                                    ),
                                    child: child,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.14),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.4),
                                      width: 1.4,
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryDark
                                              .withOpacity(0.35),
                                          blurRadius: 26,
                                          offset: const Offset(0, 14),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      "images/newlogopt.png",
                                      width: 78,
                                      height: 78,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // ----- Nama universitas + tagline -----
                          FadeTransition(
                            opacity: _textFade,
                            child: SlideTransition(
                              position: _textSlide,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Universitas Ngudi Waluyo",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Kampus Unggul Berkarakter",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 12.5,
                                      letterSpacing: 0.3,
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
                ),
              ),

              // ===================== KARTU PUTIH BAWAH =====================
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: topAreaHeight - 40,
                child: SlideTransition(
                  position: _cardSlide,
                  child: FadeTransition(
                    opacity: _cardFade,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 20,
                            offset: const Offset(0, -6),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        top: false,
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(28, 26, 28, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // ----- Handle bar kecil -----
                                Container(
                                  width: 44,
                                  height: 4,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),

                                const Text(
                                  "SISTEM INFORMASI MAHASISWA",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.teksGelap,
                                    fontSize: 18.5,
                                    height: 1.3,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                Text(
                                  "Akses data akademik, kelola profil, dan "
                                  "pantau informasi mahasiswa dalam satu "
                                  "aplikasi yang simpel dan cepat.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.abuTeks,
                                    fontSize: 12.5,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 22),

                                buildPrimaryButton(
                                  text: "Login",
                                  onPressed: _goToLogin,
                                ),
                                const SizedBox(height: 10),

                                buildSecondaryButton(
                                  text: "Register",
                                  onPressed: _goToRegister,
                                ),
                                const SizedBox(height: 14),

                                Text(
                                  "v1.0.0",
                                  style: TextStyle(
                                    color: AppColors.abuTeks.withOpacity(0.6),
                                    fontSize: 10.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _decoCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// import '/auth/login.dart';
// import '/auth/register.dart';
// import '/theme/app_colors.dart';
// import '/theme/app_widgets.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _fadeAnimation;
//   late final Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.08),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _goToLogin() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginPage()),
//     );
//   }

//   void _goToRegister() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const RegisterPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     // Tinggi area gradient atas (tempat logo) sebelum kartu putih menutupinya.
//     final double topAreaHeight = screenHeight * 0.62;

//     return Scaffold(
//       backgroundColor: AppColors.primaryDark,
//       body: SizedBox.expand(
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             // ===================== AREA GRADIENT ATAS =====================
//             Container(
//               height: topAreaHeight,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color(0xff49B9F6),
//                     Color(0xff3989f1),
//                   ],
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   // ----- Logo UNW besar di tengah (pengganti ilustrasi) -----
//                   Positioned(
//                     top: 70,
//                     left: 0,
//                     right: 0,
//                     child: FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 168,
//                             height: 168,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white.withOpacity(0.14),
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.35),
//                                 width: 1.4,
//                               ),
//                             ),
//                             padding: const EdgeInsets.all(22),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color:
//                                         AppColors.primaryDark.withOpacity(0.35),
//                                     blurRadius: 26,
//                                     offset: const Offset(0, 14),
//                                   ),
//                                 ],
//                               ),
//                               padding: const EdgeInsets.all(20),
//                               child: Image.asset(
//                                 "images/newlogopt.png",
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 18),
//                           const Text(
//                             "Universitas Ngudi Waluyo",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 17,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // ===================== KARTU PUTIH BAWAH =====================
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               top: topAreaHeight - 60,
//               child: SlideTransition(
//                 position: _slideAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Container(
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(32),
//                         topRight: Radius.circular(32),
//                       ),
//                     ),
//                     child: SafeArea(
//                       top: false,
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             // ----- Headline utama -----
//                             const Text(
//                               "SISTEM INFORMASI MAHASISWA",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: AppColors.teksGelap,
//                                 fontSize: 19.5,
//                                 height: 1.3,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 12),

//                             // ----- Deskripsi singkat -----
//                             Text(
//                               "Akses data akademik, kelola profil, dan pantau "
//                               "informasi mahasiswa dalam satu aplikasi yang "
//                               "simpel dan cepat.",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: AppColors.abuTeks,
//                                 fontSize: 13,
//                                 height: 1.5,
//                               ),
//                             ),
//                             const SizedBox(height: 26),

//                             // ===== TOMBOL LOGIN (utama) =====
//                             buildPrimaryButton(
//                               text: "Login",
//                               onPressed: _goToLogin,
//                             ),
//                             const SizedBox(height: 12),

//                             // ===== TOMBOL REGISTER (sekunder) =====
//                             buildSecondaryButton(
//                               text: "Register",
//                               onPressed: _goToRegister,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
