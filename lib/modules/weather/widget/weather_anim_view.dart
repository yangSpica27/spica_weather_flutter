import 'package:flutter/material.dart';
import 'package:spica_weather_flutter/base/weather_type.dart';
import 'package:spica_weather_flutter/modules/weather/widget/weather_anim_widget/cloudy_view.dart';
import 'package:spica_weather_flutter/modules/weather/widget/weather_anim_widget/fog_view.dart';
import 'package:spica_weather_flutter/modules/weather/widget/weather_anim_widget/rain_view.dart';
import 'package:spica_weather_flutter/modules/weather/widget/weather_anim_widget/sandstorm_view.dart';
import 'package:spica_weather_flutter/modules/weather/widget/weather_anim_widget/snow_view.dart';
import 'package:spica_weather_flutter/modules/weather/widget/weather_anim_widget/sunny_view.dart';

/// 天气动画背景
class WeatherAnimView extends StatelessWidget {
  final WeatherAnimType _weatherAnimType;

  const WeatherAnimView(this._weatherAnimType,
      {super.key, this.width = 0, this.height = 0});

  final double width;

  final double height;

  @override
  Widget build(BuildContext context) {
    // return _SandstormView(width: width, height: height);
    switch (_weatherAnimType) {
      case WeatherAnimType.SUNNY:
        return SunnyView(width, height);
      case WeatherAnimType.RAIN:
        return RainView(width: width, height: height);
      case WeatherAnimType.SNOW:
        return SnowView(width: width, height: height);
      case WeatherAnimType.HAZE:
      case WeatherAnimType.FOG:
        return FogView(width: width, height: height);
      case WeatherAnimType.CLOUDY:
        return CloudyView(width: width, height: height);
      case WeatherAnimType.SANDSTORM:
        return SandstormView(width: width, height: height);
      default:
        return Container();
    }
  }
}
