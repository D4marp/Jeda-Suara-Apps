import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../data/location_weather_repository_impl.dart';
import '../../data/open_meteo_client.dart';
import '../../domain/entities/current_weather.dart';
import '../../domain/repositories/location_weather_repository.dart';

final weatherHttpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final locationWeatherRepositoryProvider = Provider<LocationWeatherRepository>(
  (ref) => LocationWeatherRepositoryImpl(
    OpenMeteoClient(ref.watch(weatherHttpClientProvider)),
  ),
);

final locationWeatherProvider =
    AsyncNotifierProvider<LocationWeatherNotifier, CurrentWeather?>(
      LocationWeatherNotifier.new,
    );

class LocationWeatherNotifier extends AsyncNotifier<CurrentWeather?> {
  @override
  FutureOr<CurrentWeather?> build() => null;

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      ref.read(locationWeatherRepositoryProvider).getCurrentWeather,
    );
  }
}
