import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spica_weather_flutter/generated/assets.dart';
import 'package:spica_weather_flutter/widget/enter_page_anim_widget.dart';

import 'logic.dart';

/// 闪屏页
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final logic = Get.find<SplashLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20.w),
            Expanded(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(Assets.assetsIcApp, width: 150.w),
                  SizedBox(height: 20.w),
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: "柠檬天气"
                          .split("")
                          .asMap()
                          .entries
                          .map((e) => EnterPageAnimWidget(
                              startOpacity: 0,
                              startOffset: Offset(0, .5 - .1 * e.key),
                              delay: Duration(milliseconds: 100 * e.key),
                              child: Text(
                                e.value,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500),
                              )))
                          .toList()
                  )
                ],
              ),
            )),
            Obx(() => Text(logic.state.value.tip,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]))),
            SizedBox(height: 20.w),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<SplashLogic>();
    super.dispose();
  }
}
