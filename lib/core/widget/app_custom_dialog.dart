import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppCustomDialog extends StatelessWidget {
  const AppCustomDialog({
    required this.title,
    required this.description,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    super.key,
    this.onClose,
    this.imagePath,
  });

  final String title;
  final String description;
  final String primaryLabel;
  final String secondaryLabel;

  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;
  final VoidCallback? onClose;

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            onClose != null
                ? Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: onClose,
                      style: IconButton.styleFrom(
                        backgroundColor:
                            AppColors.background,
                      ),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            Center(
              child: Image.asset(
                imagePath ?? 'assets/images/success.png',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.headingLarge.copyWith(
                fontSize: 28,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onPrimaryPressed,
                child: Text(primaryLabel),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: onSecondaryPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(
                    color: AppColors.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  secondaryLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<T?> showAppCustomDialog<T>(
  BuildContext context, {
  required String title,
  required String description,
  required String primaryLabel,
  required String secondaryLabel,
  required VoidCallback onPrimaryPressed,
  required VoidCallback onSecondaryPressed,
  VoidCallback? onClose,
  String? imagePath,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) {
      return AppCustomDialog(
        title: title,
        description: description,
        primaryLabel: primaryLabel,
        secondaryLabel: secondaryLabel,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
        onClose: onClose,
        imagePath: imagePath,
      );
    },
  );
}
