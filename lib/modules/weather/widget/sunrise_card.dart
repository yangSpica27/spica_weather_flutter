import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spica_weather_flutter/model/weather_response.dart';
import 'package:spica_weather_flutter/base/weather_type.dart';

class SunriseCard extends StatelessWidget {
  final WeatherResult weather;

  const SunriseCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "日出日落",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: weather.todayWeather?.iconId?.getWeatherColor() ??
                    Colors.blue[500]),
          ),
          SizedBox(
            height: 12.w,
          ),
          Text(weather.descriptionForToday ?? ""),
          SizedBox(
            height: 12.w,
          ),
          Placeholder(
            fallbackHeight: 150.w,
            child: const Center(
              child: Text("日出日落View"),
            ),
          )
        ],
      ),
    ));
  }
}
