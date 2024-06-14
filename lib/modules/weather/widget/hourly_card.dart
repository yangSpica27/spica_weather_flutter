import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spica_weather_flutter/base/weather_type.dart';
import 'package:spica_weather_flutter/model/weather_response.dart';

class HourlyCard extends StatefulWidget {
  final WeatherResult weather;

  const HourlyCard({super.key, required this.weather});

  @override
  State<StatefulWidget> createState() => _HourlyCardState();
}

class _HourlyCardState extends State<HourlyCard> {
  final ScrollController _scrollController = ScrollController();

  double scrollX = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        scrollX = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Text(
          "小时别天气信息",
          style: Theme
              .of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
              color: widget.weather.todayWeather?.iconId?.getWeatherColor() ??
                  Colors.blue[500]),
        ),
        SizedBox(
          height: 4.w,
        ),
        Text(
          "${widget.weather.descriptionForToday}",
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium,
        ),
        SizedBox(
          height: 12.w,
        ),
        widget.weather.hourlyWeather == null
            ? _emptyWidget(context)
            : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: CustomPaint(
                key: ValueKey(widget.weather.hourlyWeather?.hashCode),
                size: Size(
            60.w * (widget.weather.hourlyWeather?.length ?? 0),
            160.w),
        painter: _LinePainter(
            scrollX: scrollX,
            data: widget.weather.hourlyWeather ?? [],
            themeColor: widget.weather.todayWeather?.iconId
                ?.getWeatherColor() ??
                Colors.blue[500]!),
      ),
    )],
    )
    ,
    )
    );
  }

  _emptyWidget(BuildContext context) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 10.w),
        child: Text(
          "暂无数据",
          style: Theme
              .of(context)
              .textTheme
              .titleMedium,
        ),
      );
}

class _LinePainter extends CustomPainter {
  List<HourlyWeather> data = [];

  Color themeColor;

  Path path = Path();

  Path path2 = Path();

  // 锚点X轴承位置
  List<double> xPoints = [];

  // 锚点Y轴位置顶部
  List<double> yPoints = [];

  // 锚点Y轴位置底部
  List<double> yPoints2 = [];

  List<ui.Color> colors = [];

  // 今天最低气温
  late int minTemp;

  // 今天最高气温
  late int maxTemp;

  double scrollX = 0.0;

  _LinePainter(
      {required this.data, required this.themeColor, required this.scrollX})
      : super() {
    if (data.isNotEmpty) {
      minTemp = data.first.temp!;
      maxTemp = data.first.temp!;
    }

    for (var element in data) {
      minTemp = min(minTemp, element.temp!);
      maxTemp = max(maxTemp, element.temp!);
    }

    data.asMap().forEach((index, value) {
      xPoints.add(index * itemWidth + itemWidth / 2.0);
      yPoints.add(topLinePadding +
          lineHeight -
          ((value.temp! - minTemp).toDouble() /
              (maxTemp - minTemp).toDouble() *
              lineHeight.toDouble()));

      yPoints2.add(lineHeight + bottomLinePadding);
      colors.add(value.iconId?.getWeatherColor() ?? Colors.blue[500]!);
    });

    // 设定初始点
    path.moveTo(xPoints.firstOrNull ?? 0, yPoints.firstOrNull ?? 0);
    path2.moveTo(xPoints.firstOrNull ?? 0, yPoints.firstOrNull ?? 0);

    // 画线
    data.asMap().forEach((index, value) {
      path.lineTo(xPoints[index], yPoints[index]);
      path2.lineTo(xPoints[index], yPoints[index]);
    });
    path2 = _createSmoothPath(path2);

    yPoints2.reversed.toList().asMap().forEach((index, value) {
      path.lineTo(xPoints[xPoints.length - 1 - index], value);
    });

    // 背景渐变
    bgShader = ui.Gradient.linear(
        Offset(0, topLinePadding),
        Offset(0, lineHeight + bottomLinePadding),
        [themeColor.withOpacity(.4), themeColor.withOpacity(.01)],
        [0, 1],
        TileMode.clamp);
  }

  late ui.Shader bgShader;

  final itemWidth = 60.w;

  final topLinePadding = 20.w;

  final bottomLinePadding = 80.w;

  final lineHeight = 30.w;

  final itemHeight = 160.w;

  final rectHeight = 15.w;

  final Paint _paint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 2.w
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景
    _paint.color = themeColor;
    _paint.shader = bgShader;
    _paint.style = PaintingStyle.fill;
    canvas.drawPath(path, _paint);
    // 绘制线条
    _paint.shader = null;
    _paint.color = themeColor;
    _paint.strokeWidth = 4.w;
    _paint.style = PaintingStyle.stroke;

    canvas.drawPath(path2, _paint);
    // 绘制底部天气类型
    _paint.style = PaintingStyle.fill;
    for (int i = 0; i < colors.length; i++) {
      _paint.color = colors[i].withOpacity(.3);
      canvas.drawRRect(
          ui.RRect.fromLTRBR(
              xPoints[i] - itemWidth / 2 + 2.w,
              yPoints2[i] + 2.w,
              xPoints[i] + itemWidth / 2 - 2.w,
              yPoints2[i] + rectHeight,
              const ui.Radius.circular(4)),
          _paint);
    }

    for (int i = 0; i < data.length; i++) {
      // 绘制底部时间

      final textPaint = TextPainter(
          text: TextSpan(
              text: data[i].fxTime?.substring(11, 16) ?? "",
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14.w,
                  fontWeight: FontWeight.w600)),
          textDirection: TextDirection.ltr)
        ..layout(maxWidth: itemWidth)
        ..textAlign = TextAlign.start;

      textPaint.paint(
          canvas,
          Offset(xPoints[i] - textPaint.width / 2,
              yPoints2[i] + rectHeight + 8.w));

      // 绘制降水柱状图

      _paint.color =
          Colors.blueAccent.withOpacity(.5 * (data[i].pop ?? 0) / 100);
      canvas.drawRRect(
          ui.RRect.fromLTRBR(
              xPoints[i] - itemWidth / 4,
              yPoints2[i] - ((data[i].pop ?? 0) / 100) * 50.w,
              xPoints[i] + itemWidth / 4,
              yPoints2[i],
              const ui.Radius.circular(4)),
          _paint);

      // 绘制下雨概率

      final textPaint2 = TextPainter(
          text: TextSpan(
              text: "${data[i].pop?.toString() ?? "7"}%",
              style: TextStyle(
                  color: (data[i].pop ?? 0) < 10
                      ? Colors.black87
                      : Colors.blueAccent,
                  fontSize: 13.w,
                  fontWeight: (data[i].pop ?? 0) < 10
                      ? FontWeight.w500
                      : FontWeight.w600)),
          textDirection: TextDirection.ltr)
        ..layout(maxWidth: itemWidth)
        ..textAlign = TextAlign.start;

      textPaint2.paint(
          canvas,
          Offset(
              xPoints[i] - textPaint2.width / 2,
              yPoints2[i] -
                  ((data[i].pop ?? 0) / 100) * 50.w -
                  textPaint2.height -
                  4.w));
    }

    double scrollMax =
        itemWidth * data.length - (ScreenUtil().screenWidth - 72.w);
    double offsetX =
        scrollX / scrollMax * (itemWidth * data.length - itemWidth) +
            itemWidth / 2;

    // 获取到游标指向是哪个Item
    final index = min((offsetX / itemWidth).round(), data.length - 1);

    // 绘制游标
    _paint.color = data[index].iconId?.getWeatherColor().withOpacity(.2) ??
        Colors.blueAccent.withOpacity(.2);
    canvas.drawRRect(
        ui.RRect.fromLTRBR(
            offsetX - itemWidth / 2 - 8.w,
            0,
            offsetX + itemWidth / 2 + 8.w,
            itemHeight,
            const ui.Radius.circular(8)),
        _paint);

    final textPaint = TextPainter(
        text: TextSpan(
            text: "${data[index].temp?.toString()}℃",
            style: TextStyle(
                color: Colors.black87,
                fontSize: 14.w,
                fontWeight: FontWeight.w600)),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: itemWidth)
      ..textAlign = TextAlign.start;

    textPaint.paint(
        canvas,
        Offset(offsetX - textPaint.width / 2,
            yPoints[index] - textPaint.height - 4.w));
  }

  // 生产平滑线Path
  Path _createSmoothPath(Path originalPath) {
    final PathMetric pathMetric = originalPath
        .computeMetrics()
        .first;
    final Path smoothPath = Path();
    const int divisions = 100;
    for (int i = 0; i <= divisions; i++) {
      final double x = i / divisions * pathMetric.length;
      final Tangent? tangent = pathMetric.getTangentForOffset(x);
      if (tangent != null) {
        if (i == 0) {
          smoothPath.moveTo(tangent.position.dx, tangent.position.dy);
        } else {
          smoothPath.lineTo(tangent.position.dx, tangent.position.dy);
        }
      }
    }

    return smoothPath;
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) =>
      (oldDelegate.data != data) || (scrollX != oldDelegate.scrollX);
}
