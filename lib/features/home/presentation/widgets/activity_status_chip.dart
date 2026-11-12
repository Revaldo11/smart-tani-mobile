import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/theme/app_colors.dart';
import 'package:smart_tani_mobile/core/theme/app_typography.dart';

class ActivityStatusChip extends StatelessWidget {
  const ActivityStatusChip({
    required this.isDone,
    super.key,
  });

  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final color = isDone
        ? AppColors.success
        : AppColors.warning;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDone
                  ? Icons.check_circle
                  : Icons.access_time_filled,
              size: 12,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              isDone ? 'Selesai' : 'Belum dilakukan',
              maxLines: 1,
              style: AppTypography.bodySmall.copyWith(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
