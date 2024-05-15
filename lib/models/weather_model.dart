

import 'dart:ffi';

class WeatherModel{
  String cityName;
  String icon;
  String condition;
  double temp;
  double wind;
  double humidity;
  String windDirection;
  double gust;
  double uv;
  double pressure;
  double pricipition;
  String lastUpdate;

  WeatherModel({
    required this.cityName,
    required this.icon,
    required this.condition,
    required this.temp,
    required this.wind,
    required this.humidity,
    required this.windDirection,
    required this.gust,
    required this.uv,
    required this.pressure,
    required this.pricipition,
    required this.lastUpdate
});

  factory WeatherModel.fromJson(Map<String,dynamic>json)=> WeatherModel(
      cityName : json['location']['name'],
    icon : json['current']['condition']['icon'],
    condition : json['current']['condition']['text'],
    temp : double.parse(json['current']['temp_c'].toString()),
    wind : double.parse(json['current']['wind_kph'].toString()),
    humidity : double.parse(json['current']['humidity'].toString()),
    windDirection : json['current']['wind_dir'],
    gust : double.parse(json['current']['gust_kph'].toString()),
    uv : double.parse(json['current']['uv'].toString()),
    pressure : double.parse(json['current']['pressure_mb'].toString()),
    pricipition : double.parse(json['current']['precip_mm'].toString()),
    lastUpdate : json['current']['last_updated'],
  );

}