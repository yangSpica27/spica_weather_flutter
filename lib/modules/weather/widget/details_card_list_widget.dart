import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spica_weather_flutter/model/weather_response.dart';
import 'package:spica_weather_flutter/widget/enter_page_anim_widget.dart';

/// 补充信息
class DetailsCardListWidget extends StatelessWidget {
  final WeatherResult weather;

  const DetailsCardListWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      EnterPageAnimWidget(
          startScale: 0,
          duration: const Duration(milliseconds: 1200),
          child: UvCard(
            uv: double.tryParse(weather.dailyWeather?.first.uv ?? "0xFF"),
          )),
      EnterPageAnimWidget(
          startScale: 0,
          duration: const Duration(milliseconds: 800),
          child: HumidnessCard(
            humidness: weather.todayWeather?.water,
          )),
      EnterPageAnimWidget(
          startScale: 0,
          duration: const Duration(milliseconds: 650),
          child: FeelCard(
            feelTemp: weather.todayWeather?.feelTemp,
          )),
      EnterPageAnimWidget(
          startScale: 0,
          duration: const Duration(milliseconds: 850),
          child: SunriseCard(
            sunrise: weather.dailyWeather?.first.sunriseDate,
            sunSet: weather.dailyWeather?.first.sunsetDate,
          ))
    ];
    // return Container();

    return GridView.count(
      shrinkWrap: true,
      crossAxisSpacing: 8.w,
      childAspectRatio: 0.95,
      mainAxisSpacing: 8.w,
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      children: items,
      // itemCount: items.length,
      // builder: (context, index) {
      //   return items[index];
      // },
    );
  }
}

/// 日出日落
class SunriseCard extends StatelessWidget {
  const SunriseCard({super.key, required this.sunrise, required this.sunSet});

  final String? sunrise;

  final String? sunSet;

  @override
  Widget build(BuildContext context) {
    return ItemWidget(
        title: "日出日落",
        value: "",
        value2: "日出：$sunrise\n日落：$sunSet",
        icon: Icons.contrast_sharp,
        needSpacer: false,
        bottomWidget: Expanded(
          flex: 1,
          child: SunriseWidget(
            startTime: sunrise ?? "",
            endTime: sunSet ?? "",
          ),
        ));
  }
}

/// 体感信息
class FeelCard extends StatelessWidget {
  const FeelCard({super.key, required this.feelTemp});

  final int? feelTemp;

  String getFeelTempDesc() {
    if (feelTemp == null) return "";
    if (feelTemp! < 0) {
      return "寒冷，注意保暖";
    } else if (feelTemp! < 10) {
      return "冷，注意保暖";
    } else if (feelTemp! < 20) {
      return "凉爽，适合户外活动";
    } else if (feelTemp! < 26) {
      return "舒适，适合户外活动";
    } else if (feelTemp! < 35) {
      return "炎热，注意防暑";
    } else {
      return "酷热，注意防暑";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ItemWidget(
      title: "体感温度",
      value: feelTemp != null ? "$feelTemp℃" : "--",
      icon: Icons.settings_accessibility_outlined,
      bottomWidget: Container(
        padding: EdgeInsets.only(bottom: 6.w),
        child: _BottomAnimLineWidget(
            mode: 3, progress: min(max((feelTemp ?? 0) / 40.0, 0), 1)),
      ),
      value2: getFeelTempDesc(),
    );
  }
}

/// 湿度信息
class HumidnessCard extends StatelessWidget {
  const HumidnessCard({super.key, required this.humidness});

  final int? humidness;

  String getHumidnessLevel() {
    if (humidness == null) return "--";
    if (humidness! < 30) {
      return "干燥，注意补水";
    } else if (humidness! < 60) {
      return "舒适";
    } else {
      return "潮湿,体感温度会更高";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ItemWidget(
      title: "湿度",
      value: humidness != null ? "$humidness%" : "--",
      icon: Icons.grain_outlined,
      value2: getHumidnessLevel(),
      bottomWidget: Container(
        padding: EdgeInsets.only(bottom: 6.w),
        child:
            _BottomAnimLineWidget(mode: 1, progress: (humidness ?? 0) / 100.0),
      ),
    );
  }
}

/// 紫外线强度信息
class UvCard extends StatelessWidget {
  const UvCard({super.key, required this.uv});

  final double? uv;

  String getUvLevel() {
    if (uv == null) return "--";
    if (uv! < 3) {
      return "弱";
    } else if (uv! < 6) {
      return "中等";
    } else if (uv! < 8) {
      return "强";
    } else if (uv! < 11) {
      return "很强";
    } else {
      return "极强";
    }
  }

  String getUvDetail() {
    if (uv == null) return "--";
    if (uv! < 3) {
      return "不需采取防护措施";
    } else if (uv! < 6) {
      return "对人体影响不大，可不采取防护措施";
    } else if (uv! < 8) {
      return "外出应采取防护措施，要用遮阳伞、涂擦防晒霜等";
    } else {
      return "外出应特别注意防护，中午前后宜减少外出";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ItemWidget(
        title: "紫外线",
        icon: Icons.wb_sunny_outlined,
        value: getUvLevel(),
        value2: getUvDetail(),
        bottomWidget: Container(
          padding: EdgeInsets.only(bottom: 6.w),
          child: _BottomAnimLineWidget(
              mode: 2, progress: min((uv ?? 0) / 12.0, 1.0)),
        ));
  }
}

class ItemWidget extends StatelessWidget {
  // 标题图标
  final IconData icon;

  // 标题
  final String title;

  // 值1
  final String value;

  // 值2
  final String value2;

  // 可选 底部自定义View
  final Widget? bottomWidget;

  // 是否需要中部填充
  final bool needSpacer;

  const ItemWidget(
      {super.key,
      required this.title,
      required this.value,
      this.value2 = "",
      this.icon = Icons.wb_sunny_outlined,
      this.bottomWidget = const Spacer(),
      this.needSpacer = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            EnterPageAnimWidget(
              duration: const Duration(milliseconds: 650),
              delay: const Duration(milliseconds: 150),
              startOffset: const ui.Offset(0, .2),
              child: Text.rich(TextSpan(children: [
                WidgetSpan(
                    child: Icon(
                      icon,
                      size: 14.w,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(.5),
                    ),
                    alignment: PlaceholderAlignment.middle),
                const WidgetSpan(
                  child: SizedBox(
                    width: 2,
                  ),
                ),
                TextSpan(
                    text: title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.5),
                        )),
              ])),
            ),
            SizedBox(
              height: 6.w,
            ),
            value == ""
                ? const SizedBox()
                : EnterPageAnimWidget(
                    delay: const Duration(milliseconds: 250),
                    duration: const Duration(milliseconds: 550),
                    startOffset: const ui.Offset(.2, 0),
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                    )),
            needSpacer ? const Spacer() : const SizedBox(),
            bottomWidget == null ? const SizedBox() : bottomWidget!,
            EnterPageAnimWidget(
              duration: const Duration(milliseconds: 950),
              delay: const Duration(milliseconds: 550),
              startOffset: const ui.Offset(.1, 0),
              child: Text(
                value2,
                maxLines: 4,
                softWrap: true,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(.5),
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// 底部进度组件
class _BottomAnimLineWidget extends StatefulWidget {
  const _BottomAnimLineWidget({required this.mode, required this.progress});

  final int mode; // 模式 1:湿度 2:紫外线 3:体感温度

  final double progress; // 最终进度

  @override
  State<_BottomAnimLineWidget> createState() => _BottomAnimLineWidgetState();
}

class _BottomAnimLineWidgetState extends State<_BottomAnimLineWidget>
    with SingleTickerProviderStateMixin {
  // 入场动画指示器
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  );

  late final Animation<double> anim;

  double currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    anim = Tween(begin: 0.0, end: widget.progress.toDouble()).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    )..addListener(() {
        currentProgress = anim.value;
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (widget.mode == 1) {
            return CustomPaint(
                size: ui.Size(0, 12.w),
                painter: _WaterLinePainter(
                    lowerLimit: 0,
                    upperLimit: 100,
                    currentWater: (currentProgress * 100).toInt(),
                    progress: 1));
          } else if (widget.mode == 2) {
            return CustomPaint(
              painter: _UvLinePainter(currentProgress),
              size: ui.Size(0, 12.w),
            );
          } else if (widget.mode == 3) {
            return CustomPaint(
              painter: _FeelLinePainter(currentProgress),
              size: ui.Size(0, 12.w),
            );
          }
          return Container();
        });
  }
}

class _FeelLinePainter extends CustomPainter {
  // 动画的进度
  double progress;

  _FeelLinePainter(this.progress);

  final ui.Paint _paint = ui.Paint()
    ..color = Colors.grey[300]!
    ..strokeWidth = 6.w
    ..strokeCap = StrokeCap.round;

  final ui.Paint _pointPaint = ui.Paint()
    ..color = Colors.grey[300]!
    ..strokeWidth = 6.w
    ..strokeCap = StrokeCap.round;

  final savePaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, savePaint);
    // 零下到18°人体感觉温度冷的区段
    _paint.blendMode = BlendMode.srcOver;
    _paint.color = Colors.blue[400]!;
    _paint.strokeCap = StrokeCap.round;
    _paint.strokeWidth = 6.w;
    canvas.drawLine(ui.Offset(0, size.height / 2),
        ui.Offset(size.width * 0.45, size.height / 2), _paint);

    // 18°到24°人体感觉温度舒适的区段
    _paint.strokeCap = StrokeCap.round;
    _paint.color = Colors.green[400]!;
    canvas.drawLine(ui.Offset(size.width * 0.45, size.height / 2),
        ui.Offset(size.width * 0.625, size.height / 2), _paint);

    // 零下到18°人体感觉温度热的区段
    _paint.strokeCap = StrokeCap.square;
    _paint.color = Colors.orangeAccent[400]!;
    canvas.drawLine(ui.Offset(size.width * 0.625, size.height / 2),
        ui.Offset(size.width, size.height / 2), _paint);

    _paint.color = Colors.transparent;
    _paint.blendMode = BlendMode.srcIn;
    _paint.strokeWidth = 3.w;
    // 分割线
    canvas.drawLine(
        ui.Offset(size.width * 0.625 - _paint.strokeWidth, 0),
        ui.Offset(size.width * 0.625 - _paint.strokeWidth, size.height),
        _paint);

    canvas.drawLine(ui.Offset(size.width * 0.45 - _paint.strokeWidth, 0),
        ui.Offset(size.width * 0.45 - _paint.strokeWidth, size.height), _paint);
    canvas.restore();

    // 画点
    if (progress < 0.45) {
      _pointPaint.color = Colors.blue[400]!;
    } else if (progress < 0.625) {
      _pointPaint.color = Colors.green[400]!;
    } else {
      _pointPaint.color = Colors.orangeAccent[400]!;
    }
    // 指示器
    canvas.drawLine(
        ui.Offset(size.width * progress - _pointPaint.strokeWidth, 0),
        ui.Offset(size.width * progress - _pointPaint.strokeWidth, size.height),
        _pointPaint);
  }

  @override
  bool shouldRepaint(covariant _FeelLinePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _UvLinePainter extends CustomPainter {
  // 动画的进度
  double progress;

  _UvLinePainter(this.progress);

  // 渐变色
  ui.Gradient? gradient;

  // 线条paint
  final Paint _paint = Paint()
    ..color = Colors.grey[300]!
    ..strokeWidth = 6.w
    ..strokeCap = StrokeCap.round;

  final Paint _pointPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 2.w
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    gradient ??= ui.Gradient.linear(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), [
      Colors.green[400]!,
      Colors.yellow[500]!,
      Colors.orangeAccent[200]!,
      Colors.red[400]!,
      Colors.purple[400]!
    ], [
      0.15,
      0.3,
      0.6,
      0.85,
      1
    ]);

    _paint.shader = gradient;
    canvas.drawLine(ui.Offset(0, size.height / 2),
        ui.Offset(size.width, size.height / 2), _paint);

    _paint.blendMode = BlendMode.srcOver;

    _pointPaint.color = Colors.white;
    _pointPaint.style = PaintingStyle.fill;
    canvas.drawCircle(
        ui.Offset(size.width * progress, size.height / 2), 6.w, _pointPaint);

    if (progress <= 0.15) {
      _pointPaint.color = Colors.green[400]!;
    } else if (progress <= 0.3) {
      _pointPaint.color = Colors.yellow[500]!;
    } else if (progress <= 0.6) {
      _pointPaint.color = Colors.orangeAccent[200]!;
    } else if (progress <= 0.85) {
      _pointPaint.color = Colors.red[400]!;
    } else {
      _pointPaint.color = Colors.purple[400]!;
    }
    _pointPaint.style = PaintingStyle.fill;
    canvas.drawCircle(
        ui.Offset(size.width * progress, size.height / 2), 4.w, _pointPaint);
  }

  @override
  bool shouldRepaint(covariant _UvLinePainter oldDelegate) =>
      progress != oldDelegate.progress;
}

/// 湿度渐变色条Painter
class _WaterLinePainter extends CustomPainter {
  // 下限湿度
  int lowerLimit;

  // 上限湿度
  int upperLimit;

  // 当前湿度
  int? currentWater;

  int get diff => upperLimit - lowerLimit;

  // 渐变色
  ui.Gradient? gradient;

  // 动画的进度
  double progress;

  _WaterLinePainter(
      {required this.lowerLimit,
      required this.upperLimit,
      this.currentWater,
      this.progress = 1});

  final Paint _paint = Paint()
    ..color = Colors.grey[300]!
    ..strokeWidth = 6.w
    ..strokeCap = StrokeCap.round;

  final Paint _bgPaint = Paint()
    ..color = Colors.grey[300]!
    ..strokeWidth = 6.w
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    gradient ??= ui.Gradient.linear(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), [
      Colors.lightBlue[100]!,
      Colors.lightBlue[200]!,
      Colors.lightBlue[400]!,
      Colors.blue[400]!
    ], [
      0.25,
      0.5,
      0.75,
      1
    ]);
    _paint.shader = gradient;
    canvas.drawLine(ui.Offset(0, size.height / 2),
        ui.Offset(size.width, size.height / 2), _bgPaint);
    if (currentWater == null) return;
    double x = size.width * (currentWater! - lowerLimit) / diff;
    canvas.drawLine(
        ui.Offset(0, size.height / 2), ui.Offset(x, size.height / 2), _paint);
  }

  @override
  bool shouldRepaint(covariant _WaterLinePainter oldDelegate) =>
      currentWater != oldDelegate.currentWater;
}

/// 日出日落组件
class SunriseWidget extends StatefulWidget {
  const SunriseWidget({super.key, this.startTime = "", this.endTime = ""});

  final String startTime;

  final String endTime;

  @override
  State<SunriseWidget> createState() => _SunriseWidgetState();
}

class _SunriseWidgetState extends State<SunriseWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final Animation<double> anim;

  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, widget) => CustomPaint(
              painter: _SunrisePainter(progress),
              size: Size(0, 22.w),
            ));
  }

  @override
  void initState() {
    super.initState();

    try {
      DateTime now = DateTime.now();
      DateTime sunriseTime = DateTime.parse(
          "${now.toIso8601String().split("T").first} ${widget.startTime}:00");

      DateTime sunsetTime = DateTime.parse(
          "${now.toIso8601String().split("T").first} ${widget.endTime}:00");

      const double begin = .1;

      double end = .9;

      if (now.isBefore(sunriseTime)) return;

      if (now.isAfter(sunsetTime)) return;

      end = (now.millisecondsSinceEpoch - sunriseTime.millisecondsSinceEpoch) /
          (sunsetTime.millisecondsSinceEpoch -
              sunriseTime.millisecondsSinceEpoch);

      anim = Tween(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ),
      )..addListener(() {
          progress = anim.value;
        });
      _controller.forward();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SunrisePainter extends CustomPainter {
  final double progress;

  _SunrisePainter(this.progress);

  final Paint _paint = Paint()
    ..color = Colors.grey[350]!
    ..strokeWidth = 3.w
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final Paint _pointPaint = Paint()
    ..color = Colors.grey[400]!
    ..strokeWidth = 6.w
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round;

  final startAngle = pi / 180 * (180 + 20);

  final endAngle = pi / 180 * (180 + (180 - 20));

  late final sweepAngle = endAngle - startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    // 轨迹弧
    _paint.color = Colors.grey[350]!;
    canvas.drawArc(Rect.fromLTRB(0, size.height / 2, size.width, size.height),
        pi / 180 * (180 + 20), sweepAngle, false, _paint);

    if (progress <= 0) return;

    if (progress >= 1) return;

    // 画点
    final double x = size.width * progress;

    double y = calculateY(
        Rect.fromLTRB(0, size.height / 2, size.width, size.height), x);

    final centerY = size.height / 4 * 3;

    y = centerY + (centerY - y);

    _pointPaint.color = Colors.grey[350]!;
    canvas.drawCircle(ui.Offset(x, y), 10.w, _pointPaint);
    _pointPaint.color = Colors.grey[500]!;
    canvas.drawCircle(ui.Offset(x, y), 6.w, _pointPaint);
  }

  //  获取Y坐标高度
  double calculateY(Rect rect, double x) {
    final double h = rect.center.dx;
    final double k = rect.center.dy;
    final double a = rect.width / 2;
    final double b = rect.height / 2;
    final double y = sqrt(pow(b, 2) * (1 - pow(x - h, 2) / pow(a, 2))) + k;

    return y;
  }

  @override
  bool shouldRepaint(covariant _SunrisePainter oldDelegate) =>
      progress != oldDelegate.progress;
}
