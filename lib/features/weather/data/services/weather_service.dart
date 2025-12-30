import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/network_helper.dart';
import '../../domain/models/weather_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _vadodaraLat = '22.3072';
  static const String _vadodaraLon = '73.1812';
  static const String _vadodaraName = 'Vadodara';

  /// Get weather API key from environment
  String get _apiKey {
    return AppConfig.weatherApiKey;
  }

  /// Check if weather API key is configured
  bool get isApiKeyConfigured {
    final key = _apiKey;
    return key.isNotEmpty && key != 'your_api_key_here';
  }

  /// Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppLogger.warning('Location services are disabled');
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppLogger.warning('Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppLogger.warning('Location permissions are permanently denied');
        return null;
      }

      // Fast path: last known position (instant, no GPS wait)
      try {
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) return lastKnown;
      } catch (_) {
        // Ignore and fall back to active location request.
      }

      // Active request: keep timeout short to avoid blocking UX
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest,
        timeLimit: const Duration(seconds: 4),
      );

      return position;
    } catch (e) {
      AppLogger.error('Error getting location: $e');
      return null;
    }
  }

  /// Get weather by coordinates
  Future<WeatherModel?> getWeatherByCoordinates(
    double latitude,
    double longitude,
    String locationName,
  ) async {
    // Check network connectivity before making request
    try {
      await NetworkHelper.ensureNetworkConnectivity();
    } catch (e) {
      AppLogger.warning('No network connectivity: $e');
      return null;
    }

    // Always try the API call - let it fail if key is invalid
    // This ensures fallback always attempts to get weather
    final apiKey = _apiKey;
    if (apiKey.isEmpty) {
      AppLogger.warning('Weather API key is empty, attempting request anyway');
      // Continue to attempt the call - API will return error but we tried
    }

    try {
      final url = Uri.parse(
        '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
      );

      final response = await http.get(url).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(jsonData, locationName);
      } else {
        AppLogger.error(
          'Weather API error: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      AppLogger.error('Error fetching weather: $e');
      return null;
    }
  }

  /// Get weather by city name
  Future<WeatherModel?> getWeatherByCityName(String cityName) async {
    // Check network connectivity before making request
    try {
      await NetworkHelper.ensureNetworkConnectivity();
    } catch (e) {
      AppLogger.warning('No network connectivity: $e');
      return null;
    }

    // Always try the API call - let it fail if key is invalid
    // This ensures fallback always attempts to get weather
    final apiKey = _apiKey;
    if (apiKey.isEmpty) {
      AppLogger.warning('Weather API key is empty, attempting request anyway');
      // Continue to attempt the call - API will return error but we tried
    }

    try {
      final url = Uri.parse(
        '$_baseUrl/weather?q=$cityName&appid=$apiKey&units=metric',
      );

      final response = await http.get(url).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(jsonData, cityName);
      } else {
        AppLogger.error(
          'Weather API error: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      AppLogger.error('Error fetching weather: $e');
      return null;
    }
  }

  /// Get weather for current location or fallback to Vadodara
  Future<WeatherModel?> getCurrentWeather() async {
    // Check API key first
    if (!isApiKeyConfigured) {
      AppLogger.warning(
          'Weather API key not configured, using Vadodara weather');
      // Still try to get Vadodara weather - let the API call handle the error
    }

    // Try to get current location
    Position? position;
    try {
      position = await getCurrentLocation();
    } catch (e) {
      AppLogger.warning('Error getting location: $e');
    }

    if (position != null) {
      // Try to get weather for current location
      try {
        final weather = await getWeatherByCoordinates(
          position.latitude,
          position.longitude,
          'Current Location',
        );

        if (weather != null) {
          return weather;
        }
      } catch (e) {
        AppLogger.warning('Error fetching weather for current location: $e');
      }
    }

    // Always fallback to Vadodara weather
    AppLogger.info('Falling back to Vadodara weather');
    try {
      final vadodaraWeather = await getWeatherByCoordinates(
        double.parse(_vadodaraLat),
        double.parse(_vadodaraLon),
        _vadodaraName,
      );

      if (vadodaraWeather != null) {
        return vadodaraWeather;
      }

      // If coordinates fail, try by city name
      return await getWeatherByCityName(_vadodaraName);
    } catch (e) {
      AppLogger.error('Error fetching Vadodara weather: $e');
      // Try by city name as last resort
      try {
        return await getWeatherByCityName(_vadodaraName);
      } catch (e2) {
        AppLogger.error('Error fetching Vadodara weather by city name: $e2');
        return null;
      }
    }
  }
}
