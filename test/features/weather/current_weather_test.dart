import 'package:flutter_dpl_prd_app/features/weather/domain/entities/current_weather.dart';
import 'package:flutter_test/flutter_test.dart';

CurrentWeather weatherWithCode(int code) => CurrentWeather(
  locationName: 'Semarang',
  latitude: -6.96,
  longitude: 110.41,
  temperature: 30,
  apparentTemperature: 34,
  humidity: 70,
  windSpeed: 8,
  weatherCode: code,
  observedAt: DateTime(2026, 10, 14),
);

void main() {
  test('memetakan kode WMO ke deskripsi Bahasa Indonesia', () {
    expect(weatherWithCode(0).description, 'Cerah');
    expect(weatherWithCode(2).description, 'Cerah berawan');
    expect(weatherWithCode(63).description, 'Hujan');
    expect(weatherWithCode(95).description, 'Badai petir');
    expect(weatherWithCode(999).description, 'Cuaca tidak diketahui');
  });
}
