import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:spica_weather_flutter/base/weather_type.dart';
import 'package:spica_weather_flutter/generated/assets.dart';

import '../../../model/weather_response.dart';

/// 天级别天气卡片
class DailyCard extends StatelessWidget {
  const DailyCard({super.key, required this.weather});

  final WeatherResult weather;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "天级别天气信息",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: weather.todayWeather?.iconId?.getWeatherColor() ??
                      Colors.blue[500]),
            ),
            (weather.dailyWeather != null)
                ? ListView.separated(
                    itemBuilder: (context, index) =>
                        _itemBuilder(context, index),
                    separatorBuilder: (context, index) => const SizedBox(),
                    itemCount: weather.dailyWeather?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  )
                : _emptyWidget(context),
          ],
        ),
      ),
    );
  }

  // 空数据
  _emptyWidget(BuildContext context) => Container(
        padding: EdgeInsets.all(10.w),
        child: Text(
          "暂无数据",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );

  /// 列表项构建
  _itemBuilder(BuildContext context, int index) {
    return Theme(
        data: Theme.of(context).copyWith(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey(index),
          tilePadding: EdgeInsets.zero,
          title: _TitleWidget(
            dailyWeather: weather.dailyWeather![index],
            isHeader: index == 0,
            upperLimit: weather.upperLimit(),
            lowerLimit: weather.lowerLimit(),
            temp: weather.todayWeather?.temp ?? 0,
          ),
          children: [
            _detailWidget(context, weather.dailyWeather![index]),
            SizedBox(
              height: 12.w,
            )
          ],
        ));
  }

  /// 详细部分
  _detailWidget(BuildContext context, DailyWeather dailyWeather) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
              "白天 ${dailyWeather.weatherNameDay ?? "--"} / 夜间 ${dailyWeather.weatherNameNight ?? "--"}",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
          SizedBox(
            height: 8.w,
          ),
          GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.w),
              children: [
                _detailItem(Assets.assetsIcWater, "湿度",
                    "${dailyWeather.water?.toString()}%", context),
                _detailItem(Assets.assetsIcLightRain, "降水量",
                    "${dailyWeather.precip?.toString()}mm", context),
                _detailItem(Assets.assetsIcWindmill, "风速",
                    "${dailyWeather.dayWindSpeed?.toString()}km/h", context),
                _detailItem(Assets.assetsIcSunHat, "紫外线强度",
                    "${dailyWeather.uv?.toString()}", context),
                _detailItem(Assets.assetsIcCloudy, "云层覆盖率",
                    "${dailyWeather.cloud?.toString()}%", context),
                _detailItem(Assets.assetsIcTelescope, "能见度",
                    "${dailyWeather.vis?.toString()}m", context),
              ])
        ],
      );

  _detailItem(
          String assets, String title, String value, BuildContext context) =>
      Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
            color: const Color(0x1a4a4a4a),
            borderRadius: BorderRadius.circular(8.w)),
        child: Row(
          children: [
            Image.asset(
              assets,
              width: 24.w,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.9),
            ),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.5),
                        ),
                  )
                ],
              ),
            )
          ],
        ),
      );
}

class _LinePainter extends CustomPainter {
  // 下限温度
  int lowerLimit;

  // 上限温度
  int upperLimit;

  // 当前温度
  int? currentTemp;

  int get diff => upperLimit - lowerLimit;

  // 这天的最高气温
  int maxTemp;

  // 这天的最低气温
  int minTemp;

  // 渐变色
  ui.Gradient? gradient;

  ui.Color backgroundColor;

  // 动画的进度
  double progress;

  _LinePainter(
      {required this.lowerLimit,
      required this.upperLimit,
      this.currentTemp,
      this.progress = 1,
      this.backgroundColor = Colors.grey,
      required this.maxTemp,
      required this.minTemp});

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
    // 根据一周内的最高最低气温生产渐变色
    if (gradient == null) {
      final Color startColor;

      if (lowerLimit < 0) {
        startColor = Colors.blue[500]!;
      } else if (lowerLimit < 10) {
        startColor = Colors.blue[300]!;
      } else if (lowerLimit < 20) {
        startColor = Colors.blue[200]!;
      } else {
        startColor = Colors.yellow[200]!;
      }

      Color endColor = Colors.orange;

      if (upperLimit < 0) {
        endColor = Colors.blue[100]!;
      } else if (upperLimit < 10) {
        endColor = Colors.yellow[300]!;
      } else if (upperLimit < 20) {
        endColor = Colors.yellow[500]!;
      } else if (upperLimit < 30) {
        endColor = Colors.yellow[600]!;
      } else {
        endColor = Colors.yellow[700]!;
      }

      gradient = ui.Gradient.linear(const Offset(0, 0), Offset(size.width, 0),
          [startColor, endColor], [0, 1], TileMode.clamp);
    }

    _paint.shader = null;
    _paint.color = backgroundColor;
    canvas.drawLine(Offset(0, size.height / 2),
        Offset(size.width, size.height / 2), _paint);
    _paint.color = Colors.grey[300]!;
    _paint.shader = gradient;
    canvas.drawLine(
        Offset(0 + (minTemp - lowerLimit) / diff * size.width, size.height / 2),
        Offset(size.width - (upperLimit - maxTemp) / diff * size.width,
            size.height / 2),
        _paint);
    if (currentTemp != null) {
      _pointPaint.color = Colors.white;
      canvas.drawCircle(
          Offset(0 + (currentTemp! - lowerLimit) / diff * size.width,
              size.height / 2),
          6.w,
          _pointPaint);
      _pointPaint.color = Colors.orangeAccent;
      canvas.drawCircle(
          Offset(0 + (currentTemp! - lowerLimit) / diff * size.width,
              size.height / 2),
          4.w,
          _pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension WeekStringExt on String {
  String toWeekString() {
    switch (this) {
      case "1":
        return "周一";
      case "2":
        return "周二";
      case "3":
        return "周三";
      case "4":
        return "周四";
      case "5":
        return "周五";
      case "6":
        return "周六";
      case "7":
        return "周日";
      default:
        return "未知";
    }
  }
}

class _TitleWidget extends StatefulWidget {
  const _TitleWidget(
      {required this.temp,
      required this.dailyWeather,
      required this.isHeader,
      required this.upperLimit,
      required this.lowerLimit});

  final DailyWeather dailyWeather;

  final int temp;

  final bool isHeader;

  final int upperLimit;

  final int lowerLimit;

  @override
  State<_TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<_TitleWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  Animation<double>? animation;

  @override
  void initState() {
    if (widget.isHeader) {
      animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 2000));
      animation = Tween<double>(begin: 0, end: 1).animate(animationController!);
      animationController?.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(
          (DateTime.tryParse(widget.dailyWeather.fxTime ?? '')
                      ?.weekday
                      .toString() ??
                  '/')
              .toWeekString(),
          style: context.theme.textTheme.titleMedium?.copyWith(
              color: widget.isHeader
                  ? widget.dailyWeather.iconId?.getWeatherColor() ??
                      Colors.blue[500]
                  : Theme.of(context).colorScheme.onSurface.withOpacity(.9),
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          width: 12.w,
        ),
        Image.asset(
          widget.dailyWeather.iconId?.getWeatherType().getIconAssetString() ??
              Assets.assetsIcSun,
          width: 28.w,
        ),
        SizedBox(
          width: 12.w,
        ),
        Text(
          "${widget.dailyWeather.minTemp?.toString()}℃",
          style: context.theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w400),
        ),
        SizedBox(
          width: 12.w,
        ),
        Expanded(
          flex: 1,
          child: IntrinsicHeight(
              child: animation != null
                  ? AnimatedBuilder(
                      animation: animation!,
                      builder: (c, w) => CustomPaint(
                            painter: _LinePainter(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withOpacity(.1),
                              maxTemp: widget.dailyWeather.maxTemp ?? 0,
                              minTemp: widget.dailyWeather.minTemp ?? 0,
                              currentTemp: widget.isHeader ? widget.temp : null,
                              upperLimit: widget.upperLimit,
                              lowerLimit: widget.lowerLimit,
                              progress: animation!.value,
                            ),
                          ))
                  : CustomPaint(
                      painter: _LinePainter(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(.1),
                        maxTemp: widget.dailyWeather.maxTemp ?? 0,
                        minTemp: widget.dailyWeather.minTemp ?? 0,
                        currentTemp: widget.isHeader ? widget.temp : null,
                        upperLimit: widget.upperLimit,
                        lowerLimit: widget.lowerLimit,
                      ),
                    )),
        ),
        SizedBox(
          width: 12.w,
        ),
        Text(
          "${widget.dailyWeather.maxTemp?.toString()}℃",
          style: context.theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
