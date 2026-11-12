import 'package:flutter/foundation.dart';
import 'package:smart_tani_mobile/core/error/app_exception.dart';
import 'package:smart_tani_mobile/features/farm/data/model/farm_model.dart';
import 'package:smart_tani_mobile/features/farm/data/repositories/farm_repository.dart';

class HomeFarmProvider extends ChangeNotifier {
  HomeFarmProvider(this._repository);

  final FarmRepository _repository;

  bool isLoading = false;
  String? errorMessage;
  FarmModel? farm;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      farm = await _repository.getMainFarm();
    } on AppException catch (error) {
      errorMessage = error.message;
    }

    isLoading = false;
    notifyListeners();
  }
}
