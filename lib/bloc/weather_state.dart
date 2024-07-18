import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../model/model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherData weather;

  const WeatherLoaded(this.weather);

  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;
  final VoidCallback onOkPressed; // Callback function

  const WeatherError(this.message, {required this.onOkPressed});

  @override
  List<Object> get props => [message];

  void okPressed() {
    onOkPressed(); // Invoke the callback function
  }
}
