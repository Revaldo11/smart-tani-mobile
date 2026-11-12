import 'package:smart_tani_mobile/core/error/error_handler.dart';
import 'package:smart_tani_mobile/features/home/data/datasources/weather_remote_datasource.dart';
import 'package:smart_tani_mobile/features/home/data/model/weather_snapshot_model.dart';

class WeatherRepository {
  WeatherRepository(this._remoteDataSource);

  final WeatherRemoteDataSource _remoteDataSource;

  Future<WeatherSnapshotModel?> getWeather(
    int farmId,
  ) async {
    try {
      return await _remoteDataSource.getWeather(farmId);
    } catch (error) {
      throw ErrorHandler.handle(error);
    }
  }
}
