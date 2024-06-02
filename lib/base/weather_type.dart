// WeatherType enum

import 'dart:ui';

import 'package:spica_weather_flutter/generated/assets.dart';

enum WeatherType {
  WEATHER_SUNNY,
  WEATHER_CLOUDY,
  WEATHER_CLOUD,
  WEATHER_RAINY,
  WEATHER_SNOW,
  WEATHER_SLEET,
  WEATHER_FOG,
  WEATHER_HAZE,
  WEATHER_HAIL,
  WEATHER_THUNDER,
  WEATHER_THUNDERSTORM
}

extension WeatherTypeOnIntExtension on int {
  Color getWeatherColor() {
    switch (getWeatherType()) {
      case WeatherType.WEATHER_SUNNY:
        return const Color(0xFFfdbc4c);
      case WeatherType.WEATHER_CLOUDY:
        return const Color(0xFF4297e7);
      case WeatherType.WEATHER_CLOUD:
        return const Color(0xFF68baff);
      case WeatherType.WEATHER_RAINY:
        return const Color(0xFF4297e7);
      case WeatherType.WEATHER_SNOW:
        return const Color(0xFF4297e7);
      case WeatherType.WEATHER_SLEET:
        return const Color(0xFF00a5d9);
      case WeatherType.WEATHER_FOG:
        return const Color(0xFF757F9A);
      case WeatherType.WEATHER_HAZE:
        return const Color(0xFFE1C899);
      case WeatherType.WEATHER_HAIL:
        return const Color(0xFFE1C899);
      case WeatherType.WEATHER_THUNDER:
        return const Color(0xFF4A4646);
      case WeatherType.WEATHER_THUNDERSTORM:
        return const Color(0xFF3995E9);
    }
  }

  WeatherType getWeatherType() {
    switch (this) {
      case 302:
      case 304:
        return WeatherType.WEATHER_THUNDERSTORM;

      case 100:
        return WeatherType.WEATHER_SUNNY;

      case 101:
      case 151:
      case 153:
      case 103:
        return WeatherType.WEATHER_CLOUDY;

      case 102:
      case 104:
      case 152:
      case 154:
        return WeatherType.WEATHER_CLOUD;

      case 300:
      case 301:
      case 303:
      case 305:
      case 306:
      case 307:
      case 308:
      case 309:
      case 310:
      case 311:
      case 312:
      case 314:
      case 315:
      case 316:
      case 317:
      case 318:
      case 350:
      case 351:
      case 399:
        return WeatherType.WEATHER_RAINY;

      case 400:
      case 401:
      case 402:
      case 403:
      case 408:
      case 409:
      case 410:
        return WeatherType.WEATHER_SNOW;

      case 404:
      case 405:
      case 406:
      case 456:
      case 457:
      case 499:
        return WeatherType.WEATHER_SLEET;

      case 500:
      case 501:
      case 502:
        return WeatherType.WEATHER_FOG;

      case 503:
      case 504:
      case 505:
      case 506:
      case 507:
      case 508:
      case 509:
      case 510:
      case 511:
      case 512:
      case 513:
      case 514:
      case 515:
        return WeatherType.WEATHER_HAZE;

      case 313:
        return WeatherType.WEATHER_HAIL;

      case 0:
        return WeatherType.WEATHER_THUNDER;
    }
    return WeatherType.WEATHER_SUNNY;
  }
}

extension WeatherTypeExtension on WeatherType {
  String getIconAssetString() {
    switch (this) {
      case WeatherType.WEATHER_SUNNY:
        return Assets.assetsIcSun;
      case WeatherType.WEATHER_CLOUDY:
        return Assets.assetsIcCloud;
      case WeatherType.WEATHER_CLOUD:
        return Assets.assetsIcCloud;
      case WeatherType.WEATHER_RAINY:
        return Assets.assetsIcRain;
      case WeatherType.WEATHER_SNOW:
        return Assets.assetsIcSnow;
      case WeatherType.WEATHER_SLEET:
        return Assets.assetsIcRain;
      case WeatherType.WEATHER_FOG:
        return Assets.assetsIcWave;
      case WeatherType.WEATHER_HAZE:
        return Assets.assetsIcWave;
      case WeatherType.WEATHER_HAIL:
        return Assets.assetsIcWave;
      case WeatherType.WEATHER_THUNDER:
        return Assets.assetsIcThunder;
      case WeatherType.WEATHER_THUNDERSTORM:
        return Assets.assetsIcThunder;
    }
  }

  WeatherAnimType getWeatherAnimType() {
    switch (this) {
      case WeatherType.WEATHER_SUNNY:
        return WeatherAnimType.SUNNY;
      case WeatherType.WEATHER_CLOUDY:
        return WeatherAnimType.CLOUDY;
      case WeatherType.WEATHER_CLOUD:
        return WeatherAnimType.CLOUDY;
      case WeatherType.WEATHER_RAINY:
        return WeatherAnimType.RAIN;
      case WeatherType.WEATHER_SNOW:
        return WeatherAnimType.SUNNY;
      case WeatherType.WEATHER_SLEET:
        return WeatherAnimType.RAIN;
      case WeatherType.WEATHER_FOG:
        return WeatherAnimType.FOG;
      case WeatherType.WEATHER_HAZE:
        return WeatherAnimType.HAZE;
      case WeatherType.WEATHER_HAIL:
        return WeatherAnimType.HAZE;
      case WeatherType.WEATHER_THUNDER:
        return WeatherAnimType.RAIN;
      case WeatherType.WEATHER_THUNDERSTORM:
        return WeatherAnimType.RAIN;
    }
  }
}

enum WeatherAnimType {
  SUNNY, // 晴朗
  CLOUDY, // 多云
  RAIN, // 下雨
  SNOW, // 下雪
  FOG, // 雾天
  HAZE, // 霾天
  UNKNOWN, // 无效果
}
