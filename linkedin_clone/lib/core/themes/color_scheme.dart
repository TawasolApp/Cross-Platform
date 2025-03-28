import 'package:flutter/material.dart';

// Light Mode Colors
final ColorScheme linkedinLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color.fromARGB(255, 10, 102, 194),
  onPrimary: Colors.white,
  secondary: Color.fromARGB(255, 0, 65, 130),
  onSecondary: Colors.white,
  surface: Color.fromARGB(255, 233, 229, 223),
  onSurface: Color(0xFF191919),
  onSurfaceVariant: Color(0xFF6E6E6E),
  error: Colors.red,
  onError: Colors.white,
  outline: Color.fromARGB(255, 201, 201, 201),
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
