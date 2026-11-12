import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:smart_tani_mobile/core/constant/api_constant.dart';
import 'package:smart_tani_mobile/features/home/data/model/weather_snapshot_model.dart';

class WeatherRemoteDataSource {
  WeatherRemoteDataSource(this._dio);

  final Dio _dio;

  /// Returns null when no snapshot is available.
  // shortcut: '/farms/{id}/weather' is a placeholder path;
  // confirm with the API contract.
  Future<WeatherSnapshotModel?> getWeather(
    int farmId,
  ) async {
    final Object? data;

    if (ApiConstants.isDummyData) {
      final raw = await rootBundle.loadString(
        'assets/dummy/weather.json',
      );
      data =
          (jsonDecode(raw) as Map<String, dynamic>)['data'];
    } else {
      final response = await _dio.get<Map<String, dynamic>>(
        '/farms/$farmId/weather',
      );
      data = response.data?['data'];
    }

    return data is Map<String, dynamic>
        ? WeatherSnapshotModel.fromJson(data)
        : null;
  }
}
