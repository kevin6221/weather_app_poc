import 'package:cloud_firestore/cloud_firestore.dart';

class WeatherData {
  final String? cityName;
  final double? temperature;
  final int? humidity;
  final Timestamp? timestamp; // Firestore timestamp

  WeatherData({
    this.cityName,
    this.temperature,
    this.humidity,
    this.timestamp,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'],
      timestamp: null, // Initially set to null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'humidity': humidity,
      'timestamp': timestamp, // Include timestamp in the map
    };
  }
}
