import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spica_weather_flutter/base/weather_type.dart';
import 'package:spica_weather_flutter/model/weather_response.dart';

class AirDescCard extends StatefulWidget {
  final WeatherResult weather;

  const AirDescCard({super.key, required this.weather});

  @override
  State<AirDescCard> createState() => _AirDescCardState();
}

class _AirDescCardState extends State<AirDescCard>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 2500),
    vsync: this,
  );

  late final enterProgressAnim = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
            "空气质量",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: widget.weather.todayWeather?.iconId?.getWeatherColor() ??
                    Colors.blue[500]),
          ),
          SizedBox(
            height: 12.w,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimatedBuilder(
                  animation: enterProgressAnim,
                  builder: (BuildContext context, Widget? child) => CustomPaint(
                        size: Size(110.w, 110.w),
                        painter: _AirProgressPainter(
                            centerText: "污染指数",
                            air: (widget.weather.air?.aqi?.toDouble() ?? 0) *
                                enterProgressAnim.value),
                      )),
              const Spacer(),
              Container(
                  alignment: Alignment.center,
                  height: 110.w,
                  width: ScreenUtil().screenWidth / 2 - 40.w,
                  child: _RightDescWidget(weather: widget.weather)),
            ],
          ),
        ],
      ),
    ));
  }
}

class _RightDescWidget extends StatelessWidget {
  final WeatherResult weather;

  const _RightDescWidget({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _item(context, "二氧化碳", "${weather.air?.co ?? "/"}微克/m³"),
        SizedBox(
          height: 5.w,
        ),
        _item(context, "二氧化氮", "${weather.air?.no2 ?? "/"}微克/m³"),
        SizedBox(
          height: 5.w,
        ),
        _item(context, "二氧化硫", "${weather.air?.so2 ?? "/"}微克/m³"),
        SizedBox(
          height: 5.w,
        ),
        _item(context, "pm2.5", "${weather.air?.pm2p5 ?? "/"}微克/m³"),
      ],
    );
  }

  Widget _item(BuildContext context, String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500, color: Colors.black87)),
        const Spacer(),
        Text(value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.black54, fontWeight: FontWeight.w500))
      ],
    );
  }
}

class _AirProgressPainter extends CustomPainter {
  var centerText = "空气质量";

  final double air;

  final gradient = ui.Gradient.sweep(
    Offset(50.w, 50.w),
    [
      Colors.green,
      Colors.yellow[500]!,
      Colors.orange,
      Colors.deepOrangeAccent,
      Colors.grey[400]!,
      Colors.grey[500]!
    ],
    [0, .2, .4, .6, .8, 1],
    TileMode.clamp,
    pi / 180 * 45,
    pi / 180 * (45 + 270),
  );

  _AirProgressPainter({required this.centerText, required this.air}) {
    if (air < 50) {
      _textPaint.color = Colors.green;
    } else if (air < 100) {
      _textPaint.color = Colors.yellow[500]!;
    } else if (air < 150) {
      _textPaint.color = Colors.orange;
    } else if (air < 200) {
      _textPaint.color = Colors.deepOrangeAccent;
    } else if (air < 300) {
      _textPaint.color = Colors.grey[400]!;
    } else {
      _textPaint.color = Colors.grey[500]!;
    }
  }

  final _paint = Paint()
    ..color = Colors.blue
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8.w;

  final _textPaint = Paint()
    ..color = Colors.blue
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8.w;

  final startAngle = 45;

  final sweepAngle = 270.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(pi / 180 * 90);
    canvas.translate(-size.width / 2, -size.height / 2);
    _paint.shader = null;
    _paint.color = Colors.grey[300]!;
    canvas.drawArc(Rect.fromLTRB(0, 0, size.width, size.height),
        pi / 180 * startAngle, pi / 180 * sweepAngle, false, _paint);
    _paint.shader = gradient;
    canvas.drawArc(
        Rect.fromLTRB(0, 0, size.width, size.height),
        pi / 180 * startAngle,
        pi / 180 * sweepAngle * min(1, air / 300),
        false,
        _paint);
    canvas.restore();

    final textPainter = TextPainter(
        text: TextSpan(
            text: centerText,
            style: TextStyle(
                color: Colors.black,
                fontSize: 12.w,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500)),
        textDirection: TextDirection.ltr)
      ..layout();
    textPainter.paint(
        canvas,
        Offset(size.width / 2 - textPainter.width / 2,
            size.height - textPainter.height - 6.w));
    // canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), _paint);
    final textPainter2 = TextPainter(
        text: TextSpan(
            text: "${air.toInt()}",
            style: TextStyle(
                color: _textPaint.color,
                fontSize: 35.w,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600)),
        textDirection: TextDirection.ltr)
      ..layout();

    textPainter2.paint(
        canvas,
        Offset(size.width / 2 - textPainter2.width / 2,
            size.height / 2 - textPainter2.height / 2));
  }

  @override
  bool shouldRepaint(covariant _AirProgressPainter oldDelegate) =>
      oldDelegate.centerText != centerText || oldDelegate.air != air;
}
