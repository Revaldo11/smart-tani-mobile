import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_tani_mobile/core/theme/app_colors.dart';
import 'package:smart_tani_mobile/core/theme/app_spacing.dart';
import 'package:smart_tani_mobile/core/theme/app_typography.dart';
import 'package:smart_tani_mobile/features/home/data/model/weather_snapshot_model.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/home_card.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/weather_advice_banner.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/weather_metric.dart';

// Codes are assumed until the API contract is confirmed.
// IconData _conditionIcon(String? code) => switch (code) {
//   'clear' => Icons.wb_sunny_outlined,
//   'partly_cloudy' => Icons.wb_cloudy_outlined,
//   'cloudy' => Icons.cloud_outlined,
//   'rain' => Icons.grain,
//   'thunderstorm' => Icons.thunderstorm_outlined,
//   _ => Icons.wb_cloudy_outlined,
// };

/// Hidden when there is no farm; otherwise loading / error / empty /
/// success.
class WeatherCard extends StatelessWidget {
  const WeatherCard({
    required this.hasFarm,
    required this.isLoading,
    required this.errorMessage,
    required this.weather,
    required this.onRetry,
    required this.onTap,
    super.key,
  });

  final bool hasFarm;
  final bool isLoading;
  final String? errorMessage;
  final WeatherSnapshotModel? weather;
  final VoidCallback onRetry;
  final VoidCallback onTap;

  static String _percent(double? v, NumberFormat f) =>
      v == null ? '-' : '${f.format(v)}%';

  @override
  Widget build(BuildContext context) {
    if (!hasFarm) return const SizedBox.shrink();

    return HomeCard(child: _body());
  }

  Widget _body() {
    final weather = this.weather;

    if (weather == null) {
      if (isLoading) {
        return const SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      final error = errorMessage;

      return Column(
        children: [
          Text(
            error ?? 'Cuaca belum tersedia',
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
      );
    }

    final number = NumberFormat('0.##', 'id_ID');
    final wind = weather.windSpeed;
    final title = weather.adviceTitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                'Cuaca Hari Ini',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (weather.location != null)
              Flexible(
                child: InkWell(
                  onTap: onTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                      ),
                      Flexible(
                        child: Text(
                          weather.location!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        IntrinsicHeight(
          child: Row(
            children: [
              // Icon(
              //   _conditionIcon(weather.conditionCode),
              //   size: 40,
              //   color: AppColors.primary,
              // ),
              // const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      '${number.format(weather.temperature)}°C',
                      style: AppTypography.headingLarge,
                    ),
                    Text(
                      weather.condition,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall
                          .copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 3,
                child: WeatherMetric(
                  icon: 'icon_irigasi_fill',
                  value: _percent(weather.humidity, number),
                  label: 'Kelembapan',
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 3,
                child: WeatherMetric(
                  icon: 'icon_rain',
                  value: _percent(
                    weather.rainChance,
                    number,
                  ),
                  label: 'Peluang Hujan',
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 3,
                child: WeatherMetric(
                  icon: 'icon_wind',
                  value: wind == null
                      ? '-'
                      : '${number.format(wind)} km/j',
                  label: 'Kecepatan Angin',
                ),
              ),
            ],
          ),
        ),
        if (title != null) ...[
          const SizedBox(height: AppSpacing.md),
          WeatherAdviceBanner(
            title: title,
            detail: weather.adviceDetail,
            onTap: onTap,
          ),
        ],
      ],
    );
  }
}
