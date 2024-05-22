import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:spica_weather_flutter/database/database.dart';

import 'base/theme.dart';
import 'routes/app_pages.dart';

// 佛祖保佑，永无BUG
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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
