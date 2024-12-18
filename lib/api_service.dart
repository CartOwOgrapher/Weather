import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class ApiService {
  static const String _baseUrl = "https://api.weatherapi.com/v1";
  static const String _apiKey = "3e023a9c8ce8448b851223416241612";

  static Future<Weather> fetchWeather(String city) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/forecast.json?key=$_apiKey&q=$city&days=3&aqi=no&lang=ru'));

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      print('Decoded response body: $decodedBody');

      final data = json.decode(decodedBody);

      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to load weather data: ${response.reasonPhrase}');
    }
  }
}
