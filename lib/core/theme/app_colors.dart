import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color bgPrimary = Color(0xFF0D1117);
  static const Color bgSurface = Color(0xFF161B22);
  static const Color bgCard = Color(0xFF21262D);
  static const Color bgCardHover = Color(0xFF30363D);

  // Accents
  static const Color accentCyan = Color(0xFF00D4FF);
  static const Color accentTeal = Color(0xFF00BFA5);
  static const Color accentCyanDim = Color(0xFF0099BB);

  // Text
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF484F58);

  // Borders
  static const Color border = Color(0xFF30363D);
  static const Color borderAccent = Color(0xFF00D4FF);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D1117), Color(0xFF0A1628), Color(0xFF0D1117)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00D4FF), Color(0xFF00BFA5)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF21262D), Color(0xFF161B22)],
  );
}
