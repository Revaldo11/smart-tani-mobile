import 'package:go_router/go_router.dart';
import 'package:smart_tani_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:smart_tani_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:smart_tani_mobile/features/auth/presentation/providers/auth_session_provider.dart';

import '../../core/storage/preference_service.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'route_names.dart';

GoRouter createRouter({
  required AuthSessionProvider authSessionProvider,
  required PreferenceService preferenceService,
}) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: authSessionProvider,

    redirect: (context, state) {
      final status = authSessionProvider.status;

      final location = state.matchedLocation;

      if (status == AuthStatus.initial) {
        return location == RouteNames.splash
            ? null
            : RouteNames.splash;
      }

      final isAuthenticated =
          status == AuthStatus.authenticated;

      if (isAuthenticated) {
        if (location == RouteNames.splash ||
            location == RouteNames.login ||
            location == RouteNames.register) {
          return RouteNames.home;
        }

        return null;
      }

      final hasSeenOnboarding =
          preferenceService.hasSeenOnboarding;

      if (location == RouteNames.splash) {
        return hasSeenOnboarding
            ? RouteNames.login
            : RouteNames
                  .login; //! DONT FORGET CHANGE THIS IF ONBOARDING READY
      }

      return null;
    },

    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (_, _) => const SplashPage(),
      ),

      GoRoute(
        path: RouteNames.login,
        builder: (_, _) => const LoginPage(),
      ),

      GoRoute(
        path: RouteNames.register,
        builder: (_, _) => const RegisterPage(),
      ),

      // onboarding & home ditambahkan
      // ketika page-nya tersedia.
    ],
  );
}
