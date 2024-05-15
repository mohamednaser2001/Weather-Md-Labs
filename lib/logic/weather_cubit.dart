

import 'package:bloc/bloc.dart';
import 'package:weather_app/logic/weather_states.dart';
import 'package:weather_app/models/weather_model.dart';

import '../repo/weather_repo.dart';

class WeatherCubit extends Cubit<WeatherStates>{

  final WeatherRepo _weatherRepo;
  WeatherCubit(this._weatherRepo): super(WeatherInitStateStates());


  WeatherModel? weatherData;
  Future<void> getWeather(String city) async {
    try {
      emit(GetWeatherLoadingState());

      final response= await _weatherRepo.getData(city);

      response.fold(
              (left) {
                weatherData= left;
                emit(GetWeatherSuccessState(left));
              },
              (right) => emit(GetWeatherErrorState(right.message)));
    } catch (e) {
      emit(GetWeatherErrorState(e.toString()));
    }
  }

}