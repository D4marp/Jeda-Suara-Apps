import 'package:flutter_dpl_prd_app/features/weather/data/open_meteo_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OpenMeteoClient.parse', () {
    test('memetakan current weather dari respons Open-Meteo', () {
      const body = '''
      {
        "current": {
          "time": "2026-10-14T10:15",
          "temperature_2m": 29.6,
          "apparent_temperature": 33.2,
          "relative_humidity_2m": 71,
          "weather_code": 2,
          "wind_speed_10m": 8.4
        }
      }
      ''';

      final result = OpenMeteoClient.parse(body);

      expect(result.temperature, 29.6);
      expect(result.apparentTemperature, 33.2);
      expect(result.humidity, 71);
      expect(result.weatherCode, 2);
      expect(result.windSpeed, 8.4);
      expect(result.observedAt, DateTime(2026, 10, 14, 10, 15));
    });

    test('menolak respons tanpa data current', () {
      expect(
        () => OpenMeteoClient.parse('{"latitude": -6.9}'),
        throwsFormatException,
      );
    });

    test('menolak nilai cuaca dengan tipe yang salah', () {
      const body = '''
      {
        "current": {
          "time": "2026-10-14T10:15",
          "temperature_2m": "panas",
          "apparent_temperature": 33.2,
          "relative_humidity_2m": 71,
          "weather_code": 2,
          "wind_speed_10m": 8.4
        }
      }
      ''';

      expect(() => OpenMeteoClient.parse(body), throwsFormatException);
    });
  });
}
