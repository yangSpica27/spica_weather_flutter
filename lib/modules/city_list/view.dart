import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spica_weather_flutter/base/weather_type.dart';
import 'package:spica_weather_flutter/database/database.dart';
import 'package:spica_weather_flutter/routes/app_pages.dart';

import 'logic.dart';

/// 城市列表
class CityListPage extends StatefulWidget {
  const CityListPage({super.key});

  @override
  State<CityListPage> createState() => _CityListPageState();
}

class _CityListPageState extends State<CityListPage> {
  final logic = Get.find<CityListLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('城市列表'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _addCityButton(onTap: () {
            Get.toNamed(Routes.CITY_SELECTOR);
          }),
          Expanded(
            flex: 1,
            child: Obx(() => ReorderableListView.builder(
                onReorder: (oldIndex, newIndex) async {
                  await logic.reorderCity(oldIndex, newIndex);
                },
                onReorderStart: (index) {
                  logic.isSort.value = true;
                },
                onReorderEnd: (newIndex) {
                  logic.isSort.value = false;
                },
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                proxyDecorator: (widget, index, animation) {
                  return AnimatedBuilder(
                      animation: animation,
                      builder: (BuildContext context, Widget? child) {
                        final double animValue =
                            Curves.easeInOut.transform(animation.value);
                        return Transform.scale(
                          scale: 1 + .05 * animValue,
                          child: widget,
                        );
                      });
                },
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    _itemCity(context, logic.data[index]),
                itemCount: logic.data.length)),
          ),
          SizedBox(
            height: 12.w,
          ),
          Text("长按拖动城市排序,向左侧滑删除城市",
              textAlign: TextAlign.center,
              style: context.theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[500],
              )),
          SizedBox(
            height: 12.w,
          )
        ],
      ),
    );
  }

  _addCityButton({GestureTapCallback? onTap}) => Hero(
      tag: "search_bar",
      transitionOnUserGestures: true,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.grey[500],
              ),
              SizedBox(
                width: 8.w,
              ),
              Text("添加城市",
                  style: context.theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[500],
                  ))
            ],
          ),
        ),
      ));

  _itemCity(BuildContext context, CityData item) => Dismissible(
        direction: DismissDirection.endToStart,
        key: Key(item.name),
        background: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            color: Colors.black87,
          ),
        ),
        onDismissed: (direction) async {
          await logic.removeCity(item);
        },
        child: _ShakeContent(
            needShake: logic.isSort.value,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.w),
              width: ScreenUtil().screenWidth - 32.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.w),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: logic.isSort.value
                          ? Colors.grey[500]!
                          : Colors.transparent),
                  color:
                      item.weather?.todayWeather?.iconId?.getWeatherColor() ??
                          Colors.blue[500],
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Row(mainAxisSize: MainAxisSize.max, children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: context.theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                        "${item.weather?.todayWeather?.weatherName ?? "/"} 体感${item.weather?.todayWeather?.feelTemp ?? "NA"}℃",
                        style: context.theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
                const Spacer(),
                Text(
                  "${item.weather?.todayWeather?.temp.toString() ?? "--"}℃",
                  style: context.theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 38.sp),
                ),
              ]),
            )),
      );

  @override
  void dispose() {
    Get.delete<CityListLogic>();
    super.dispose();
  }
}

class _ShakeContent extends StatefulWidget {
  const _ShakeContent(
      {super.key, required this.needShake, required this.child});

  final bool needShake;

  final Widget child;

  @override
  State<_ShakeContent> createState() => _ShakeContentState();
}

class _ShakeContentState extends State<_ShakeContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 50),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _shakeAnim = Tween<double>(begin: -.6, end: .6)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.needShake) {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
      }
    } else {
      if (_controller.isAnimating) {
        _controller.stop();
      }
    }
    return AnimatedBuilder(
        animation: _shakeAnim,
        builder: (context, _) => Transform.rotate(
              angle: widget.needShake ? (_shakeAnim.value * pi / 180) : 0,
              child: widget.child,
            ));
  }
}
