import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spica_weather_flutter/modules/weather/widget/weather_anim_widget/rain_view.dart';

/// 天气动画视图[雪]
class SnowView extends StatefulWidget {
  const SnowView({required this.width, required this.height});

  final double width;

  final double height;

  @override
  State<SnowView> createState() => _SnowViewState();
}

class _SnowViewState extends State<SnowView>
    with SingleTickerProviderStateMixin {
  late AnimationController animController = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  )..repeat(reverse: true);

  late final anim = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: animController,
      curve: Curves.ease,
    ),
  );

  List<RainSnowDrop> snowDrops = [];

  final Random random = Random();

  @override
  void initState() {
    for (int i = 0; i < 70; i++) {
      snowDrops.add(RainSnowDrop(
          dx: random.nextInt(widget.width.toInt()).toDouble(),
          dy: -random.nextInt(widget.height.toInt()).toDouble(),
          maxDx: widget.width,
          maxDy: widget.height,
          seed: 2.5));
    }
    anim.addListener(() {
      for (var element in snowDrops) {
        element.next();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    snowDrops.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: anim,
        builder: (context, _) => CustomPaint(
              painter: _SnowViewPainter(snowDrops: snowDrops),
              size: Size(widget.width, widget.height),
            ));
  }
}

class _SnowViewPainter extends CustomPainter {
  _SnowViewPainter({required this.snowDrops});

  List<RainSnowDrop> snowDrops;

  final _paint = Paint()
    ..color = const Color(0x4DFFFFFF)
    ..strokeWidth = 12.w
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPoints(
        PointMode.points, snowDrops.map((e) => e.position).toList(), _paint);
  }

  @override
  bool shouldRepaint(covariant _SnowViewPainter oldDelegate) {
    return true;
  }
}
