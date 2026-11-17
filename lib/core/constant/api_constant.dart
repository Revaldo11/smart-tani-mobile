abstract final class ApiConstants {
  static const String baseUrl =
      'http://10.142.112.118:8000/api/v1';

  // Dummy-data switch: endpoints without a backend yet read
  // assets/dummy/*.json. Set to false once the API exists.
  static const bool isDummyData = true;

  static const Duration connectTimeout = Duration(
    seconds: 30,
  );
  static const Duration receiveTimeout = Duration(
    seconds: 30,
  );
  static const Duration sendTimeout = Duration(seconds: 30);
}
