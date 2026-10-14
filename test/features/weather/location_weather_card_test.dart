import 'package:flutter/material.dart';
import 'package:flutter_dpl_prd_app/core/theme/app_theme.dart';
import 'package:flutter_dpl_prd_app/features/weather/domain/entities/current_weather.dart';
import 'package:flutter_dpl_prd_app/features/weather/domain/repositories/location_weather_repository.dart';
import 'package:flutter_dpl_prd_app/features/weather/presentation/providers/location_weather_notifier.dart';
import 'package:flutter_dpl_prd_app/features/weather/presentation/widgets/location_weather_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeWeatherRepository implements LocationWeatherRepository {
  @override
  Future<CurrentWeather> getCurrentWeather() async => CurrentWeather(
    locationName: 'Semarang, Jawa Tengah',
    latitude: -6.9667,
    longitude: 110.4167,
    temperature: 30.2,
    apparentTemperature: 34.1,
    humidity: 72,
    windSpeed: 8.6,
    weatherCode: 2,
    observedAt: DateTime(2026, 10, 14, 13, 30),
  );
}

void main() {
  testWidgets('menampilkan prompt lalu data cuaca tanpa overflow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationWeatherRepositoryProvider.overrideWithValue(
            _FakeWeatherRepository(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: LocationWeatherCard()),
        ),
      ),
    );

    expect(find.text('Gunakan lokasi'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Gunakan lokasi'));
    await tester.pumpAndSettle();

    expect(find.text('Semarang, Jawa Tengah'), findsOneWidget);
    expect(find.text('Cerah berawan'), findsOneWidget);
    expect(find.text('30°'), findsOneWidget);
    expect(find.textContaining('Open-Meteo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
