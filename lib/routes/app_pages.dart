import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:spica_weather_flutter/modules/city_list/binding.dart';
import 'package:spica_weather_flutter/modules/city_list/view.dart';
import 'package:spica_weather_flutter/modules/city_selector/binding.dart';
import 'package:spica_weather_flutter/modules/city_selector/view.dart';
import 'package:spica_weather_flutter/modules/splash/binding.dart';
import 'package:spica_weather_flutter/modules/splash/view.dart';
import 'package:spica_weather_flutter/modules/weather/binding.dart';
import 'package:spica_weather_flutter/modules/weather/view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;



  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.WEATHER,
      page: () => const WeatherPage(),
      binding: WeatherBinding(),
    ),
    GetPage(
      name: _Paths.CITY_SELECTOR,
      page: () => const CitySelectorPage(),
      binding: CitySelectorBinding(),
    ),
    GetPage(
      name: _Paths.CITY_LIST,
      page: () => const CityListPage(),
      binding: CityListBinding(),
    ),
  ];
}
