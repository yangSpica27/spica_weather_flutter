import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spica_weather_flutter/base/weather_type.dart';
import 'package:spica_weather_flutter/model/weather_response.dart';

/// 降水量信息卡片
class PrecipitationCard extends StatefulWidget {
  final WeatherResult weather;

  const PrecipitationCard({super.key, required this.weather});

  @override
  State<PrecipitationCard> createState() => _PrecipitationCardState();
}

class _PrecipitationCardState extends State<PrecipitationCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  );

  late final enterAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animController, curve: Curves.fastEaseInToSlowEaseOut));

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(15.w),
      child: material.Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "每五分钟降水量",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: widget.weather.todayWeather?.iconId?.getWeatherColor() ??
                    Colors.blue[500]),
          ),
          SizedBox(
            height: 12.w,
          ),
          AnimatedBuilder(
              animation: enterAnim,
              builder: (context, w) => CustomPaint(
                    size: Size(0, 150.w),
                    painter: _PrecipitationLinePainter(
                        widget.weather.minutely ?? [],
                        enterAnim.value,
                        material.Theme.of(context).colorScheme.onSurface),
                  )),
          SizedBox(
            height: 12.w,
          ),
        ],
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
//
}

class _PrecipitationLinePainter extends CustomPainter {
  final List<Minutely> minutelyList;

  final double progress;

  double lineWidth = 2.0.w;

  Color textColor = Colors.black87;

  _PrecipitationLinePainter(this.minutelyList, this.progress, this.textColor);

  final Paint _linePaint = Paint()
    ..color = Colors.grey[300]!
    ..strokeWidth = 2.w
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  final bgPaint = Paint()
    ..color = Colors.grey[200]!
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    if (minutelyList.isEmpty) {
      return;
    }
    _linePaint.strokeWidth = 2.w;
    // 绘制底线
    canvas.drawLine(Offset(0, size.height - _linePaint.strokeWidth),
        Offset(size.width, size.height - _linePaint.strokeWidth), _linePaint);

    _linePaint.color = Colors.grey[300]!;
    _linePaint.strokeWidth = 1.w;
    // 绘制右边文字
    double rightPadding = drawRightText(canvas, size, "小雨", size.height / 4);
    canvas.drawLine(Offset(0, size.height / 4),
        Offset(size.width - rightPadding - 8.w, size.height / 4), _linePaint);
    drawRightText(canvas, size, "中雨", size.height / 4 * 2);
    canvas.drawLine(
        Offset(0, size.height / 4 * 2),
        Offset(size.width - rightPadding - 8.w, size.height / 4 * 2),
        _linePaint);
    drawRightText(canvas, size, "大雨", size.height / 4 * 3);
    canvas.drawLine(
        Offset(0, size.height / 4 * 3),
        Offset(size.width - rightPadding - 8.w, size.height / 4 * 3),
        _linePaint);

    lineWidth = (size.width - rightPadding - 8.w) / (minutelyList.length);
    _linePaint.strokeWidth = lineWidth / 2;

    // 绘制
    minutelyList.forEachIndexed((index, minutely) {
      _linePaint.color = Colors.grey.withOpacity(0.2 +
          min((double.tryParse(minutely.precip ?? "") ?? 0) / 2.5, 1.0) * 0.5);
      double x = lineWidth * (index);
      double y = size.height -
          2.w -
          min((double.tryParse(minutely.precip ?? "") ?? 0) / 2.5, 1.0) *
              size.height *
              progress;
      canvas.drawLine(Offset(x, y), Offset(x, size.height - 2.w), _linePaint);
    });

    _linePaint.strokeWidth = 1.w;
    _linePaint.color = Colors.grey[300]!;
    canvas.drawLine(Offset(6 * lineWidth, 0),
        Offset(6 * lineWidth, size.height - 2.w), _linePaint);
    final timeTextPainter = TextPainter(
        text: TextSpan(
            text: "1小时后",
            style: TextStyle(
                color: textColor,
                fontSize: 12.w,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500)),
        textDirection: TextDirection.ltr)
      ..layout();
    timeTextPainter.paint(
        canvas,
        Offset(
            6 * lineWidth + 4.w, size.height - timeTextPainter.height - 4.w));
  }

  double drawRightText(Canvas canvas, Size size, String text, double y) {
    final textPainter = TextPainter(
        text: TextSpan(
            text: text,
            style: TextStyle(
                color: textColor,
                fontSize: 12.w,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500)),
        textDirection: TextDirection.ltr)
      ..layout();
    textPainter.paint(
        canvas,
        Offset(size.width - textPainter.width,
            size.height - y - textPainter.height / 2));
    return textPainter.width;
  }

  @override
  bool shouldRepaint(covariant _PrecipitationLinePainter oldDelegate) {
    return oldDelegate.minutelyList != minutelyList ||
        oldDelegate.progress != progress;
  }
}
