import '../entities/current_weather.dart';

abstract interface class LocationWeatherRepository {
  Future<CurrentWeather> getCurrentWeather();
}

enum LocationWeatherFailureType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  requestTimeout,
  network,
  invalidResponse,
  unknown,
}

class LocationWeatherFailure implements Exception {
  const LocationWeatherFailure(this.type, this.message);

  final LocationWeatherFailureType type;
  final String message;

  @override
  String toString() => message;
}
