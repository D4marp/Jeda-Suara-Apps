import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../domain/repositories/location_weather_repository.dart';

class OpenMeteoReading {
  const OpenMeteoReading({
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.observedAt,
  });

  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final DateTime observedAt;
}

class OpenMeteoClient {
  OpenMeteoClient(this._client);

  final http.Client _client;

  Future<OpenMeteoReading> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current': [
        'temperature_2m',
        'apparent_temperature',
        'relative_humidity_2m',
        'weather_code',
        'wind_speed_10m',
      ].join(','),
      'timezone': 'auto',
    });

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 12));
      if (response.statusCode != HttpStatus.ok) {
        throw const LocationWeatherFailure(
          LocationWeatherFailureType.network,
          'Layanan cuaca sedang tidak tersedia. Coba lagi nanti.',
        );
      }
      return parse(response.body);
    } on LocationWeatherFailure {
      rethrow;
    } on SocketException {
      throw const LocationWeatherFailure(
        LocationWeatherFailureType.network,
        'Tidak ada koneksi internet untuk mengambil cuaca.',
      );
    } on http.ClientException {
      throw const LocationWeatherFailure(
        LocationWeatherFailureType.network,
        'Tidak ada koneksi internet untuk mengambil cuaca.',
      );
    } on HttpException {
      throw const LocationWeatherFailure(
        LocationWeatherFailureType.network,
        'Layanan cuaca gagal dihubungi.',
      );
    } on FormatException {
      throw const LocationWeatherFailure(
        LocationWeatherFailureType.invalidResponse,
        'Data cuaca yang diterima tidak valid.',
      );
    } on TimeoutException {
      throw const LocationWeatherFailure(
        LocationWeatherFailureType.requestTimeout,
        'Permintaan cuaca terlalu lama. Silakan coba lagi.',
      );
    }
  }

  static OpenMeteoReading parse(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Root response must be an object.');
    }
    final current = decoded['current'];
    if (current is! Map<String, dynamic>) {
      throw const FormatException('Missing current weather.');
    }

    double number(String key) {
      final value = current[key];
      if (value is! num) throw FormatException('Invalid $key.');
      return value.toDouble();
    }

    int integer(String key) => number(key).round();
    final time = DateTime.tryParse(current['time']?.toString() ?? '');
    if (time == null) throw const FormatException('Invalid observation time.');

    return OpenMeteoReading(
      temperature: number('temperature_2m'),
      apparentTemperature: number('apparent_temperature'),
      humidity: integer('relative_humidity_2m'),
      windSpeed: number('wind_speed_10m'),
      weatherCode: integer('weather_code'),
      observedAt: time,
    );
  }
}
