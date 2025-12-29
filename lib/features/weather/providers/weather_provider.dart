import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/weather_service.dart';
import '../domain/models/weather_model.dart';

// Weather service provider (singleton, no autoDispose)
final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService();
});

// Weather provider (auto-disposing for better memory management)
final weatherProvider = FutureProvider.autoDispose<WeatherModel?>((ref) async {
  final weatherService = ref.watch(weatherServiceProvider);
  return await weatherService.getCurrentWeather();
});
