class WeatherSnapshotModel {
  const WeatherSnapshotModel({
    required this.temperature,
    required this.condition,
    required this.conditionCode,
    this.location,
    this.humidity,
    this.rainChance,
    this.windSpeed,
    this.adviceTitle,
    this.adviceDetail,
  });

  // Field names are assumptions until the API contract is
  // confirmed (spec T3).
  factory WeatherSnapshotModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WeatherSnapshotModel(
      temperature: (json['temperature'] as num).toDouble(),
      condition: json['condition'] as String,
      conditionCode: json['condition_code'] as String?,
      location: json['location'] as String?,
      humidity: (json['humidity'] as num?)?.toDouble(),
      rainChance: (json['rain_chance'] as num?)?.toDouble(),
      windSpeed: (json['wind_speed'] as num?)?.toDouble(),
      adviceTitle: json['advice_title'] as String?,
      adviceDetail: json['advice_detail'] as String?,
    );
  }

  final double temperature;
  final String condition;
  final String? conditionCode;
  final String? location;
  final double? humidity;
  final double? rainChance;

  /// km/h.
  final double? windSpeed;
  final String? adviceTitle;
  final String? adviceDetail;
}
