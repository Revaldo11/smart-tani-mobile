import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/theme/app_colors.dart';
import 'package:smart_tani_mobile/core/theme/app_spacing.dart';
import 'package:smart_tani_mobile/core/theme/app_typography.dart';

class _QuickAction {
  const _QuickAction(
    this.icon,
    this.color,
    this.title,
    this.subtitle,
  );

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
}

const _actions = [
  _QuickAction(
    Icons.camera_alt_rounded,
    AppColors.primary,
    'Cek Tanaman',
    'Foto & analisis',
  ),
  _QuickAction(
    Icons.chat_rounded,
    AppColors.info,
    'Asisten Tani',
    'Tanya apa saja',
  ),
  _QuickAction(
    Icons.bar_chart,
    AppColors.primary,
    'Catat Panen',
    'Lihat hasil panen',
  ),
  _QuickAction(
    Icons.menu_book,
    AppColors.info,
    'Edukasi',
    'Tips & artikel',
  ),
];

class QuickActions extends StatelessWidget {
  const QuickActions({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < _actions.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickActionTile(
                action: _actions[i],
                onTap: onTap,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.action,
    required this.onTap,
  });

  final _QuickAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: Colors.black12,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xs,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                action.icon,
                color: action.color,
                size: 28,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                action.title,
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                action.subtitle,
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 9,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
