import 'package:flutter/material.dart';

/// Raw color palette. Screens should use the semantic names in
/// [AppColors]; add a value here only when a new color is shared.
abstract final class Pallets {
  // Green
  static const Color green900 = Color(0xFF1B5E20);
  static const Color green700 = Color(0xFF2E7D32);
  static const Color green50 = Color(0xFFE8F5E9);

  // Blue
  static const Color blue600 = Color(0xFF1E88E5);

  // Amber / Red
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color red700 = Color(0xFFD32F2F);

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8FAF8);
  static const Color gray900 = Color(0xFF1C1C1C);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray200 = Color(0xFFE5E7EB);
}
