import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 天气动画视图[沙尘暴]
class SandstormView extends StatefulWidget {
  const SandstormView({super.key, required this.width, required this.height});

  final double width;

  final double height;

  @override
  State<SandstormView> createState() => _SandstormViewState();
}

class _StormLine {
  // 初始化位置x
  late double x;

// 初始化位置y
  late double y;

  // 当前的位置x
  double cx = 0;

  // 当前的位置y
  late final double cy;

  // 角度
  late final double angle;

  late final double speed;

  late final Color color;

  late final double radius;

  final double height;

  final double width;

  _StormLine(Random random, this.width, this.height) {
    final rd = random.nextDouble();
    if (rd < 0.5) {
      color = Colors.white;
    } else if (rd < 0.7) {
      color = Colors.brown;
    } else {
      color = Colors.white.withOpacity(0.5);
    }

    radius = 2.w + random.nextDouble() * 2.w;
    x = -radius * 20;
    y = random.nextDouble() * height / 10 * 8 + height / 10;
    angle = (y - height / 10) / (height / 10 * 8) * 15 - 7.5;
    speed = (2.0 + random.nextDouble() * 1);
    cx = x;
    cy = y;
  }

  next() {
    cx += speed;
    if (cx > width) {
      cx = x;
    }
  }

  draw(Canvas canvas, Paint paint) {
    paint.color = color;
    paint.strokeWidth = radius;
    final rotate = 3.14 / 180 * angle;
    canvas.rotate(rotate);
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(Offset(cx + 3 * i * radius, cy),
          radius + radius / 2 * ((cx + 3 * i * radius) / width), paint);
    }
    canvas.rotate(-rotate);
  }
}

class _SandstormViewState extends State<SandstormView>
    with SingleTickerProviderStateMixin {
  final List<_StormLine> _lines = [];

  final Random _random = Random();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation anim =
      Tween<double>(begin: 0, end: 1).animate(_controller);

  @override
  void initState() {
    for (int i = 0; i < 30; i++) {
      _lines.add(_StormLine(
        _random,
        widget.width,
        widget.height,
      ));
    }
    anim.addListener(() {
      for (var line in _lines) {
        line.next();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: anim,
        builder: (context, w) => CustomPaint(
              painter: _SandstormViewPainter(_lines),
              size: Size(widget.width, widget.height),
            ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SandstormViewPainter extends CustomPainter {
  final _paint = Paint()
    ..color = const Color(0x33FFFFFF)
    ..style = PaintingStyle.fill;

  _SandstormViewPainter(this.lines);

  final List<_StormLine> lines;

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      line.draw(canvas, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
