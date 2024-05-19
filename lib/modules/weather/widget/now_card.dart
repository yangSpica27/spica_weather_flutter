import 'package:flutter/cupertino.dart';
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
            child: WeatherAnimView(weather.todayWeather?.iconId
                    ?.getWeatherType()
                    .getWeatherAnimType() ??
                WeatherAnimType.UNKNOWN,width: ScreenUtil().screenWidth - 32.w,height: 310.w),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 20.w, right: 20.w, bottom: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _leftTextColumn()),
                    // Center(
                    //   child: _rightIcon(),
                    // )
                  ],
                ),
                _bottomBar()
              ],
            ),
          )
        ],
      ),
    );
  }

  // 左边文本区
  _leftTextColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${weather.todayWeather?.temp ?? 0}℃",
              style: TextStyle(
                  fontSize: 44.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(weather.todayWeather?.weatherName ?? '',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              Text(",", style: TextStyle(fontSize: 20.sp, color: Colors.white)),
              Text("体感温度${weather.todayWeather?.feelTemp ?? 0}℃",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white)),
            ],
          ),
          Text("空气质量:${weather.air?.category}",
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(
            height: 12.w,
          ),
        ],
      );

  // 右边图标
  _rightIcon() => Image.asset(
        weather.todayWeather?.iconId?.getWeatherType().getIconAssetString() ??
            Assets.assetsIcCloud,
        width: 60.w,
        height: 60.w,
      );

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
                  Text("湿度:${weather.todayWeather?.water ?? 0}%",
                      style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("风速:${weather.todayWeather?.windSpeed ?? ''}km/h",
                      style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("气压:${weather.todayWeather?.windPa ?? ''}pa",
                      style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      );
}
