import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/weather_service.dart';
import '../domain/models/weather_model.dart';

final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService();
});

final weatherProvider = FutureProvider<WeatherModel?>((ref) async {
  final weatherService = ref.watch(weatherServiceProvider);
  return await weatherService.getCurrentWeather();
});
