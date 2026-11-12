import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_tani_mobile/core/theme/app_colors.dart';
import 'package:smart_tani_mobile/core/theme/app_spacing.dart';
import 'package:smart_tani_mobile/core/theme/app_typography.dart';
import 'package:smart_tani_mobile/features/activity/data/model/activity_model.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/activity_status_chip.dart';

// Blue is used only by irrigation; not a recurring token yet.
const _irrigationBlue = Color(0xFF1E88E5);

(IconData, Color) _typeStyle(ActivityType type) =>
    switch (type) {
      ActivityType.irrigation => (
        Icons.water_drop,
        _irrigationBlue,
      ),
      ActivityType.fertilizing => (
        Icons.eco,
        AppColors.primary,
      ),
      ActivityType.spraying => (
        Icons.pest_control,
        AppColors.warning,
      ),
      ActivityType.other => (
        Icons.event_note,
        AppColors.textSecondary,
      ),
    };

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    required this.activity,
    required this.onTap,
    super.key,
  });

  final ActivityModel activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _typeStyle(activity.type);
    final description = activity.description;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: 44,
                height: 44,
                child: Icon(icon, color: color),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium
                        .copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (description != null)
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall,
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat.Hm().format(
                    activity.scheduledAt,
                  ),
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                ActivityStatusChip(isDone: activity.isDone),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
