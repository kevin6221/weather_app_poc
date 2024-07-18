import 'package:equatable/equatable.dart';


abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherInitialFetchEvent extends WeatherEvent {}

class WeatherFetchEvent extends WeatherEvent {
  final String city;

  const WeatherFetchEvent(this.city);

  @override
  List<Object> get props => [city];
}
