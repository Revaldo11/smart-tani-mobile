import 'package:smart_tani_mobile/core/error/error_handler.dart';
import 'package:smart_tani_mobile/features/activity/data/datasources/activity_remote_datasource.dart';
import 'package:smart_tani_mobile/features/activity/data/model/activity_model.dart';

class ActivityRepository {
  ActivityRepository(this._remoteDataSource);

  final ActivityRemoteDataSource _remoteDataSource;

  Future<List<ActivityModel>> getTodayActivities(
    int seasonId,
  ) async {
    try {
      return await _remoteDataSource.getTodayActivities(
        seasonId,
      );
    } catch (error) {
      throw ErrorHandler.handle(error);
    }
  }
}
