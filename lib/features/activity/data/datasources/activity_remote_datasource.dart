import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:smart_tani_mobile/core/constant/api_constant.dart';
import 'package:smart_tani_mobile/features/activity/data/model/activity_model.dart';

class ActivityRemoteDataSource {
  ActivityRemoteDataSource(this._dio);

  final Dio _dio;

  // shortcut: '/planting-seasons/{id}/activities/today' is a
  // placeholder path; confirm with the API contract.
  Future<List<ActivityModel>> getTodayActivities(
    int seasonId,
  ) async {
    final Object? data;

    if (ApiConstants.isDummyData) {
      final raw = await rootBundle.loadString(
        'assets/dummy/today_activities.json',
      );
      data =
          (jsonDecode(raw) as Map<String, dynamic>)['data'];
    } else {
      final response = await _dio.get<Map<String, dynamic>>(
        '/planting-seasons/$seasonId/activities/today',
      );
      data = response.data?['data'];
    }

    return data is List
        ? data
              .cast<Map<String, dynamic>>()
              .map(ActivityModel.fromJson)
              .toList()
        : [];
  }
}
