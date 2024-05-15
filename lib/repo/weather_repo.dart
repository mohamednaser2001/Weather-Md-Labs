

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:weather_app/models/error_model.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherRepo{
  String baseUrl= 'http://api.weatherapi.com/v1/current.json';
  String apiKey2= 'eef6df18f187401fb2a203542241305';


  Future<Either<WeatherModel, ErrorModel>> getData(String cityName)async{
    try{
      var getUri = Uri.parse(
          '$baseUrl?key=$apiKey2&q=$cityName');

      var response = await http.get(getUri);
      var body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return left(WeatherModel.fromJson(body));
      } else {
        return right(ErrorModel.fromJson(body));
      }
    }catch(e){
      throw Exception('Error, please try again');
    }
  }
}