import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spica_weather_flutter/base/weather_type.dart';

/// 天气动画背景
class WeatherAnimView extends StatelessWidget {
  final WeatherAnimType _weatherAnimType;

  const WeatherAnimView(this._weatherAnimType,
      {super.key, this.width = 0, this.height = 0});

  final double width;

  final double height;

  @override
  Widget build(BuildContext context) {
    // return _FogView(width: width, height: height);
    switch (_weatherAnimType) {
      case WeatherAnimType.SUNNY:
        return _SunnyView(width, height);
      case WeatherAnimType.RAIN:
        return _RainView(width: width, height: height);
      case WeatherAnimType.SNOW:
        return _SnowView(width: width, height: height);
      case WeatherAnimType.HAZE:
      case WeatherAnimType.FOG:
        return _FogView(width: width, height: height);
      case WeatherAnimType.CLOUDY:
        return _CloudyView(width: width, height: height);
      default:
        return Container();
    }
  }
}

/// 天气动画视图[晴天]
class _SunnyView extends StatefulWidget {
  const _SunnyView(this.width, this.height);

  final double width;

  final double height;

  @override
  State<_SunnyView> createState() => _SunnyViewState();
}

class _SunnyViewState extends State<_SunnyView> with TickerProviderStateMixin {
  final path1 = Path();

  final path2 = Path();

  final path3 = Path();

  final path4 = Path();

  late AnimationController controller1 = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  )..repeat(reverse: true);

  late AnimationController controller2 = AnimationController(
    duration: const Duration(milliseconds: 2500),
    vsync: this,
  )..repeat(reverse: true);

  late AnimationController controller3 = AnimationController(
    duration: const Duration(milliseconds: 1200),
    vsync: this,
  );

  late final Animation anim1;

  late final Animation anim2;

  late final Animation anim3 =
      Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
    parent: controller3,
    curve: Curves.easeInOutBack,
  ));

  @override
  void initState() {
    anim1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.ease,
      ),
    );
    anim2 = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: controller2,
      curve: Curves.linear,
    ));
    anim2.addListener(() async {
      path1.reset();
      path2.reset();
      path3.reset();
      path4.reset();

      path1.moveTo(widget.width * 1, 0);
      path1.lineTo(
          widget.width * 1, widget.width * 1 / 10.0 * 6.0 + 20.w * anim2.value);
      path1.cubicTo(
          widget.width * 1.0 / 10 * 9,
          widget.width * 1.0 / 10 * 6 + 12.w * anim2.value,
          widget.width * 1.0 / 10 * 4,
          widget.width * 1.0 / 10 * 5 + 10.w * anim2.value,
          widget.width / 10.0 * 4 - 30.w * anim2.value,
          0);

      path2.moveTo(widget.width * 1, 0);
      path2.lineTo(
          widget.width * 1, widget.width * 1.0 / 10.0 * 7 + 25.w * anim2.value);
      path2.cubicTo(
          widget.width * 1.0 / 10.0 * 8,
          widget.width * 1.0 / 10.0 * 7 + 20.w * anim2.value,
          widget.width * 1.0 / 10.0 * 4,
          widget.width * 1.0 / 10.0 * 6 + 15.w * anim2.value,
          widget.width / 10.0 * 4 - 20.w * anim2.value,
          0);

      path3.moveTo(widget.width * 1, 0);
      path3.lineTo(
          widget.width * 1, widget.width * 1.0 / 10.0 * 7 + 12.w * anim1.value);
      path3.cubicTo(
          widget.width * 1.0 / 10.0 * 8,
          widget.width * 1.0 / 10.0 * 6 + 15.w * anim1.value,
          widget.width * 1.0 / 10.0 * 4,
          widget.width * 1.0 / 10.0 * 6 + 20.w * anim1.value,
          widget.width / 10.0 * 3 - 24.w * anim1.value,
          0);

      path4.moveTo(widget.width * 1, 0);
      path4.lineTo(
          widget.width * 1, widget.width * 1.0 / 10.0 * 8 + 40.w * anim1.value);
      path4.cubicTo(
          widget.width * 1.0 / 10.0 * 8,
          widget.width * 1.0 / 10.0 * 8 + 40.w * anim1.value,
          widget.width * 1.0 / 10.0 * 2,
          widget.width * 1.0 / 10.0 * 6 + 40.w * anim1.value,
          widget.width / 10.0 * 4 - 40.w * anim1.value,
          0);
    });
    controller3.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: anim1,
        builder: (context, _) => CustomPaint(
              painter:
                  _SunnyViewPainter(path1, path2, path3, path4, anim3.value),
              size: Size(widget.width, widget.height),
            ));
  }
}

class _SunnyViewPainter extends CustomPainter {
  final Path path1;

  final Path path2;

  final Path path3;

  final Path path4;

  final double progress;

  _SunnyViewPainter(
      this.path1, this.path2, this.path3, this.path4, this.progress);

  final _paint = Paint()
    ..color = const Color(0x33FFFFFF)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width, 0);
    canvas.scale(progress, progress);
    canvas.translate(-size.width, 0);
    canvas.drawPath(path1, _paint);
    canvas.drawPath(path2, _paint);
    canvas.drawPath(path3, _paint);
    canvas.drawPath(path4, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// 天气动画视图[下雨]
class _RainView extends StatefulWidget {
  const _RainView({required this.width, required this.height});

  final double width;

  final double height;

  @override
  State<_RainView> createState() => _RainViewState();
}

class _RainViewState extends State<_RainView>
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

  double maxDy;

  late double speed;

  RainSnowDrop(
      {required this.dx,
      required this.dy,
      required this.maxDy,
      double seed = 10}) {
    position = Offset(dx, dy);
    double random = 0.4 + 0.12 * Random().nextDouble() * 5;
    speed = seed * random;
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
      canvas.drawLine(
          element.position, element.position.translate(0, 22.w), _paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RainViewPainter oldDelegate) {
    return true;
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

/// 天气动画视图[雪]
class _SnowView extends StatefulWidget {
  const _SnowView({required this.width, required this.height});

  final double width;

  final double height;

  @override
  State<_SnowView> createState() => _SnowViewState();
}

class _SnowViewState extends State<_SnowView>
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

/// 天气动画视图[雾]
class _FogView extends StatefulWidget {
  const _FogView({required this.width, required this.height});

  final double width;

  final double height;

  @override
  State<_FogView> createState() => _FogViewState();
}

class _FogViewState extends State<_FogView> with TickerProviderStateMixin {
  final path1 = Path();

  final path2 = Path();

  final path3 = Path();

  late AnimationController controller1 = AnimationController(
    duration: const Duration(milliseconds: 3500),
    vsync: this,
  )..repeat(reverse: true);

  late AnimationController controller2 = AnimationController(
    duration: const Duration(milliseconds: 5500),
    vsync: this,
  )..repeat(reverse: true);

  late AnimationController controller3 = AnimationController(
    duration: const Duration(milliseconds: 7200),
    vsync: this,
  )..repeat(reverse: true);

  late AnimationController controller4 = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  );

  late final Animation anim1;

  late final Animation anim2;

  late final Animation anim3 =
      Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
    parent: controller3,
    curve: Curves.easeInOutBack,
  ));

  late final Animation anim4 =
      Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
    parent: controller4,
    curve: Curves.decelerate,
  ));

  @override
  void initState() {
    anim1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.ease,
      ),
    );
    anim2 = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: controller2,
      curve: Curves.linear,
    ));

    anim2.addListener(() async {
      path1.reset();
      path2.reset();
      path3.reset();

      path1.moveTo(0, 0);
      path1.lineTo(widget.width * 1, 0);
      path1.lineTo(widget.width, widget.height / 7);
      path1.cubicTo(
          widget.width / 10 * 8,
          widget.height / 7 / 10 * 15 + 24.w * anim1.value,
          widget.width / 10 * 3,
          widget.height / 7 / 10 * 5 + 32.w * anim2.value,
          0.0,
          widget.height / 7 / 10 * 4);

      path2.moveTo(0, 0);
      path2.lineTo(widget.width * 1, 0);
      path2.lineTo(widget.width, widget.height / 6);
      path2.cubicTo(
          widget.width / 10 * 8,
          widget.height / 6 / 10 * 20 + 24.w * anim2.value,
          widget.width / 10 * 3,
          widget.height / 6 / 10 * 5 + 40.w * anim3.value,
          0.0,
          widget.height / 7 / 10 * 4);

      path3.moveTo(0, 0);
      path3.lineTo(widget.width * 1, 0);
      path3.lineTo(widget.width, widget.height / 5);
      path3.cubicTo(
          widget.width / 10 * 8,
          widget.height / 6 / 10 * 25 + 24.w * anim3.value,
          widget.width / 10 * 3,
          widget.height / 5 / 10 * 5 + 40.w * anim1.value,
          0.0,
          widget.height / 7 / 10 * 4);
    });
    controller4.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: anim1,
        builder: (context, _) => CustomPaint(
              painter: _FogViewPainter(path1, path2, path3, anim4.value),
              size: Size(widget.width, widget.height),
            ));
  }
}

class _FogViewPainter extends CustomPainter {
  final Path path1;

  final Path path2;

  final Path path3;

  final double progress;

  _FogViewPainter(this.path1, this.path2, this.path3, this.progress);

  final _paint = Paint()
    ..color = const Color(0x33FFFFFF)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(0, -size.height * progress);
    canvas.drawPath(path1, _paint);
    canvas.drawPath(path2, _paint);
    canvas.drawPath(path3, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// 天气动画视图[多云]
class _CloudyView extends StatefulWidget {
  const _CloudyView({required this.width, required this.height});

  final double width;

  final double height;

  @override
  State<_CloudyView> createState() => _CloudyViewState();
}

class _CloudyViewState extends State<_CloudyView>
    with TickerProviderStateMixin {
  late AnimationController controller1 = AnimationController(
    duration: const Duration(milliseconds: 2500),
    vsync: this,
  )..repeat(reverse: true);

  late AnimationController controller2 = AnimationController(
    duration: const Duration(milliseconds: 3500),
    vsync: this,
  )..repeat(reverse: true);

  late AnimationController controller3 = AnimationController(
    duration: const Duration(milliseconds: 1200),
    vsync: this,
  );

  late final Animation anim1;

  late final Animation anim2;

  late final Animation anim3 =
      Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
    parent: controller3,
    curve: Curves.easeInOutBack,
  ));

  @override
  void initState() {
    anim1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.ease,
      ),
    );
    anim2 = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: controller2,
      curve: Curves.linear,
    ));
    controller3.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: anim1,
        builder: (context, _) => CustomPaint(
            painter: _CloudyViewPainter(
                enterProgress: anim3.value,
                fraction1: anim1.value,
                fraction2: anim2.value),
            size: Size(widget.width, widget.height)));
  }
}

class _CloudyViewPainter extends CustomPainter {
  double fraction1;

  double fraction2;

  double enterProgress;

  _CloudyViewPainter(
      {required this.fraction1,
      required this.fraction2,
      required this.enterProgress});

  final _paint = Paint()
    ..color = const Color(0x33FFFFFF)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, (-40).w);
    canvas.save();
    final centerX = size.width / 8 * 7;
    const centerY = 0.0;
    canvas.translate(centerX, centerY);
    _paint.color = const Color(0x80FFFFFF);
    canvas.drawCircle(const Offset(0, 0),
        size.width / 5 * enterProgress + (fraction2) * 16, _paint);

    canvas.translate(40.w, 0);
    _paint.color = const Color(0x26FFFFFF);
    canvas.drawCircle(const Offset(0, 0),
        size.width / 3 * enterProgress + (fraction1) * 10.w, _paint);
    canvas.restore();
    canvas.save();
    // =========
    canvas.translate(size.width / 2, 8);
    _paint.color = const Color(0x80FFFFFF);
    canvas.drawCircle(const Offset(0, 0),
        size.width / 5 * enterProgress + (fraction1) * 10.w, _paint);
    canvas.translate(10.w, -18.w);
    _paint.color = const Color(0x26FFFFFF);
    canvas.drawCircle(Offset.zero,
        size.width / 3 * enterProgress + (fraction2) * 24.w, _paint);
    canvas.restore();
    // = =====
    canvas.save();
    canvas.translate(size.width / 5 - 20.w, 12.w);
    _paint.color = const Color(0x80FFFFFF);
    canvas.drawCircle(Offset.zero,
        size.width / 5 * enterProgress + (fraction2) * 5.w, _paint);
    canvas.translate((-30).w, 0);
    _paint.color = const Color(0x26FFFFFF);
    canvas.drawCircle(Offset.zero,
        size.width / 3 * enterProgress + (fraction1) * 20.w, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CloudyViewPainter oldDelegate) {
    return oldDelegate.fraction1 != fraction1 ||
        oldDelegate.fraction2 != fraction2 ||
        oldDelegate.enterProgress != enterProgress;
  }
}
