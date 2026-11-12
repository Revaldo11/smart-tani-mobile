import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/theme/pallets.dart';

/// Semantic color names, mapped onto [Pallets].
abstract final class AppColors {
  static const Color primary = Pallets.green700;
  static const Color primaryDark = Pallets.green900;
  static const Color primaryLight = Pallets.green50;

  static const Color background = Pallets.offWhite;
  static const Color surface = Pallets.white;

  static const Color textPrimary = Pallets.gray900;
  static const Color textSecondary = Pallets.gray500;

  static const Color border = Pallets.gray200;

  static const Color success = Pallets.green700;
  static const Color warning = Pallets.amber500;
  static const Color error = Pallets.red700;

  static const Color info = Pallets.blue600;
}
