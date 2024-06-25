import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spica_weather_flutter/model/weather_response.dart';

/// 补充信息
class DetailsCardListWidget extends StatelessWidget {
  final WeatherResult weather;

  const DetailsCardListWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.w),
      children: [
        UvCard(
          uv: double.tryParse(weather.dailyWeather?.first.uv ?? "0xFF"),
        ),
        HumidnessCard(
          humidness: weather.todayWeather?.water,
        ),
        FeelCard(
          feelTemp: weather.todayWeather?.feelTemp,
        ),
        SunriseCard(
          sunrise: weather.dailyWeather?.first.sunriseDate,
          sunSet: weather.dailyWeather?.first.sunsetDate,
        )
      ],
    );
  }
}

/// 日出日落
class SunriseCard extends StatelessWidget {
  const SunriseCard({super.key, required this.sunrise, required this.sunSet});

  final String? sunrise;

  final String? sunSet;

  @override
  Widget build(BuildContext context) {
    return ItemWidget(
        title: "日出日落",
        value: "",
        value2: "日出：$sunrise\n日落：$sunSet",
        icon: Icons.contrast_sharp,
        rightWidget: Container());
  }
}

/// 体感信息
class FeelCard extends StatelessWidget {
  const FeelCard({super.key, required this.feelTemp});

  final int? feelTemp;

  String getFeelTempDesc() {
    if (feelTemp == null) return "";
    if (feelTemp! < 0) {
      return "寒冷，注意保暖";
    } else if (feelTemp! < 10) {
      return "冷，注意保暖";
    } else if (feelTemp! < 20) {
      return "凉爽，适合户外活动";
    } else if (feelTemp! < 28) {
      return "舒适，适合户外活动";
    } else if (feelTemp! < 35) {
      return "炎热，注意防暑";
    } else {
      return "酷热，注意防暑";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ItemWidget(
      title: "体感温度",
      value: feelTemp != null ? "$feelTemp℃" : "--",
      rightWidget: Container(),
      icon: Icons.settings_accessibility_outlined,
      value2: getFeelTempDesc(),
    );
  }
}

/// 湿度信息
class HumidnessCard extends StatelessWidget {
  const HumidnessCard({super.key, required this.humidness});

  final int? humidness;

  String getHumidnessLevel() {
    if (humidness == null) return "--";
    if (humidness! < 30) {
      return "干燥，注意补水";
    } else if (humidness! < 60) {
      return "舒适";
    } else {
      return "潮湿,体感温度会更高";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ItemWidget(
        title: "湿度",
        value: humidness != null ? "$humidness%" : "--",
        icon: Icons.grain_outlined,
        value2: getHumidnessLevel(),
        bottomWidget: Padding(
          padding: EdgeInsets.only(bottom: 6.w),
          child: CustomPaint(
            painter: _LinePainter(
                lowerLimit: 0,
                upperLimit: 100,
                currentWater: humidness ?? 0,
                progress: 1),
            size: Size(100.w, 12.w),
          ),
        ),
        rightWidget: Container());
  }
}

/// 紫外线强度信息
class UvCard extends StatelessWidget {
  const UvCard({super.key, required this.uv});

  final double? uv;

  String getUvLevel() {
    if (uv == null) return "--";
    if (uv! < 3) {
      return "弱";
    } else if (uv! < 6) {
      return "中等";
    } else if (uv! < 8) {
      return "强";
    } else if (uv! < 11) {
      return "很强";
    } else {
      return "极强";
    }
  }

  String getUvDetail() {
    if (uv == null) return "--";
    if (uv! < 3) {
      return "不需采取防护措施";
    } else if (uv! < 6) {
      return "对人体影响不大，可不采取防护措施";
    } else if (uv! < 8) {
      return "外出应采取防护措施，要用遮阳伞、遮阳衣帽、太阳镜等，涂擦防晒霜等";
    } else if (uv! < 11) {
      return "外出应特别注意防护，中午前后宜减少外出";
    } else {
      return "--";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ItemWidget(
      title: "紫外线",
      icon: Icons.wb_sunny_outlined,
      value: getUvLevel(),
      rightWidget: Container(),
      value2: getUvDetail(),
    );
  }
}

class ItemWidget extends StatelessWidget {
  // 标题图标
  final IconData icon;
  // 标题
  final String title;
  // 值1
  final String value;
  // 值2
  final String value2;
  // 可选 右边自定义View
  final Widget? rightWidget;
  // 可选 底部自定义View
  final Widget? bottomWidget;

  const ItemWidget(
      {super.key,
      required this.title,
      required this.value,
      this.value2 = "",
      this.icon = Icons.wb_sunny_outlined,
      this.bottomWidget,
      this.rightWidget});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text.rich(TextSpan(children: [
                    WidgetSpan(
                      child: Icon(
                        icon,
                        size: 14.w,
                        color: Colors.black54,
                      ),
                      baseline: TextBaseline.alphabetic,
                    ),
                    TextSpan(
                        text: title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                            )),
                  ])),
                  SizedBox(
                    height: 6.w,
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black87,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const Spacer(),
                  Container(
                    child: bottomWidget,
                  ),
                  Text(
                    value2,
                    maxLines: 4,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500,
                        ),
                  )
                ],
              ),
            ),
            rightWidget ?? Container()
          ],
        ),
      ),
    );
  }
}

/// 湿度渐变色条Painter
class _LinePainter extends CustomPainter {
  // 下限湿度
  int lowerLimit;

  // 上限湿度
  int upperLimit;

  // 当前湿度
  int? currentWater;

  int get diff => upperLimit - lowerLimit;

  // 渐变色
  ui.Gradient? gradient;

  // 动画的进度
  double progress;

  _LinePainter(
      {required this.lowerLimit,
      required this.upperLimit,
      this.currentWater,
      this.progress = 1}) {}

  final Paint _paint = Paint()
    ..color = Colors.grey[300]!
    ..strokeWidth = 6.w
    ..strokeCap = StrokeCap.round;

  final Paint _pointPaint = Paint()
    ..color = Colors.grey[300]!
    ..strokeWidth = 6.w
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    gradient ??= ui.Gradient.linear(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), [
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.yellow[400]!,
      Colors.red[400]!
    ], [
      0.25,
      0.5,
      0.75,
      1
    ]);

    _paint.shader = gradient;
    canvas.drawLine(ui.Offset(0, size.height / 2),
        ui.Offset(size.width, size.height / 2), _paint);
    _paint.shader = null;
    if (currentWater == null) return;
    double x = size.width * (currentWater! - lowerLimit) / diff;
    _pointPaint.color = Colors.white;
    canvas.drawCircle(Offset(x, size.height / 2), 6.w, _pointPaint);
    _pointPaint.color = Colors.blue[200]!;
    canvas.drawCircle(Offset(x, size.height / 2), 4.w, _pointPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
