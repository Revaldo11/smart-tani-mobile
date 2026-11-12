import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/theme/app_typography.dart';

String greetingFor(DateTime time) {
  final hour = time.hour;
  if (hour < 11) return 'Selamat pagi';
  if (hour < 15) return 'Selamat siang';
  if (hour < 18) return 'Selamat sore';
  return 'Selamat malam';
}

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({
    required this.userName,
    required this.now,
    super.key,
  });

  final String? userName;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final name = userName?.trim();
    final displayName = (name == null || name.isEmpty)
        ? 'Petani'
        : name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${greetingFor(now)},',
          style: AppTypography.bodyLarge,
        ),
        Text(
          '$displayName 👋',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.headingLarge.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        Text(
          'Semoga hari ini sawahnya semakin subur.',
          style: AppTypography.bodySmall.copyWith(
            fontSize: 12,
            color: Color(0XFF14181F).withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
