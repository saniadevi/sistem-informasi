import 'package:flutter/material.dart';
import '../main.dart';

class ThemeAware extends StatelessWidget {
  final Widget Function(BuildContext context, bool isDark) builder;
  const ThemeAware({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) => builder(context, mode == ThemeMode.dark),
    );
  }
}
