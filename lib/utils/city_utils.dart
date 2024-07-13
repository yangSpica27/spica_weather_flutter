import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:spica_weather_flutter/generated/assets.dart';
import 'package:spica_weather_flutter/model/city_item.dart';
import 'package:spica_weather_flutter/network/api_provider.dart';

class CityUtils {
  // 获取所有城市
  static Future<List<CityItem>> getAllCityItem() async {
    final cityItems = <CityItem>[];
    try {
      String data = await rootBundle.loadString(Assets.assetsCity);
      final items = await compute((data) {
        final items = <CityItem>[];
        List jsonResult = (json.decode(data));
        for (var element in jsonResult) {
          final province = Province.fromJson(element);
          items.add(CityItem(
              name: province.name,
              log: province.log,
              lat: province.lat,
              weather: null));
          items.addAll(province.children ?? []);
        }
        return items;
      }, data);
      cityItems.addAll(items);
    } catch (err) {
      if (kDebugMode) {
        print("解析城市json出错$err");
      }
    }
    return cityItems;
  }

  // 获取当前城市
  static Future<CityItem> getCurrentCityItem(String lnglat) async {
    ApiProvider apiProvider = ApiProvider();
    final result = await apiProvider.fetchCity(lnglat);

    if (result.data == null) {
      throw Exception("获取城市信息失败");
    } else if (result.data["status"] != "1") {
      throw Exception("获取城市信息失败");
    }
    String city = result.data["regeocode"]["addressComponent"]["city"];
    if (city == "") {
      throw Exception("获取城市信息失败");
    }
    final strs = lnglat.split(",");
    return CityItem(name: city, log: strs[0], lat: strs[1], weather: null);
  }
}
