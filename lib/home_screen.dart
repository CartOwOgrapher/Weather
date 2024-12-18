import 'package:flutter/material.dart';
import 'api_service.dart';
import 'weather_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Weather> _weatherData;
  String selectedCity = 'Москва';

  final List<String> cities = [
    'Москва',
    'Лондон',
    'Нью-Йорк',
    'Париж',
    'Токио',
    'Ханты-Мансийск'
    'Екатеринбург'
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeatherForSelectedCity();
  }

  void _fetchWeatherForSelectedCity() {
    setState(() {
      _weatherData = ApiService.fetchWeather(selectedCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: DropdownButton<String>(
                value: selectedCity,
                items: cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCity = value;
                    });
                    _fetchWeatherForSelectedCity();
                  }
                },
                isExpanded: true,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<Weather>(
                future: _weatherData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final weather = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 4,
                            margin: EdgeInsets.only(bottom: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Город: ${weather.cityName}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Image.network(weather.conditionIconUrl),
                                  SizedBox(height: 10),
                                  Text(
                                    'Температура: ${weather.temperature}°C',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Text(
                                    'Влажность: ${weather.humidity}%',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'Скорость ветра: ${weather.windSpeed.toStringAsFixed(2)} m/s',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'Давление: ${weather.pressure} mb',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'Погода: ${weather.condition}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            'Прогноз на следующие 3 дня:',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          ...weather.forecast.map((forecast) {
                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.only(bottom: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Дата: ${forecast.date}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Дневная температура: ${forecast.dayTemp}°C',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Дневная погода: ${forecast.dayCondition}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                            forecast.dayConditionIconUrl,
                                            width: 40,
                                            height: 40),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                    Text(
                                      'Ночная температура: ${forecast.nightTemp}°C',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  } else {
                    return Center(child: Text('Нет данных'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
