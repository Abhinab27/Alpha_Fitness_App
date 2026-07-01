import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color terracotta = Color(0xFFC97D60);
  static const Color obsidian = Color(0xFF121212);
  static const Color cream = Color(0xFFFDF8F5);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: obsidian,
    primaryColor: terracotta,
    colorScheme: const ColorScheme.dark(
      primary: terracotta,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.lora(fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.white),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: cream,
    primaryColor: terracotta,
    colorScheme: const ColorScheme.light(
      primary: terracotta,
      surface: Colors.white,
      onSurface: obsidian,
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.lora(fontWeight: FontWeight.bold, color: obsidian),
      titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: obsidian),
    ),
  );
}
