import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:smart_tani_mobile/core/constant/api_constant.dart';
import 'package:smart_tani_mobile/features/farm/data/model/farm_model.dart';

class FarmRemoteDataSource {
  FarmRemoteDataSource(this._dio);

  final Dio _dio;

  /// Returns null when the user has no farm yet.
  // shortcut: '/farms/main' is a placeholder path; confirm
  // with the API contract.
  Future<FarmModel?> getMainFarm() async {
    final Object? data;

    if (ApiConstants.isDummyData) {
      final raw = await rootBundle.loadString(
        'assets/dummy/main_farm.json',
      );
      data =
          (jsonDecode(raw) as Map<String, dynamic>)['data'];
    } else {
      final response = await _dio.get<Map<String, dynamic>>(
        '/farms/main',
      );
      data = response.data?['data'];
    }

    return data is Map<String, dynamic>
        ? FarmModel.fromJson(data)
        : null;
  }
}
