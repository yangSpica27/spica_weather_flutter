import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 天气动画视图[下雨]
class RainView extends StatefulWidget {
  const RainView({super.key, required this.width, required this.height});

  final double width;

  final double height;

  @override
  State<RainView> createState() => _RainViewState();
}

class _RainViewState extends State<RainView>
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

  List<RainSnowDrop> rainDrops = [];

  final Random random = Random();

  @override
  void initState() {
    for (int i = 0; i < 70; i++) {
      rainDrops.add(RainSnowDrop(
          dx: random.nextInt(widget.width.toInt()).toDouble(),
          dy: -random.nextInt(widget.height.toInt()).toDouble(),
          maxDx: widget.width,
          maxDy: widget.height));
    }
    anim.addListener(() {
      for (var element in rainDrops) {
        element.next();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    rainDrops.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: anim,
        builder: (context, _) => CustomPaint(
              painter: _RainViewPainter(rainDrops: rainDrops),
              size: Size(widget.width, widget.height),
            ));
  }
}

class RainSnowDrop {
  late Offset position;

  double dx;

  double dy;

  double maxDx;
  double maxDy;

  late double speed;

  late double angle;

  static final randomInstance = Random();

  RainSnowDrop(
      {required this.dx,
      required this.dy,
      required this.maxDx,
      required this.maxDy,
      double seed = 10}) {
    position = Offset(dx, dy);
    double random = 0.4 + 0.12 * randomInstance.nextDouble() * 5;
    speed = seed * random;
    angle = 7.5 - (dx / maxDx) * 15;
  }

  next() {
    position = position.translate(0, speed);
    if (position.dy > maxDy) {
      position = Offset(dx, dy);
    }
  }
}

class _RainViewPainter extends CustomPainter {
  _RainViewPainter({required this.rainDrops});

  List<RainSnowDrop> rainDrops;

  final _paint = Paint()
    ..color = const Color(0x4DFFFFFF)
    ..strokeWidth = 3.w
    ..strokeCap = StrokeCap.square
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    for (var element in rainDrops) {
      double angle = element.angle * 3.14 / 180;
      canvas.rotate(angle);
      canvas.drawLine(
          element.position, element.position.translate(0, 22.w), _paint);
      canvas.rotate(-angle);
    }
  }

  @override
  bool shouldRepaint(covariant _RainViewPainter oldDelegate) {
    return true;
  }
}
