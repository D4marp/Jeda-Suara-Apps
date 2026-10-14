class CurrentWeather {
  const CurrentWeather({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.observedAt,
  });

  final String locationName;
  final double latitude;
  final double longitude;
  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final DateTime observedAt;

  String get description => switch (weatherCode) {
    0 => 'Cerah',
    1 || 2 => 'Cerah berawan',
    3 => 'Berawan',
    45 || 48 => 'Berkabut',
    51 || 53 || 55 => 'Gerimis',
    56 || 57 => 'Gerimis beku',
    61 || 63 || 65 => 'Hujan',
    66 || 67 => 'Hujan beku',
    71 || 73 || 75 || 77 => 'Bersalju',
    80 || 81 || 82 => 'Hujan lokal',
    85 || 86 => 'Hujan salju',
    95 => 'Badai petir',
    96 || 99 => 'Badai petir & hujan es',
    _ => 'Cuaca tidak diketahui',
  };
}
