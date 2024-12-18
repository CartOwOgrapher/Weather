class Weather {
  final String cityName;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final double pressure;
  final String condition;
  final String conditionIconUrl;
  final List<Forecast> forecast;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.condition,
    required this.conditionIconUrl,
    required this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final forecastDays = json['forecast']?['forecastday'] ?? [];

    return Weather(
      cityName: json['location']?['name'] ?? 'Unknown',
      temperature: current?['temp_c']?.toDouble() ?? 0.0,
      humidity: current?['humidity'] ?? 0,
      windSpeed: current?['wind_kph']?.toDouble() ?? 0.0 / 3.6,
      pressure: current?['pressure_mb']?.toDouble() ?? 0.0,
      condition: current?['condition']?['text'] ?? 'Unknown',
      conditionIconUrl: _getIconUrl(current?['condition']?['icon']),
      forecast:
          (forecastDays as List).map((day) => Forecast.fromJson(day)).toList(),
    );
  }

  static String _getIconUrl(String? iconPath) {
    if (iconPath == null) return '';
    return 'https:$iconPath';
  }
}

class Forecast {
  final String date;
  final double dayTemp;
  final double nightTemp;
  final String dayCondition;
  final String dayConditionIconUrl;
  Forecast({
    required this.date,
    required this.dayTemp,
    required this.nightTemp,
    required this.dayCondition,
    required this.dayConditionIconUrl,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: json['date'] ?? 'Unknown',
      dayTemp: json['day']?['avgtemp_c']?.toDouble() ?? 0.0,
      nightTemp: json['day']?['mintemp_c']?.toDouble() ?? 0.0,
      dayCondition: json['day']?['condition']?['text'] ?? 'Unknown',
      dayConditionIconUrl: _getIconUrl(json['day']?['condition']?['icon']),
    );
  }

  static String _getIconUrl(String? iconPath) {
    if (iconPath == null) return '';
    return 'https:$iconPath';
  }
}
