import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/weather_provider.dart';
import '../../domain/models/weather_model.dart';

class WeatherCard extends ConsumerWidget {
  const WeatherCard({super.key});

  String _getWeatherIcon(String iconCode) {
    // Map OpenWeatherMap icon codes to emoji or Material icons
    switch (iconCode) {
      case '01d': // clear sky day
        return '☀️';
      case '01n': // clear sky night
        return '🌙';
      case '02d': // few clouds day
        return '⛅';
      case '02n': // few clouds night
        return '☁️';
      case '03d':
      case '03n': // scattered clouds
        return '☁️';
      case '04d':
      case '04n': // broken clouds
        return '☁️';
      case '09d':
      case '09n': // shower rain
        return '🌧️';
      case '10d': // rain day
        return '🌦️';
      case '10n': // rain night
        return '🌧️';
      case '11d':
      case '11n': // thunderstorm
        return '⛈️';
      case '13d':
      case '13n': // snow
        return '❄️';
      case '50d':
      case '50n': // mist
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.featureBlue.withValues(alpha: 0.1),
            AppColors.featureBlue.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(
          color: AppColors.featureBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: weatherAsync.when(
        data: (weather) {
          if (weather == null) {
            return _buildErrorState(context);
          }
          return _buildWeatherContent(context, weather);
        },
        loading: () => _buildLoadingState(context),
        error: (error, stack) => _buildErrorState(context),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(DesignTokens.spacingS),
          decoration: BoxDecoration(
            color: AppColors.featureBlue.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          child: const SizedBox(
            width: DesignTokens.iconSizeM,
            height: DesignTokens.iconSizeM,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
        const SizedBox(width: DesignTokens.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Loading weather...',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeL,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: AppColors.featureBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(DesignTokens.spacingS),
          decoration: BoxDecoration(
            color: AppColors.featureBlue.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          child: Icon(
            Icons.cloud_off,
            color: AppColors.featureBlue,
            size: DesignTokens.iconSizeM,
          ),
        ),
        const SizedBox(width: DesignTokens.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weather unavailable',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeL,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: AppColors.featureBlue,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingXS / 2),
              Text(
                'Unable to fetch weather data',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeS,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherContent(BuildContext context, WeatherModel weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingS),
              decoration: BoxDecoration(
                color: AppColors.featureBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              child: Text(
                _getWeatherIcon(weather.icon),
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: DesignTokens.iconSizeS,
                        color: AppColors.featureBlue,
                      ),
                      const SizedBox(width: DesignTokens.spacingXS / 2),
                      Expanded(
                        child: Text(
                          weather.location,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeL,
                            fontWeight: DesignTokens.fontWeightBold,
                            color: AppColors.featureBlue,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingXS / 2),
                  Text(
                    _capitalizeFirst(weather.description),
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeS,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${weather.temperature.toStringAsFixed(0)}°C',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeH5,
                    fontWeight: DesignTokens.fontWeightBold,
                    color: AppColors.featureBlue,
                  ),
                ),
                Text(
                  'Feels like ${weather.feelsLike.toStringAsFixed(0)}°C',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeXS,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingM),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildWeatherDetail(
              context,
              icon: Icons.water_drop,
              label: 'Humidity',
              value: '${weather.humidity.toStringAsFixed(0)}%',
            ),
            _buildWeatherDetail(
              context,
              icon: Icons.air,
              label: 'Wind',
              value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
            ),
            if (weather.visibility > 0)
              _buildWeatherDetail(
                context,
                icon: Icons.visibility,
                label: 'Visibility',
                value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherDetail(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: DesignTokens.iconSizeS,
          color: AppColors.featureBlue.withValues(alpha: 0.7),
        ),
        const SizedBox(height: DesignTokens.spacingXS / 2),
        Text(
          value,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeS,
            fontWeight: DesignTokens.fontWeightSemiBold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeXS,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}
