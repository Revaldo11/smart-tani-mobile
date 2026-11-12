import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/theme/app_colors.dart';
import 'package:smart_tani_mobile/core/theme/app_spacing.dart';
import 'package:smart_tani_mobile/core/theme/app_typography.dart';
import 'package:smart_tani_mobile/features/activity/data/model/activity_model.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/activity_tile.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/home_card.dart';

/// Hidden when there is no active season; otherwise loading /
/// error / empty / success.
class TodayActivitiesCard extends StatelessWidget {
  const TodayActivitiesCard({
    required this.hasSeason,
    required this.isLoading,
    required this.errorMessage,
    required this.activities,
    required this.onRetry,
    required this.onActivityTap,
    required this.onSeeAllTap,
    super.key,
  });

  final bool hasSeason;
  final bool isLoading;
  final String? errorMessage;
  final List<ActivityModel> activities;
  final VoidCallback onRetry;
  final ValueChanged<ActivityModel> onActivityTap;
  final VoidCallback onSeeAllTap;

  @override
  Widget build(BuildContext context) {
    if (!hasSeason) return const SizedBox.shrink();

    return HomeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.event_available_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Aktivitas Hari Ini',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: onSeeAllTap,
                child: Text(
                  'Lihat Semua ›',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _body(),
        ],
      ),
    );
  }

  Widget _body() {
    if (activities.isNotEmpty) {
      return Column(
        children: [
          for (var i = 0; i < activities.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            ActivityTile(
              activity: activities[i],
              onTap: () => onActivityTap(activities[i]),
            ),
          ],
        ],
      );
    }

    if (isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final error = errorMessage;

    return Center(
      child: Column(
        children: [
          if (error == null)
            const Icon(
              Icons.event_busy_outlined,
              size: 32,
              color: AppColors.textSecondary,
            ),
          Text(
            error ?? 'Tidak ada aktivitas hari ini',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium,
          ),
          if (error != null)
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
              child: const Text('Coba Lagi'),
            ),
        ],
      ),
    );
  }
}
