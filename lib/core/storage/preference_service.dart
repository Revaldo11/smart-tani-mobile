import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  PreferenceService(this._preferences);

  final SharedPreferences _preferences;

  static const String _onboardingSeenKey = 'onboarding_seen';

  bool get hasSeenOnboarding {
    return _preferences.getBool(_onboardingSeenKey) ?? false;
  }

  Future<bool> setOnboardingSeen() {
    return _preferences.setBool(
      _onboardingSeenKey,
      true,
    );
  }
}