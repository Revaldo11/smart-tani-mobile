import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tani_mobile/core/widget/global_snackbar.dart';
import 'package:smart_tani_mobile/features/auth/presentation/providers/auth_session_provider.dart';
import 'package:smart_tani_mobile/core/network/dio_client.dart';
import 'package:smart_tani_mobile/features/activity/data/datasources/activity_remote_datasource.dart';
import 'package:smart_tani_mobile/features/activity/data/repositories/activity_repository.dart';
import 'package:smart_tani_mobile/features/home/presentation/providers/home_activities_provider.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/today_activities_card.dart';
import 'package:smart_tani_mobile/features/farm/data/datasources/farm_remote_datasource.dart';
import 'package:smart_tani_mobile/features/farm/data/repositories/farm_repository.dart';
import 'package:smart_tani_mobile/features/home/data/datasources/weather_remote_datasource.dart';
import 'package:smart_tani_mobile/features/home/data/repositories/weather_repository.dart';
import 'package:smart_tani_mobile/features/home/presentation/providers/home_farm_provider.dart';
import 'package:smart_tani_mobile/features/home/presentation/providers/home_weather_provider.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/weather_card.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/home_farm_section.dart';
import 'package:smart_tani_mobile/features/home/presentation/widgets/home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showComingSoon(BuildContext context) {
    showGlobalSnackbar(
      context,
      title: 'Fitur Belum Tersedia',
      subtitle: 'Fitur ini masih dalam pengembangan.',
      mode: SnackBarMode.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeFarmProvider(
            FarmRepository(
              FarmRemoteDataSource(
                context.read<DioClient>().dio,
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeWeatherProvider(
            WeatherRepository(
              WeatherRemoteDataSource(
                context.read<DioClient>().dio,
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeActivitiesProvider(
            ActivityRepository(
              ActivityRemoteDataSource(
                context.read<DioClient>().dio,
              ),
            ),
          ),
        ),
      ],
      child: Builder(builder: _initAndBuild),
    );
  }

  // Weather depends on the main farm id, so load it after the farm.
  Future<void> _loadAll(BuildContext context) async {
    final farm = context.read<HomeFarmProvider>();
    final weather = context.read<HomeWeatherProvider>();
    final activities = context
        .read<HomeActivitiesProvider>();
    await farm.load();
    await Future.wait([
      weather.load(farm.farm?.id),
      activities.load(farm.farm?.activeSeason?.id),
    ]);
  }

  Widget _initAndBuild(BuildContext context) {
    return _InitOnce(
      onInit: () => _loadAll(context),
      child: Builder(builder: _buildView),
    );
  }

  Widget _buildView(BuildContext context) {
    final farm = context.watch<HomeFarmProvider>();
    final weather = context.watch<HomeWeatherProvider>();
    final activities = context
        .watch<HomeActivitiesProvider>();
    final user = context.watch<AuthSessionProvider>().user;

    return HomeView(
      userName: user?.name,
      avatarUrl: user?.avatarUrl,
      now: DateTime.now(),
      farmSection: HomeFarmSection(
        isLoading: farm.isLoading,
        errorMessage: farm.errorMessage,
        farm: farm.farm,
        now: DateTime.now(),
        onRetry: () => _loadAll(context),
        onDetailTap: () => _showComingSoon(context),
        onEditTap: () => _showComingSoon(context),
        onAddTap: () => _showComingSoon(context),
      ),
      weatherSection: WeatherCard(
        hasFarm: weather.hasFarm,
        isLoading: weather.isLoading,
        errorMessage: weather.errorMessage,
        weather: weather.weather,
        onRetry: weather.retry,
        onTap: () => _showComingSoon(context),
      ),
      activitiesSection: TodayActivitiesCard(
        hasSeason: activities.hasSeason,
        isLoading: activities.isLoading,
        errorMessage: activities.errorMessage,
        activities: activities.activities,
        onRetry: activities.retry,
        // Activity detail route and tab switching don't exist yet.
        onActivityTap: (_) => _showComingSoon(context),
        onSeeAllTap: () => _showComingSoon(context),
      ),
      onNotificationTap: () => _showComingSoon(context),
      onQuickActionTap: () => _showComingSoon(context),
      onTipTap: () => _showComingSoon(context),
    );
  }
}

/// Runs [onInit] once, after the first frame.
class _InitOnce extends StatefulWidget {
  const _InitOnce({
    required this.onInit,
    required this.child,
  });

  final VoidCallback onInit;
  final Widget child;

  @override
  State<_InitOnce> createState() => _InitOnceState();
}

class _InitOnceState extends State<_InitOnce> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onInit(),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
