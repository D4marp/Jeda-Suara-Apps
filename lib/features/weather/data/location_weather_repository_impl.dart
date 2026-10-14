import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../domain/entities/current_weather.dart';
import '../domain/repositories/location_weather_repository.dart';
import 'open_meteo_client.dart';

class LocationWeatherRepositoryImpl implements LocationWeatherRepository {
  LocationWeatherRepositoryImpl(this._weatherClient, {Geocoding? geocoding})
    : _geocoding = geocoding ?? Geocoding();

  final OpenMeteoClient _weatherClient;
  final Geocoding _geocoding;

  @override
  Future<CurrentWeather> getCurrentWeather() async {
    final position = await _currentPosition();
    final results = await Future.wait<Object>([
      _weatherClient.getCurrentWeather(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
      _locationName(position.latitude, position.longitude),
    ]);
    final weather = results[0] as OpenMeteoReading;

    return CurrentWeather(
      locationName: results[1] as String,
      latitude: position.latitude,
      longitude: position.longitude,
      temperature: weather.temperature,
      apparentTemperature: weather.apparentTemperature,
      humidity: weather.humidity,
      windSpeed: weather.windSpeed,
      weatherCode: weather.weatherCode,
      observedAt: weather.observedAt,
    );
  }

  Future<Position> _currentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationWeatherFailure(
        LocationWeatherFailureType.serviceDisabled,
        'Layanan lokasi belum aktif. Aktifkan lokasi lalu coba lagi.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationWeatherFailure(
        LocationWeatherFailureType.permissionDenied,
        'Izin lokasi diperlukan untuk menampilkan cuaca sekitar.',
      );
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationWeatherFailure(
        LocationWeatherFailureType.permissionDeniedForever,
        'Izin lokasi diblokir. Buka Pengaturan untuk mengaktifkannya.',
      );
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } on TimeoutException {
      throw const LocationWeatherFailure(
        LocationWeatherFailureType.requestTimeout,
        'Lokasi belum ditemukan. Pastikan GPS aktif lalu coba lagi.',
      );
    }
  }

  Future<String> _locationName(double latitude, double longitude) async {
    final fallback =
        '${latitude.toStringAsFixed(4)}, '
        '${longitude.toStringAsFixed(4)}';
    try {
      final placemarks = await _geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
        locale: const Locale('id', 'ID'),
      );
      if (placemarks.isEmpty) return fallback;
      final place = placemarks.first;
      final parts =
          [place.subLocality, place.locality, place.administrativeArea]
              .whereType<String>()
              .map((part) => part.trim())
              .where((part) => part.isNotEmpty);
      final locationName = parts.toSet().take(2).join(', ');
      return locationName.isEmpty ? fallback : locationName;
    } catch (_) {
      return fallback;
    }
  }
}
