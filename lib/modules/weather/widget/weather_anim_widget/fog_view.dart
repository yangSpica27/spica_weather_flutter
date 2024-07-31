import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 天气动画视图[雾]
class FogView extends StatefulWidget {
  const FogView({required this.width, required this.height});

  final double width;

  final double height;

  @override
  State<FogView> createState() => _FogViewState();
}

class _FogViewState extends State<FogView> with TickerProviderStateMixin {
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
