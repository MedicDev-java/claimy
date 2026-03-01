import 'package:flutter/material.dart';

class ThemeService {
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color textMain = Colors.white;
  static const Color textMuted = Color(0xFF94A3B8);

  static BoxDecoration cardDecoration = BoxDecoration(
    color: slate800,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white10),
  );

  static BoxDecoration gradientDecoration = BoxDecoration(
    gradient: const LinearGradient(
      colors: [primary, secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: primary.withOpacity(0.3),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );
}
