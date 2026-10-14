import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/palette.dart';
import '../../domain/entities/current_weather.dart';
import '../../domain/repositories/location_weather_repository.dart';
import '../providers/location_weather_notifier.dart';

class LocationWeatherCard extends ConsumerWidget {
  const LocationWeatherCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final weather = ref.watch(locationWeatherProvider);

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 18, 24, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: p.line),
      ),
      child: weather.when(
        skipLoadingOnRefresh: false,
        data: (data) => data == null
            ? _WeatherPrompt(
                onLoad: ref.read(locationWeatherProvider.notifier).load,
              )
            : _WeatherData(
                weather: data,
                onRefresh: ref.read(locationWeatherProvider.notifier).load,
              ),
        loading: () => const _WeatherLoading(),
        error: (error, _) => _WeatherError(
          error: error,
          onRetry: ref.read(locationWeatherProvider.notifier).load,
        ),
      ),
    );
  }
}

class _WeatherPrompt extends StatelessWidget {
  const _WeatherPrompt({required this.onLoad});

  final VoidCallback onLoad;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      children: [
        _WeatherIcon(icon: Icons.location_on_rounded, color: p.accent),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lokasi & Cuaca', style: AppText.overline(p.muted)),
              const SizedBox(height: 4),
              Text(
                'Lihat kondisi cuaca di sekitarmu.',
                style: TextStyle(color: p.ink, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        TextButton(onPressed: onLoad, child: const Text('Gunakan lokasi')),
      ],
    );
  }
}

class _WeatherLoading extends StatelessWidget {
  const _WeatherLoading();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      children: [
        SizedBox(
          width: 42,
          height: 42,
          child: CircularProgressIndicator(color: p.accent, strokeWidth: 3),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MENCARI LOKASI', style: AppText.overline(p.muted)),
              const SizedBox(height: 4),
              const Text('Mengambil cuaca terbaru…'),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeatherData extends StatelessWidget {
  const _WeatherData({required this.weather, required this.onRefresh});

  final CurrentWeather weather;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WeatherIcon(icon: _iconFor(weather.weatherCode), color: p.accent),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, size: 14, color: p.muted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          weather.locationName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.overline(p.muted),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weather.description,
                    style: TextStyle(
                      color: p.ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${weather.temperature.round()}°',
              style: AppText.display(p.ink, size: 36),
            ),
            IconButton(
              tooltip: 'Perbarui cuaca',
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Divider(height: 1, color: p.line),
        const SizedBox(height: 12),
        Wrap(
          spacing: 18,
          runSpacing: 8,
          children: [
            _Metric(
              icon: Icons.thermostat_rounded,
              label: 'Terasa ${weather.apparentTemperature.round()}°',
            ),
            _Metric(
              icon: Icons.water_drop_outlined,
              label: 'Lembap ${weather.humidity}%',
            ),
            _Metric(
              icon: Icons.air_rounded,
              label: '${weather.windSpeed.round()} km/j',
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Diperbarui ${_time(weather.observedAt)} • Data Open-Meteo',
          style: TextStyle(color: p.muted, fontSize: 11),
        ),
      ],
    );
  }

  String _time(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}.'
      '${value.minute.toString().padLeft(2, '0')}';

  IconData _iconFor(int code) {
    if (code == 0) return Icons.wb_sunny_rounded;
    if (code <= 3) return Icons.cloud_queue_rounded;
    if (code == 45 || code == 48) return Icons.blur_on_rounded;
    if (code >= 95) return Icons.thunderstorm_rounded;
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return Icons.ac_unit_rounded;
    }
    return Icons.water_drop_rounded;
  }
}

class _WeatherError extends StatelessWidget {
  const _WeatherError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final failure = error is LocationWeatherFailure
        ? error as LocationWeatherFailure
        : const LocationWeatherFailure(
            LocationWeatherFailureType.unknown,
            'Lokasi dan cuaca gagal dimuat.',
          );
    final canOpenSettings =
        failure.type == LocationWeatherFailureType.permissionDeniedForever ||
        failure.type == LocationWeatherFailureType.serviceDisabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WeatherIcon(icon: Icons.location_off_rounded, color: p.danger),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LOKASI BELUM TERSEDIA',
                    style: AppText.overline(p.danger),
                  ),
                  const SizedBox(height: 4),
                  Text(failure.message, style: TextStyle(color: p.muted)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (canOpenSettings)
              TextButton(
                onPressed: () {
                  if (failure.type ==
                      LocationWeatherFailureType.serviceDisabled) {
                    Geolocator.openLocationSettings();
                  } else {
                    Geolocator.openAppSettings();
                  }
                },
                child: const Text('Buka Pengaturan'),
              ),
            TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      ],
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, color: color),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: p.muted, size: 16),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: p.muted, fontSize: 12)),
      ],
    );
  }
}
