import 'package:smart_tani_mobile/features/planting_season/data/model/planting_season_model.dart';

class FarmModel {
  const FarmModel({
    required this.id,
    required this.name,
    required this.area,
    required this.areaUnit,
    this.photoUrl,
    this.activeSeason,
  });

  factory FarmModel.fromJson(Map<String, dynamic> json) {
    final season = json['active_season'];

    return FarmModel(
      id: json['id'] as int,
      name: json['name'] as String,
      area: (json['area'] as num).toDouble(),
      areaUnit: json['area_unit'] as String,
      photoUrl: json['photo_url'] as String?,
      activeSeason: season is Map<String, dynamic>
          ? PlantingSeasonModel.fromJson(season)
          : null,
    );
  }

  final int id;
  final String name;
  final double area;
  final String areaUnit;
  final String? photoUrl;
  final PlantingSeasonModel? activeSeason;
}
