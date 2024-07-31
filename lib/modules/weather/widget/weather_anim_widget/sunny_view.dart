import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 天气动画视图[晴天]
class SunnyView extends StatefulWidget {
  const SunnyView(this.width, this.height, {super.key});

  final double width;

  final double height;

  @override
  State<SunnyView> createState() => _SunnyViewState();
}

class _SunnyViewState extends State<SunnyView> with TickerProviderStateMixin {
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
