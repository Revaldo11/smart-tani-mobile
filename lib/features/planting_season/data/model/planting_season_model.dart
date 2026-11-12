enum HealthStatus {
  good,
  warning,
  bad;

  // shortcut: status enum is TBD (spec Q4); unknown -> good.
  static HealthStatus parse(String? value) =>
      HealthStatus.values.firstWhere(
        (status) => status.name == value,
        orElse: () => HealthStatus.good,
      );
}

class PlantingSeasonModel {
  const PlantingSeasonModel({
    required this.id,
    required this.cropName,
    required this.plantingDate,
    required this.healthStatus,
    this.variety,
  });

  factory PlantingSeasonModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PlantingSeasonModel(
      id: json['id'] as int,
      cropName: json['crop_name'] as String,
      variety: json['variety'] as String?,
      plantingDate: DateTime.parse(
        json['planting_date'] as String,
      ),
      healthStatus: HealthStatus.parse(
        json['health_status'] as String?,
      ),
    );
  }

  final int id;
  final String cropName;
  final String? variety;
  final DateTime plantingDate;
  final HealthStatus healthStatus;

  String get cropLabel =>
      variety == null ? cropName : '$cropName $variety';

  int ageInDays(DateTime now) =>
      now.difference(plantingDate).inDays;
}
