import 'package:flutter/foundation.dart';
import 'package:smart_tani_mobile/core/error/app_exception.dart';
import 'package:smart_tani_mobile/features/activity/data/model/activity_model.dart';
import 'package:smart_tani_mobile/features/activity/data/repositories/activity_repository.dart';

class HomeActivitiesProvider extends ChangeNotifier {
  HomeActivitiesProvider(this._repository);

  static const int maxRows = 3;

  final ActivityRepository _repository;

  bool isLoading = false;
  String? errorMessage;
  List<ActivityModel> activities = const [];

  /// True once a season id was given; with no active season the
  /// card is hidden.
  bool hasSeason = false;
  int? _seasonId;

  /// Call with the active season id from T2. Null = no season.
  Future<void> load(int? seasonId) async {
    _seasonId = seasonId;
    hasSeason = seasonId != null;
    activities = const [];
    errorMessage = null;
    if (seasonId == null) {
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final all = await _repository.getTodayActivities(
        seasonId,
      );
      all.sort(
        (a, b) => a.scheduledAt.compareTo(b.scheduledAt),
      );
      activities = all.take(maxRows).toList();
    } on AppException catch (error) {
      errorMessage = error.message;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> retry() => load(_seasonId);
}
