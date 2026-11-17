import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_tani_mobile/core/theme/app_colors.dart';
import 'package:smart_tani_mobile/core/theme/app_spacing.dart';
import 'package:smart_tani_mobile/core/theme/app_typography.dart';
import 'package:smart_tani_mobile/features/farm/data/model/farm_model.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/farm_status_chip.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/home_card.dart';

const _placeholderAsset =
    'assets/images/farm_placeholder.jpg';

class MainFarmCard extends StatelessWidget {
  const MainFarmCard({
    required this.farm,
    required this.now,
    required this.onDetailTap,
    required this.onEditTap,
    super.key,
  });

  final FarmModel farm;
  final DateTime now;
  final VoidCallback onDetailTap;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final season = farm.activeSeason;
    final area = NumberFormat(
      '0.##',
      'id_ID',
    ).format(farm.area);

    return HomeCard(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 11,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: onDetailTap,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.grass,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(
                          width: AppSpacing.xs,
                        ),
                        Flexible(
                          child: Text(
                            farm.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                AppTypography.headingSmall,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: AppSpacing.md),
                  if (season == null)
                    Text(
                      'Belum ada musim tanam',
                      style: AppTypography.bodyMedium
                          .copyWith(
                            color: AppColors.textSecondary,
                          ),
                    )
                  else
                    Row(
                      children: [
                        const Icon(
                          Icons.eco,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(
                          width: AppSpacing.xs,
                        ),
                        Expanded(
                          child: Text(
                            season.cropLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        if (season != null) ...[
                          _Stat(
                            label: 'Umur tanaman',
                            value:
                                '${season.ageInDays(now)} hari',
                          ),
                          const VerticalDivider(
                            width: AppSpacing.md,
                          ),
                        ],
                        Expanded(
                          child: _Stat(
                            label: 'Luas lahan',
                            value: '$area ${farm.areaUnit}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (season != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    FarmStatusChip(
                      status: season.healthStatus,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 9,
              child: _FarmPhoto(
                url: farm.photoUrl,
                onDetailTap: onDetailTap,
                onEditTap: onEditTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodySmall,
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _FarmPhoto extends StatelessWidget {
  const _FarmPhoto({
    required this.url,
    required this.onDetailTap,
    required this.onEditTap,
  });

  final String? url;
  final VoidCallback onDetailTap;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    const placeholder = Image(
      image: AssetImage(_placeholderAsset),
      fit: BoxFit.cover,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 150),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (url == null)
              placeholder
            else
              CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                placeholder: (_, _) => placeholder,
                errorWidget: (_, _, _) => placeholder,
              ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: Material(
                color: AppColors.surface,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onEditTap,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: AppSpacing.sm,
              bottom: AppSpacing.sm,
              child: Material(
                color: AppColors.textPrimary.withValues(
                  alpha: 0.75,
                ),
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onDetailTap,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Text(
                      'Lihat Detail ›',
                      style: TextStyle(
                        color: AppColors.surface,
                        fontSize: 11,
                      ),
                    ),
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
