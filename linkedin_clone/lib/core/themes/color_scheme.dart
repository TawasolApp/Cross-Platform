import 'package:flutter/material.dart';

// Light Mode Colors
final ColorScheme linkedinLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF0077B5),
  onPrimary: Colors.white,
  secondary: Color(0xFF004B7C),
  onSecondary: Colors.white,
  surface: Color(0xFFF3F2EF),
  onSurface: Color(0xFF191919),
  onSurfaceVariant: Color(0xFF6E6E6E),
  error: Colors.red,
  onError: Colors.white,
);

// Dark Mode Colors
final ColorScheme linkedinDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF00A0DC),
  onPrimary: Colors.white,
  secondary: Color(0xFF004B7C),
  onSecondary: Colors.white,
  surface: Color(0xFF121212),
  onSurface: Colors.white,
  onSurfaceVariant: Color(0xFFBDBDBD),
  error: Colors.red.shade300,
  onError: Colors.white,
);
