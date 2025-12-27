import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (From report_view.php)
  static const Color primary = Color(0xFF4F46E5); // Indigo
  static const Color secondary = Color(0xFF10B981); // Emerald Green

  // Background Colors
  static const Color background = Color(0xFFF3F4F6);
  static const Color surface = Colors.white;

  // Text Colors
  static const Color textDark = Color(0xFF1F2937);
  static const Color textLight = Color(0xFF6B7280);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradient (Optional for Cards)
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF4338CA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}