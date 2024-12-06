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

  // 雨点粒子
  List<RainSnowDrop> rainDrops = [];

  // 滴水效果粒子
  List<RainSnowDrop> rainDrops2 = [];

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
    for (int i = 0; i < 4; i++) {
      if (i == 0) continue;
      rainDrops2.add(RainSnowDrop(
          dx: 30.w + (widget.width - 60.w) / 4 * i,
          dy: widget.height - 28.w,
          maxDx: widget.width,
          maxDy: widget.height + 8.w,
          seed: 2));
    }
    anim.addListener(() {
      for (var element in rainDrops) {
        element.next();
      }
      for (var element in rainDrops2) {
        element.next();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    rainDrops.clear();
    rainDrops2.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: anim,
        builder: (context, _) => CustomPaint(
              painter: _RainViewPainter(
                  color: Theme.of(context).colorScheme.surface,
                  rainDrops: rainDrops,
                  rainDrops2: rainDrops2),
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
      double seed = 15}) {
    position = Offset(dx, dy);
    double random = 0.4 + 0.12 * randomInstance.nextDouble() * 5;
    speed = seed * random;
    angle = 7.5 - (dx / maxDx) * 15;
  }

  next() {
    position = position.translate(
        0, speed / 2 + speed / 2 * (maxDy - position.dy) / maxDy);
    if (position.dy > maxDy) {
      position = Offset(dx, dy);
    }
  }
}

class _RainViewPainter extends CustomPainter {
  _RainViewPainter(
      {required this.rainDrops,
      required this.rainDrops2,
      required this.color}) {
    _paint.color = color.withAlpha(0x4D);
    _paint2.color = color;
  }

  // 背景粒子
  List<RainSnowDrop> rainDrops;

  // 滴水效果粒子
  List<RainSnowDrop> rainDrops2;

  final Color color;

  final _paint = Paint()
    ..strokeWidth = 3.w
    ..strokeCap = StrokeCap.square
    ..style = PaintingStyle.fill;

  final _paint2 = Paint()
    ..strokeWidth = 3.w
    ..strokeCap = StrokeCap.square
    ..style = PaintingStyle.fill;

  final path = Path();

  final radius = 4.w;

  @override
  void paint(Canvas canvas, Size size) {
    for (var element in rainDrops) {
      double angle = element.angle * 3.14 / 180;
      canvas.rotate(angle);
      canvas.drawLine(
          element.position, element.position.translate(0, 22.w), _paint);
      canvas.rotate(-angle);
    }
    // for (var element in rainDrops2) {
    //   // 绘制粘连效果条件
    //   // 水滴在面板底部 水滴的中心点和面板底部距离小于水滴半径
    //   if (element.position.dy > (size.height - 20.w) &&
    //       element.position.dy - (size.height - 20.w) < radius) {
    //     // 复用的path减少内存抖动
    //     path.reset();
    //     // 移动到水滴的中心点
    //     path.moveTo(element.position.dx, element.position.dy);
    //     // 比例 水滴中心点到面板底部的距离 / 水滴半径
    //     double fraction =
    //         ((size.height - 20.w + radius) - element.position.dy) / radius;
    //     // 效果的左边极限距离
    //     double leftX = element.position.dx - 4 * radius * fraction;
    //     // 控制点的x坐标
    //     double leftControlX = element.dx - 2 * radius * fraction;
    //     // 效果的右边极限距离
    //     double rightX = element.position.dx + 4 * radius * fraction;
    //     // 控制点的x坐标
    //     double rightControlX = element.dx + 2 * radius * fraction;
    //     // 效果的y轴承坐标[面板底部]
    //     double topY = size.height - 20.w;
    //     // 控制点的y坐标【随着雨滴向下 折点也向下】
    //     double controlY = topY + (element.dy - topY) / 2;
    //     path.lineTo(leftX, topY);
    //     path.lineTo(rightX, topY);
    //     path.close();
    //     // path.quadraticBezierTo(rightControlX, controlY, rightX, topY);
    //     // path.lineTo(leftX, topY);
    //     // path.quadraticBezierTo(
    //     //     leftControlX, controlY, element.position.dx, element.position.dy);
    //     // path.close();
    //     canvas.drawPath(path, _paint2);
    //   }
    //
    //   canvas.drawOval(
    //       Rect.fromCenter(
    //           center: element.position, width: radius * 2, height: radius * 2),
    //       _paint2);
    // }
  }

  @override
  bool shouldRepaint(covariant _RainViewPainter oldDelegate) {
    return true;
  }
}
