import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:spica_weather_flutter/database/database.dart';
import 'package:spica_weather_flutter/model/city_item.dart';
import 'package:spica_weather_flutter/repository/api_repository.dart';
import 'package:spica_weather_flutter/utils/city_utils.dart';

class CitySelectorLogic extends GetxController {
  final _allCityList = <CityItem>[];

  String _searchQuery = '';

  final showItems = <CityItem>[].obs;

  final isLoadingState = false.obs;

  Timer? timer;

  @override
  void onReady() async {
    super.onReady();
    isLoadingState(true);
    try {
      final cities = await CityUtils.getAllCityItem();
      if (isClosed) return;
      _allCityList.addAll(cities);
      _filterCities();
    } finally {
      if (!isClosed) isLoadingState(false);
    }
  }

  /// 对缓存的城市列表筛选，保留 300ms 防抖。
  void onSearch(String value) {
    if (isClosed) return;
    _searchQuery = value.trim();
    timer?.cancel();
    if (_searchQuery.isEmpty) {
      _filterCities();
      return;
    }
    timer = Timer(const Duration(milliseconds: 300), _filterCities);
  }

  void _filterCities() {
    if (isClosed) return;
    showItems.assignAll(
      _searchQuery.isEmpty
          ? _allCityList
          : _allCityList.where(
              (city) => city.name?.contains(_searchQuery) ?? false,
            ),
    );
  }

  /// 选择城市
  Future<void> onSelectItem(CityItem showItem) async {
    await EasyLoading.show(status: 'loading...');
    try {
      await AppDatabase.getInstance().city.insertOne(
        CityCompanion.insert(
          name: showItem.name ?? "/",
          lat: showItem.lat ?? "",
          isLocation: false,
          sort: BigInt.from(DateTime.now().millisecondsSinceEpoch.toInt()),
          lon: showItem.log ?? '',
        ),
        mode: InsertMode.insertOrIgnore,
      );
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
