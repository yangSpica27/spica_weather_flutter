import 'package:drift/drift.dart';
import 'package:get/get.dart';
import 'package:spica_weather_flutter/database/database.dart';
import 'package:spica_weather_flutter/repository/api_repository.dart';

class WeatherLogic extends GetxController {
  final data = <CityData>[].obs;

  final pageIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
    data.bindStream((AppDatabase.getInstance().city.select()
          ..orderBy([(t) => OrderingTerm(expression: t.sort)]))
        .watch());
  }





  loadData() {
    ApiRepository.fetchWeather();
  }
}
