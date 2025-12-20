class WeatherModel {
  final String location;
  final double temperature;
  final String description;
  final String icon;
  final double humidity;
  final double windSpeed;
  final int visibility;
  final double feelsLike;
  final DateTime lastUpdated;

  WeatherModel({
    required this.location,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
    required this.feelsLike,
    required this.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String location) {
    final main = json['main'] as Map<String, dynamic>;
    final weather = (json['weather'] as List).first as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>?;

    return WeatherModel(
      location: location,
      temperature: (main['temp'] as num).toDouble(),
      description: weather['description'] as String,
      icon: weather['icon'] as String,
      humidity: (main['humidity'] as num).toDouble(),
      windSpeed: (wind?['speed'] as num?)?.toDouble() ?? 0.0,
      visibility: (json['visibility'] as num?)?.toInt() ?? 0,
      feelsLike: (main['feels_like'] as num).toDouble(),
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'temperature': temperature,
      'description': description,
      'icon': icon,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'visibility': visibility,
      'feelsLike': feelsLike,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
