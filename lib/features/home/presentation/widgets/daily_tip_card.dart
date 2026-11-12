import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/theme/app_colors.dart';
import 'package:smart_tani_mobile/core/theme/app_spacing.dart';
import 'package:smart_tani_mobile/core/theme/app_typography.dart';

// shortcut: local list, swap for the API when a tips endpoint exists.
const _tips = [
  'Pastikan tinggi air di sawah 3–5 cm untuk mendukung pertumbuhan padi yang optimal.',
  'Periksa daun padi secara rutin untuk mendeteksi hama dan penyakit sejak dini.',
  'Lakukan pemupukan di pagi atau sore hari agar pupuk terserap lebih baik.',
  'Jaga jarak tanam yang teratur agar sirkulasi udara antar rumpun tetap baik.',
];

String tipFor(DateTime time) {
  final dayOfYear = time
      .difference(DateTime(time.year))
      .inDays;
  return _tips[dayOfYear % _tips.length];
}

class DailyTipCard extends StatelessWidget {
  const DailyTipCard({
    required this.now,
    required this.onTap,
    super.key,
  });

  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              const Icon(
                Icons.eco,
                color: AppColors.primary,
                size: 36,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tips Hari Ini',
                      style: AppTypography.headingSmall
                          .copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '“${tipFor(now)}”',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
