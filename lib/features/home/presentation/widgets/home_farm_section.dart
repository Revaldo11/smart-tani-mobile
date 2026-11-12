import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/theme/app_colors.dart';
import 'package:smart_tani_mobile/core/theme/app_spacing.dart';
import 'package:smart_tani_mobile/core/theme/app_typography.dart';
import 'package:smart_tani_mobile/features/farm/data/model/farm_model.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/home_card.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/main_farm_card.dart';

/// Loading / error / empty / success wrapper for the main farm card.
class HomeFarmSection extends StatelessWidget {
  const HomeFarmSection({
    required this.isLoading,
    required this.errorMessage,
    required this.farm,
    required this.now,
    required this.onRetry,
    required this.onDetailTap,
    required this.onEditTap,
    required this.onAddTap,
    super.key,
  });

  final bool isLoading;
  final String? errorMessage;
  final FarmModel? farm;
  final DateTime now;
  final VoidCallback onRetry;
  final VoidCallback onDetailTap;
  final VoidCallback onEditTap;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final farm = this.farm;

    if (farm != null) {
      return MainFarmCard(
        farm: farm,
        now: now,
        onDetailTap: onDetailTap,
        onEditTap: onEditTap,
      );
    }

    if (isLoading) {
      return const HomeCard(
        child: SizedBox(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final error = errorMessage;

    return HomeCard(
      child: Column(
        children: [
          Text(
            error ?? 'Belum ada lahan',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: error == null ? onAddTap : onRetry,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: Text(
              error == null
                  ? 'Tambah lahan pertama'
                  : 'Coba Lagi',
            ),
          ),
        ],
      ),
    );
  }
}
