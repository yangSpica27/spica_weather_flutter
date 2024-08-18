import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spica_weather_flutter/base/weather_type.dart';
import 'package:spica_weather_flutter/generated/assets.dart';
import 'package:spica_weather_flutter/model/weather_response.dart';
import 'package:spica_weather_flutter/modules/weather/widget/weather_anim_view.dart';

/// 当前天气卡片
class NowCard extends StatelessWidget {
  final WeatherResult weather;

  const NowCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          weather.todayWeather?.iconId?.getWeatherColor() ?? Colors.blue[500],
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 310.w,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.w),
                  topRight: Radius.circular(8.w)),
              child: WeatherAnimView(
                  weather.todayWeather?.iconId
                          ?.getWeatherType()
                          .getWeatherAnimType() ??
                      WeatherAnimType.UNKNOWN,
                  width: ScreenUtil().screenWidth - 32.w,
                  height: 310.w),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _tempWidget(),
                SizedBox(height: 12.w),
                _descWidget(),
                SizedBox(height: 22.w),
                _bottomBar()
              ],
            ),
          )
        ],
      ),
    );
  }

  // 左边文本区
  _tempWidget() => RichText(
          text: TextSpan(children: [
        TextSpan(
            text: "${weather.todayWeather?.temp ?? 0}",
            style: TextStyle(
                fontSize: 100.sp,
                color: Colors.white.withOpacity(.9),
                fontWeight: FontWeight.w500)),
        TextSpan(
            text: "℃",
            style: TextStyle(
                fontSize: 50.sp,
                color: Colors.white.withOpacity(.89),
                fontWeight: FontWeight.w400)),
      ]));

  _descWidget() => RichText(
          text: TextSpan(children: [
        TextSpan(
            text: ' ',
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
        TextSpan(
            text: weather.todayWeather?.weatherName ?? '',
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
        TextSpan(
            text: " ",
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400)),
        TextSpan(
            text: "体感：",
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400)),
        TextSpan(
            text: "${weather.todayWeather?.feelTemp ?? 0}",
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
        TextSpan(
            text: "℃",
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400)),
        TextSpan(
            text: " ",
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
        TextSpan(
            text: "空气质量：",
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400)),
        TextSpan(
            text: weather.air?.category ?? '--',
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500))
      ]));

  // 底栏
  _bottomBar() => Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
            color: const Color(0x1f4a4a4a),
            borderRadius: BorderRadius.circular(10.w)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                        child: Image.asset(
                      Assets.assetsIcWater,
                      width: 16.w,
                      height: 16.w,
                      color: Colors.white,
                    )),
                    WidgetSpan(
                        child: SizedBox(
                      width: 4.w,
                    )),
                    TextSpan(
                        text: "${weather.todayWeather?.water ?? ''}%",
                        style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                  ])),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: RichText(
                  text: TextSpan(children: [
                WidgetSpan(
                    child: Image.asset(
                  Assets.assetsIcWindmill,
                  width: 16.w,
                  height: 16.w,
                  color: Colors.white,
                )),
                WidgetSpan(
                    child: SizedBox(
                  width: 4.w,
                )),
                TextSpan(
                    text: "${weather.todayWeather?.windSpeed ?? ''}km/h",
                    style: TextStyle(fontSize: 14.sp, color: Colors.white)),
              ])),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: RichText(
                  text: TextSpan(children: [
                WidgetSpan(
                    child: Image.asset(
                  Assets.assetsIcDashboard,
                  width: 16.w,
                  height: 16.w,
                  color: Colors.white,
                )),
                WidgetSpan(
                    child: SizedBox(
                  width: 4.w,
                )),
                TextSpan(
                    text: "${weather.todayWeather?.windPa ?? ''}hpa",
                    style: TextStyle(fontSize: 14.sp, color: Colors.white)),
              ])),
            ),
          ],
        ),
      );
}
