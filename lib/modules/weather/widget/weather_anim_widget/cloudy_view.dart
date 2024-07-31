import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 天气动画视图[多云]
class CloudyView extends StatefulWidget {
  const CloudyView({super.key, required this.width, required this.height});

  final double width;

  final double height;

  @override
  State<CloudyView> createState() => _CloudyViewState();
}

class _CloudyViewState extends State<CloudyView> with TickerProviderStateMixin {
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
