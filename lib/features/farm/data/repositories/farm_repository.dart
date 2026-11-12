import 'package:smart_tani_mobile/core/error/error_handler.dart';
import 'package:smart_tani_mobile/features/farm/data/datasources/farm_remote_datasource.dart';
import 'package:smart_tani_mobile/features/farm/data/model/farm_model.dart';

class FarmRepository {
  FarmRepository(this._remoteDataSource);

  final FarmRemoteDataSource _remoteDataSource;

  Future<FarmModel?> getMainFarm() async {
    try {
      return await _remoteDataSource.getMainFarm();
    } catch (error) {
      throw ErrorHandler.handle(error);
    }
  }
}
