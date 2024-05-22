import 'package:drift/drift.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:spica_weather_flutter/database/database.dart';
import 'package:spica_weather_flutter/routes/app_pages.dart';

import '../../repository/api_repository.dart';
import 'state.dart';

class SplashLogic extends GetxController {
  final state = SplashState().obs;

  @override
  void onReady() async {
    super.onReady();
    await _loadData();
  }

  _loadData() async {
    int value = await AppDatabase.getInstance().city.count().getSingle();

    state.update((val) {
      val?.tip = "${val.tip}\n正在加载城市数据";
    });

    //  载入默认值 如果没有city的情况下
    if (value == 0) {
      AppDatabase.getInstance().city.insertOne(
          CityCompanion.insert(name: "南京", lat: "32.04", lon: "118.78"),
          mode: InsertMode.insertOrReplace);
      state.update((val) {
        val?.tip = "${val.tip}\n请求城市数据中..";
      });
      await ApiRepository.fetchWeather();
    } else {
      await ApiRepository.fetchWeather();
    }
    state.update((val) {
      val?.isLoading = false;
      val?.tip = "${val.tip}\n请求成功，进入应用中..";
    });
    Get.offAndToNamed(Routes.WEATHER);
  }
}
