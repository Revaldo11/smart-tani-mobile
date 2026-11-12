import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/theme/app_colors.dart';
import 'package:smart_tani_mobile/core/theme/app_typography.dart';
import 'package:smart_tani_mobile/features/planting_season/data/model/planting_season_model.dart';

class FarmStatusChip extends StatelessWidget {
  const FarmStatusChip({required this.status, super.key});

  final HealthStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      HealthStatus.good => (
        'Kondisi Baik',
        AppColors.success,
      ),
      HealthStatus.warning => (
        'Perlu Perhatian',
        AppColors.warning,
      ),
      HealthStatus.bad => (
        'Kondisi Buruk',
        AppColors.error,
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 8, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
