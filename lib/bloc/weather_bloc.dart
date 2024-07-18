import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demobloc/bloc/weather_event.dart';
import 'package:demobloc/bloc/weather_state.dart';
import 'package:demobloc/const/url_const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../model/model.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherFetchEvent>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
      WeatherFetchEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());

    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=${event.city}&APPID=${UrlConst.apiKey}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final weather = WeatherData(
          cityName: data['name'],
          temperature: data['main']['temp'].toDouble(),
          humidity: data['main']['humidity'],
        );

        emit(WeatherLoaded(weather));
        await _firestore.collection('weatherData').add({
          ...weather.toMap(), // Spread existing weather data fields
          'timestamp': FieldValue.serverTimestamp(), // Add server timestamp
        });
      } else {
        emit(WeatherError('Failed to fetch weather', onOkPressed: () {
          emit(WeatherInitial());
        }));
      }
    } catch (error) {
      emit(WeatherError(error.toString(), onOkPressed: () {
        emit(WeatherInitial());
      }));
    }
  }
}
