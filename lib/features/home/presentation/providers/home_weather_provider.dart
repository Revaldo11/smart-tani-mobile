import 'package:flutter/foundation.dart';
import 'package:smart_tani_mobile/core/error/app_exception.dart';
import 'package:smart_tani_mobile/features/home/data/model/weather_snapshot_model.dart';
import 'package:smart_tani_mobile/features/home/data/repositories/weather_repository.dart';

class HomeWeatherProvider extends ChangeNotifier {
  HomeWeatherProvider(this._repository);

  final WeatherRepository _repository;

  bool isLoading = false;
  String? errorMessage;
  WeatherSnapshotModel? weather;

  /// True once a farm id was given; with no farm the card is hidden.
  bool hasFarm = false;
  int? _farmId;

  /// Call with the main farm id (T2). Null = user has no farm.
  Future<void> load(int? farmId) async {
    _farmId = farmId;
    hasFarm = farmId != null;
    weather = null;
    errorMessage = null;
    if (farmId == null) {
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      weather = await _repository.getWeather(farmId);
    } on AppException catch (error) {
      errorMessage = error.message;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> retry() => load(_farmId);
}
