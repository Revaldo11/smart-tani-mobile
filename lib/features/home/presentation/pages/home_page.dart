import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tani_mobile/core/widget/global_snackbar.dart';
import 'package:smart_tani_mobile/features/auth/presentation/providers/auth_session_provider.dart';
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
    final user = context.watch<AuthSessionProvider>().user;

    return HomeView(
      userName: user?.name,
      avatarUrl: user?.avatarUrl,
      now: DateTime.now(),
      onNotificationTap: () => _showComingSoon(context),
      onQuickActionTap: () => _showComingSoon(context),
      onTipTap: () => _showComingSoon(context),
    );
  }
}
