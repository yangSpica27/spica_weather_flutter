import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:spica_weather_flutter/database/database.dart';
import 'package:workmanager/workmanager.dart';

import 'base/theme.dart';
import 'repository/api_repository.dart';
import 'routes/app_pages.dart';

// 佛祖保佑，永无BUG
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Workmanager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  // 定时一小时的同步任务
  Workmanager().registerPeriodicTask(
    "task_1",
    "sync_weather_api_task",
    frequency: const Duration(hours: 1),
    initialDelay: const Duration(seconds: 20),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    // 网络联通&&电量充足时候进行数据同步
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: true,
    ),
  );
  runApp(const MyApp());
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "sync_weather_api_task") {
      // 网络请求同步
      await ApiRepository.fetchWeather();
    }
    return true;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SPICaWeather',
          onInit: () {
            AppDatabase.getInstance();
            EasyRefresh.defaultHeaderBuilder = () => const MaterialHeader();
            EasyRefresh.defaultFooterBuilder = () => const MaterialFooter();
          },
          onDispose: () {
            AppDatabase.getInstance().close();
          },
          builder: EasyLoading.init(),
          theme: const MaterialTheme(TextTheme()).light(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
