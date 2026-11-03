import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RakshanTheme {
  // Shakti-Inspired Light Clean Palette (Clean White, Slate & Vibrant Accents)
  static const Color background = Color(0xFFF8FAFC);      // Crisp Slate 50
  static const Color surface = Colors.white;              // Pure White Card
  static const Color surfaceMuted = Color(0xFFF1F5F9);    // Soft Slate 100
  static const Color surfaceLight = Color(0xFFF8FAFC);    // Subtle background
  static const Color cardBorder = Color(0xFFE2E8F0);      // Refined Slate 200 border
  
  // Typography
  static const Color textPrimary = Color(0xFF0F172A);     // Slate 900
  static const Color textMuted = Color(0xFF64748B);       // Slate 500
  static const Color textLight = Color(0xFF94A3B8);       // Slate 400

  // Brand Accents
  static const Color primaryBlue = Color(0xFF2563EB);     // Vibrant Shakti Royal Blue
  static const Color primaryLight = Color(0xFFEFF6FF);    // Blue 50
  static const Color primaryGlow = Color(0x332563EB);     // Subtle blue glow
  static const Color accentRose = Color(0xFFE11D48);      // Shakti Rose
  static const Color accentPink = Color(0xFFE1306C);      // Shakti Pink
  static const Color accentPurple = Color(0xFF7C3AED);    // Royal Violet
  static const Color secondaryCyan = Color(0xFF0284C7);   // Sky Blue

  // Backward-compatible alias for existing references
  static const Color primaryNeon = primaryBlue;

  // Threat Severity & Risk Palette (Clean bright alerts)
  static const Color safeGreen = Color(0xFF10B981);       // Emerald Green 500
  static const Color safeGreenLight = Color(0xFFECFDF5);  // Green 50
  static const Color warningAmber = Color(0xFFF59E0B);    // Amber 500
  static const Color warningAmberLight = Color(0xFFFFFBEB);// Amber 50
  static const Color highOrange = Color(0xFFEA580C);      // Orange 600
  static const Color highOrangeLight = Color(0xFFFFF7ED); // Orange 50
  static const Color criticalRed = Color(0xFFEF4444);     // Crimson Red 500
  static const Color criticalRedLight = Color(0xFFFEF2F2); // Red 50

  static Color getRiskColor(double score) {
    if (score >= 85) return criticalRed;
    if (score >= 70) return highOrange;
    if (score >= 35) return warningAmber;
    return safeGreen;
  }

  static Color getRiskBgColor(double score) {
    if (score >= 85) return criticalRedLight;
    if (score >= 70) return highOrangeLight;
    if (score >= 35) return warningAmberLight;
    return safeGreenLight;
  }

  static String getRiskLabel(double score) {
    if (score >= 85) return 'CRITICAL HAZARD';
    if (score >= 70) return 'HIGH THREAT RISK';
    if (score >= 35) return 'MODERATE WATCH';
    return 'SECURE & SAFE';
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primaryBlue,
      cardColor: surface,
      dividerColor: cardBorder,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: accentRose,
        surface: surface,
        onSurface: textPrimary,
        error: criticalRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: cardBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryGlow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryBlue, width: 1.8),
        ),
      ),
    );
  }

  // Keep darkTheme available if needed
  static ThemeData get darkTheme => lightTheme;
}
