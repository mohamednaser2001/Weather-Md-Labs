import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/logic/weather_cubit.dart';
import 'package:weather_app/logic/weather_states.dart';
import '../repo/weather_repo.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // var client = WeatherData();

  // bool loadWhileGetData = false;
  TextEditingController searchController = TextEditingController();

  // WeatherModel? data;

  // = WeatherModel(
  //   cityName: 'banha',
  // condition: '0',
  //   icon: '1',
  //   temp: '2',
  //   wind: '3',
  //   humidity: '4',
  //   windDirection: '5',
  //   gust: '6',
  //   uv: '7',
  //   pressure: '8',
  //   pricipition: '9',
  //   lastUpdate: '10'
  // );

  // info() async {
  //   // var position = await GetPosition();
  //   // data = await client.getData(position.latitude,position.longitude);
  //
  //   data = await WeatherRepo().getData('banha');
  //   return data;
  // }
  //
  // Future<void> getWeather(String city) async {
  //   try {
  //     setState(() {
  //       loadWhileGetData = true;
  //     });
  //     WeatherRepo weatherService = WeatherRepo();
  //     data= await weatherService.getData(city);
  //
  //     setState(() {
  //       loadWhileGetData = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       loadWhileGetData = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (_) {
        WeatherRepo weatherRepo = WeatherRepo();
        return WeatherCubit(weatherRepo);
      },
      child: Scaffold(
          backgroundColor: const Color(0xff081b25),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ListView(
                children: [
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            hintText: 'Search by city name ...',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400),
                            fillColor: Colors.black,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 16.w),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.r)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.r)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.r)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      BlocBuilder<WeatherCubit, WeatherStates>(
                          builder: (context, state) {
                        return GestureDetector(
                          onTap: () async {
                            if (searchController.text.trim().isNotEmpty) {
                              await context
                                  .read<WeatherCubit>()
                                  .getWeather(searchController.text.trim());
                            }
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 20.r,
                              child: const Icon(
                                Icons.search_rounded,
                                color: Colors.black,
                              )),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  BlocConsumer<WeatherCubit, WeatherStates>(
                      listener: (context, state) {
                    if (state is GetWeatherErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                          content: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: Colors.red),
                              child: Text(
                                state.errorMessage,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )));
                    }
                  }, builder: (context, state) {
                    if (state is GetWeatherLoadingState) {
                      return Padding(
                        padding: EdgeInsets.only(top: 250.0.h),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (context.read<WeatherCubit>().weatherData !=
                        null) {
                      return Column(
                        children: [
                          Container(
                            width: size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 16.h),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(40.0),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff955cd1),
                                    Color(0xff3fa2fa),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  stops: [0.2, 0.85],
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  context
                                      .read<WeatherCubit>()
                                      .weatherData!
                                      .cityName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 26.0,
                                    color: Colors.white.withOpacity(0.75),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  context
                                      .read<WeatherCubit>()
                                      .weatherData!
                                      .lastUpdate,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    height: 0,
                                    color: Colors.white.withOpacity(0.55),
                                  ),
                                ),
                                Image(
                                  image: NetworkImage(
                                      'https:${context.read<WeatherCubit>().weatherData!.icon}'),
                                  width: size.width * 0.5,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  context
                                      .read<WeatherCubit>()
                                      .weatherData!
                                      .condition,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0.sp,
                                    color: Colors.white.withOpacity(0.75),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${context.read<WeatherCubit>().weatherData!.temp}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 36.0.sp,
                                        color: Colors.white.withOpacity(
                                          0.90,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'o',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0.sp,
                                        color: Colors.white.withOpacity(
                                          0.90,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  children: [
                                    InfoWidget(
                                        iconPath: 'assets/images/wind.png',
                                        value:
                                            '${context.read<WeatherCubit>().weatherData!.wind} km/h',
                                        title: 'Wind'),
                                    InfoWidget(
                                        iconPath: 'assets/images/cloud.png',
                                        value:
                                            '${context.read<WeatherCubit>().weatherData!.humidity}',
                                        title: 'Humidity'),
                                    InfoWidget(
                                        iconPath: 'assets/images/wind_dir.png',
                                        value:
                                            '${context.read<WeatherCubit>().weatherData!.windDirection}',
                                        title: 'Wind Direction'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    InfoColumn(
                                        title: 'Gust',
                                        value:
                                            '${context.read<WeatherCubit>().weatherData!.gust} kp/h'),
                                    SizedBox(
                                      height: 20.0.h,
                                    ),
                                    InfoColumn(
                                        title: 'Pressure',
                                        value:
                                            '${context.read<WeatherCubit>().weatherData!.pressure} hpa'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    InfoColumn(
                                        title: 'UV',
                                        value:
                                            '${context.read<WeatherCubit>().weatherData!.uv}'),
                                    SizedBox(
                                      height: 20.0.h,
                                    ),
                                    InfoColumn(
                                        title: 'Precipitation',
                                        value:
                                            '${context.read<WeatherCubit>().weatherData!.pricipition} mm'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(top: 250.0.h),
                        child: Text(
                          'Search by city name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0.sp,
                            height: 0,
                            color: Colors.white.withOpacity(0.55),
                          ),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          )),
    );
  }
}

class InfoWidget extends StatelessWidget {
  const InfoWidget(
      {super.key,
      required this.iconPath,
      required this.value,
      required this.title});

  final String iconPath;
  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Image(
            image: AssetImage(iconPath),
            width: 26.0.w,
            height: 26.0.w,
          ),
          SizedBox(
            height: 8.0.h,
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.0.sp,
              color: Colors.white.withOpacity(0.57),
            ),
          ),
          SizedBox(
            height: 8.0.h,
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11.0.sp,
              color: Colors.white.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoColumn extends StatelessWidget {
  const InfoColumn(
      {super.key, required this.title, required this.value, this.valueColor});

  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15.0.sp,
            color: Colors.white30,
          ),
        ),
        // SizedBox(height: 10.0.h,),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.0.sp,
            color: valueColor ?? Colors.white.withOpacity(0.65),
          ),
        )
      ],
    );
  }
}
