import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:spica_weather_flutter/database/database.dart';
import 'package:spica_weather_flutter/model/city_item.dart';
import 'package:spica_weather_flutter/routes/app_pages.dart';
import 'package:spica_weather_flutter/utils/city_utils.dart';
import 'package:spica_weather_flutter/utils/gps_util.dart';

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
    state.update((val) {
      val?.tip = "${val.tip}\n正在加载城市数据";
    });

    int value = await AppDatabase.getInstance().city.count().getSingle();

    if (value != 0) {
      // 有城市数据
      state.update((val) {
        val?.tip = "${val.tip}\n有城市数据";
      });
      await ApiRepository.fetchWeather();
      Get.offAndToNamed(Routes.WEATHER);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // 权限被拒绝，申请定位权限
      state.update((val) {
        val?.tip = "${val.tip}\n尝试申请权限";
      });
      showCupertinoDialog(
          context: Get.context!,
          builder: (context) => CupertinoAlertDialog(
                title: const Text("提示"),
                content: const Text("请开启定位权限以更新最新位置"),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("确定"),
                    onPressed: () async {
                      permission = await Geolocator.requestPermission();
                      Get.back();
                      if (permission == LocationPermission.whileInUse ||
                          permission == LocationPermission.always) {
                        await _loadNearestCity();
                      } else {
                        await _loadDefaultCity();
                      }
                      await Get.offAndToNamed(Routes.WEATHER);
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text("取消"),
                    onPressed: () async {
                      Get.back();
                      await _loadDefaultCity();
                      await Get.offAndToNamed(Routes.WEATHER);
                    },
                  ),
                ],
              ));
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      // 权限被永久拒绝
    }

    if (permission == LocationPermission.denied) {
      // 申请权限被拒绝
      state.update((val) {
        val?.tip = "${val.tip}\n权限被拒绝";
      });
    }
  }

  // 加载最近的城市
  _loadNearestCity() async {
    // 本地没有城市数据 但是有定位权限
    state.update((val) {
      val?.tip = "${val.tip}\n请求定位中..";
    });

    // 获取到当前定位
    Position position = await Geolocator.getCurrentPosition();

    // 转换成火星坐标
    final gc02Loc =
        GpsUtil.gps84_To_Gcj02(position.latitude, position.longitude);

    position = Position(
        longitude: gc02Loc[1].toDouble(),
        latitude: gc02Loc[0].toDouble(),
        timestamp: position.timestamp,
        accuracy: position.accuracy,
        altitude: position.altitude,
        altitudeAccuracy: position.altitudeAccuracy,
        heading: position.heading,
        headingAccuracy: position.headingAccuracy,
        speed: position.speed,
        speedAccuracy: position.speedAccuracy);

    if (kDebugMode) {
      print("当前的位置${position.longitude},${position.latitude}");
    }

    state.update((val) {
      val?.tip =
          "${val.tip}\n请求到当前的定位数据${position.latitude},${position.longitude}";
    });

    // 所有城市
    final cities = await CityUtils.getAllCityItem();

    // 最近的城市
    CityItem nearestCity = cities[0];

    double distance =
        nearestCity.distance(position.latitude, position.longitude);

    // 最近的城市
    for (var item in cities) {
      double temp = item.distance(position.latitude, position.longitude);
      if (temp < distance) {
        if (kDebugMode) {
          print("-----------------------------------");
          print("更近的城市${item.log},${item.lat}");
          print("更近的城市${item.name}距离${temp}米");
        }
        nearestCity = item;
        distance = temp;
      }
    }
    state.update((val) {
      val?.tip = "${val.tip}\n请求到最近的城市${nearestCity.name}";
    });
    // 检查是否插入过
    final count = await (AppDatabase.getInstance().city.count(
        where: (tbl) => tbl.name.equals(nearestCity.name ?? ""))).getSingle();
    if (count == 0) {
      // 进行插入 并且请求接口
      AppDatabase.getInstance().city.insertOne(
          CityCompanion.insert(
              name: nearestCity.name ?? "",
              lat: nearestCity.lat ?? "",
              lon: nearestCity.log ?? "",
              sort: BigInt.from(DateTime.now().millisecondsSinceEpoch.toInt())),
          mode: InsertMode.insertOrReplace);
    }
    state.update((val) {
      val?.tip = "${val.tip}\n请求城市数据中..";
    });
    await ApiRepository.fetchWeather();
    state.update((val) {
      val?.isLoading = false;
      val?.tip = "${val.tip}\n请求成功，进入应用中..";
    });
  }

  // 加载默认城市
  _loadDefaultCity() async {
    AppDatabase.getInstance().city.insertOne(
        CityCompanion.insert(
            name: "南京",
            lat: "32.04",
            lon: "118.78",
            sort: BigInt.from(DateTime.now().millisecondsSinceEpoch.toInt())),
        mode: InsertMode.insertOrReplace);
    state.update((val) {
      val?.tip = "${val.tip}\n请求城市数据中..";
    });
    await ApiRepository.fetchWeather();
    state.update((val) {
      val?.isLoading = false;
      val?.tip = "${val.tip}\n请求成功，进入应用中..";
    });
  }
}
