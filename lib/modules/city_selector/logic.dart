import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:spica_weather_flutter/database/database.dart';
import 'package:spica_weather_flutter/model/city_item.dart';
import 'package:spica_weather_flutter/repository/api_repository.dart';
import 'package:spica_weather_flutter/utils/city_utils.dart';

class CitySelectorLogic extends GetxController {
  final _allCityList = <CityItem>[];

  final showItems = <CityItem>[].obs;

  final isLoadingState = false.obs;

  Timer? timer;

  @override
  void onReady() async {
    super.onReady();
    isLoadingState(true);
    _allCityList.addAll(await CityUtils.getAllCityItem());
    showItems.assignAll(_allCityList);
    isLoadingState(false);
  }

  /// 搜索城市
  void onSearch(String value) async {
    isLoadingState(true);
    if (value.isEmpty) {
      showItems.assignAll(_allCityList);
      isLoadingState(false);
      return;
    }
    final list = await compute((message) {
      List<CityItem> list = [];
      for (CityItem item in message) {
        if (item.name!.contains(value.trim())) {
          list.add(item);
        }
      }
      return list;
    }, _allCityList);
    showItems.assignAll(list);
    isLoadingState(false);
  }

  /// 选择城市
  onSelectItem(CityItem showItem) async {
    await EasyLoading.show(status: 'loading...');
    try {
      await AppDatabase.getInstance().city.insertOne(
          CityCompanion.insert(
              name: showItem.name ?? "/",
              lat: showItem.lat ?? "",
              isLocation: false,
              sort: BigInt.from(DateTime.now().millisecondsSinceEpoch.toInt()),
              lon: showItem.log ?? ''),
          mode: InsertMode.insertOrIgnore);
      await ApiRepository.fetchWeather();
    } catch (e) {
      await EasyLoading.showError(e.toString());
    }
    await EasyLoading.dismiss();
    Get.back();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
