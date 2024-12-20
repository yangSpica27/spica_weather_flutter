
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:spica_weather_flutter/database/database.dart';

import 'base/theme.dart';
import 'routes/app_pages.dart';

// 佛祖保佑，永无BUG
void main() {
  runApp(const MyApp());
}

// 应用入口
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
            // 初始化数据库
            AppDatabase.getInstance();
            // 初始化EasyRefresh
            EasyRefresh.defaultHeaderBuilder = () => const MaterialHeader();
            EasyRefresh.defaultFooterBuilder = () => const MaterialFooter();
          },
          onDispose: () {
            // 关闭数据库
            AppDatabase.getInstance().close();
          },
          builder: EasyLoading.init(),
          // 主题
          theme: const MaterialTheme(TextTheme()).light().copyWith(
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: Colors.white,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
            ),
          ),
          // 暗黑模式
          darkTheme: const MaterialTheme(TextTheme()).dark().copyWith(
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarColor: Colors.black,
                systemNavigationBarIconBrightness: Brightness.light,
              ),
            ),
          ),
          // 入口
          initialRoute: AppPages.INITIAL,
          // 路由
          getPages: AppPages.routes,
        );
      },
    );
  }
}
