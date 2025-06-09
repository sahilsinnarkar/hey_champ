import 'package:flutter/material.dart';

class AppColors {
  // Background
  static const Color background = Colors.black;
  static const Color surface = Color(0xFF121212); // slightly lighter black

  // Foreground (Text, Icons)
  static const Color primaryText = Colors.white;
  static const Color secondaryText = Color(0xFFB0B0B0); // grayish white
  static const Color disabledText = Color(0xFF666666);

  // Accent / Primary
  static const Color accent = Colors.blueAccent; // You can replace with any highlight color
  static const Color success = Colors.greenAccent;
  static const Color error = Colors.redAccent;
  static const Color warning = Colors.orangeAccent;

  // Borders, Dividers
  static const Color divider = Color(0xFF2C2C2C);
  static const Color border = Color(0xFF3D3D3D);

  // Button Colors
  static const Color buttonBackground = Color(0xFF1F1F1F);
  static const Color buttonText = Colors.white;
  static const Color buttonDisabled = Color(0xFF3A3A3A);
}
