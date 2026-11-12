import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/theme/app_colors.dart';
import 'package:smart_tani_mobile/core/theme/app_spacing.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/daily_tip_card.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/home_greeting.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/home_header.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/quick_actions.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    required this.userName,
    required this.avatarUrl,
    required this.now,
    required this.farmSection,
    required this.weatherSection,
    required this.activitiesSection,
    required this.onNotificationTap,
    required this.onQuickActionTap,
    required this.onTipTap,
    super.key,
  });

  final String? userName;
  final String? avatarUrl;
  final DateTime now;
  final Widget farmSection;
  final Widget weatherSection;
  final Widget activitiesSection;
  final VoidCallback onNotificationTap;
  final VoidCallback onQuickActionTap;
  final VoidCallback onTipTap;

  static const double _backgroundHeight = 380;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: _backgroundHeight,
              child: _HeroBackground(),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    HomeHeader(
                      avatarUrl: avatarUrl,
                      onNotificationTap: onNotificationTap,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    HomeGreeting(
                      userName: userName,
                      now: now,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    farmSection,
                    const SizedBox(height: AppSpacing.md),
                    weatherSection,
                    const SizedBox(height: AppSpacing.md),
                    activitiesSection,
                    const SizedBox(height: AppSpacing.md),
                    QuickActions(onTap: onQuickActionTap),
                    const SizedBox(height: AppSpacing.md),
                    DailyTipCard(now: now, onTap: onTipTap),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBackground extends StatelessWidget {
  const _HeroBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/home_bg.jpg',
          fit: BoxFit.cover,
          cacheWidth: 1080,
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              stops: [0.0, 0.6],
              tileMode: TileMode.mirror,
              transform: GradientRotation(3.13 / 4),
              colors: [
                Color(0x00F8FAF8),
                AppColors.background,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
