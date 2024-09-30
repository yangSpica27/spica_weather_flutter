import 'package:background_fetch/background_fetch.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:spica_weather_flutter/database/database.dart';
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

  // 初始化自动更新天气任务
  _initScheduleTask() async {
    // Step 1:  Configure BackgroundFetch as usual.
    await BackgroundFetch.configure(
        BackgroundFetchConfig(minimumFetchInterval: 60), (String taskId) async {
      // <-- Event callback.
      try {
        EasyLoading.show(status: "更新天气信息...");
        await ApiRepository.fetchWeather();
        // EasyLoading.dismiss(animation: true);
        if (kDebugMode) {
          print("后台任务请求成功");
        }
      } catch (e) {
        if (kDebugMode) {
          print("后台任务请求失败$e");
        }
      }
      EasyLoading.dismiss(animation: true);
      // Finish, providing received taskId.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Event timeout callback

      BackgroundFetch.finish(taskId);
    });

    BackgroundFetch.scheduleTask(TaskConfig(
      taskId: "auto_update_weather",
      delay: 5000,
      periodic: true,
      requiredNetworkType: NetworkType.ANY,
    ));
  }

  _loadData() async {
    state.update((val) {
      val?.updateTipString("正在加载城市数据");
    });

    final currentCity = await (AppDatabase.getInstance().city.select()
          ..where((tbl) => tbl.isLocation.equals(true)))
        .getSingleOrNull();

    if (currentCity != null) {
      state.update((val) {
        val?.updateTipString("正在初始化自动化任务..");
      });
      await _fetchWeatherInfo();
      await Get.offAndToNamed(Routes.WEATHER);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // 权限被拒绝，申请定位权限
      state.update((val) {
        val?.updateTipString("尝试申请权限");
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
                        await _loadNearestCity(currentCity);
                      } else {
                        if (currentCity == null) {
                          await _loadDefaultCity();
                        }
                      }
                      await _fetchWeatherInfo();
                      await Get.offAndToNamed(Routes.WEATHER);
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text("取消"),
                    onPressed: () async {
                      Get.back();
                      if (currentCity == null) {
                        await _loadDefaultCity();
                      }
                      await _fetchWeatherInfo();
                      await Get.offAndToNamed(Routes.WEATHER);
                    },
                  ),
                ],
              ));
      return;
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      await _loadNearestCity(currentCity);
    }

    if (permission == LocationPermission.deniedForever) {
      // 权限被永久拒绝
      state.update((val) {
        val?.updateTipString("权限被拒绝");
      });
      if (currentCity != null) {
        await _loadDefaultCity();
      }
    }

    if (permission == LocationPermission.denied) {
      // 申请权限被拒绝
      state.update((val) {
        val?.updateTipString("权限被拒绝");
      });
      if (currentCity != null) {
        await _loadDefaultCity();
      }
    }
    await _fetchWeatherInfo();
    await Get.offAndToNamed(Routes.WEATHER);
  }

  // 加载最近的城市
  _loadNearestCity(CityData? currentCity) async {
    // 本地没有城市数据 但是有定位权限

    try {
      state.update((val) {
        val?.updateTipString("正在获取定位,请稍后..");
      });

      // 获取到当前定位
      Position position = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 5));

      state.update((val) {
        val?.updateTipString("获取定位成功");
      });

      // 转换成火星坐标
      final gc02Loc =
          GpsUtil.gps84ToGcj02(position.latitude, position.longitude);

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
        val?.updateTipString(
            "请求到当前的定位数据${position.latitude},${position.longitude}");
      });

      final city = await CityUtils.getCurrentCityItem(
          "${position.longitude},${position.latitude}");

      if (currentCity == null || city.name != currentCity.name) {
        state.update((val) {
          val?.updateTipString("地理逆编码获取当前位置所在城市");
        });
        // 删除过期的所在城市
        await AppDatabase.getInstance()
            .city
            .deleteWhere((tbl) => tbl.isLocation.equals(true));
        // 插入新的所在城市
        AppDatabase.getInstance().city.insertOne(
            CityCompanion.insert(
                name: city.name ?? "",
                lat: city.lat ?? "",
                lon: city.log ?? "",
                isLocation: true,
                sort: BigInt.from(0)),
            mode: InsertMode.insertOrReplace);
        currentCity = await (AppDatabase.getInstance().city.select()
              ..where((tbl) => tbl.isLocation.equals(true)))
            .getSingleOrNull();
      } else {
        state.update((val) {
          val?.updateTipString("城市没有变化...");
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("获取最近城市信息失败：$e");
      }
    }

    if (currentCity == null) {
      await _loadDefaultCity();
    }
  }

  // 加载默认城市
  _loadDefaultCity() async {
    state.update((val) {
      val?.updateTipString("获取定位数据失败");
      val?.updateTipString("载入默认带入城市");
    });
    AppDatabase.getInstance().city.insertOne(
        CityCompanion.insert(
            name: "南京",
            lat: "32.04",
            isLocation: true,
            lon: "118.78",
            sort: BigInt.from(DateTime.now().millisecondsSinceEpoch.toInt())),
        mode: InsertMode.insertOrReplace);
    state.update((val) {
      val?.updateTipString("请求城市数据中..");
    });
  }

  _fetchWeatherInfo() async {
    try {
      state.update((val) {
        val?.updateTipString("请求天气接口");
      });
      await ApiRepository.fetchWeather();
    } catch (e) {
      state.update((val) {
        val?.updateTipString("请求失败");
      });
      await Get.offAndToNamed(Routes.WEATHER);
      return;
    }
    state.update((val) {
      val?.isLoading = false;
      val?.updateTipString("请求成功，进入应用中..");
    });
    await _initScheduleTask();
  }
}
