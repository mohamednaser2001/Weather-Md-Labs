
import 'package:weather_app/models/weather_model.dart';

abstract class WeatherStates{}
class WeatherInitStateStates extends WeatherStates{}
class GetWeatherLoadingState extends WeatherStates{}
class GetWeatherSuccessState extends WeatherStates{
  WeatherModel weatherData;
  GetWeatherSuccessState(this.weatherData);
}
class GetWeatherErrorState extends WeatherStates{
  String errorMessage;
  GetWeatherErrorState(this.errorMessage);
}