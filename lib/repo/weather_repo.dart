
import 'dart:convert';
import 'dart:developer';
import 'package:demobloc/const/url_const.dart';
import 'package:demobloc/model/model.dart';
import 'package:http/http.dart'as http;

class WeatherRepository {
  static Future<WeatherData> fetchWeatherData(String city) async {
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=${UrlConst.apiKey}'));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        WeatherData weatherData = WeatherData.fromJson(jsonData);
        return weatherData;
      } else {
        log('Failed to fetch weather data. Status code: ${response.statusCode}');
        return WeatherData(); // Return an empty WeatherData or handle error case
      }
    } catch (e) {
      log('Error fetching weather data: $e');
      return WeatherData(); // Return an empty WeatherData or handle error case
    } finally {
      client.close();
    }
  }

}

