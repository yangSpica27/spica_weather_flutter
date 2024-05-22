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

  final ScrollController _scrollController = ScrollController();

  final globalKey = GlobalKey<AnimatedListState>();

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
            child: Obx(() => ListView.builder(
                key: globalKey,
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    _itemCity(context, logic.data[index]),
                itemCount: logic.data.length)),
          )
        ],
      ),
    );
  }

  _addCityButton({GestureTapCallback? onTap}) => Container(
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
      );

  _itemCity(BuildContext context, CityData item) => Dismissible(
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
      child: Container(
        margin: EdgeInsets.only(bottom: 12.w),
        width: ScreenUtil().screenWidth - 32.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.w),
        decoration: BoxDecoration(
            color: item.weather?.todayWeather?.iconId?.getWeatherColor() ??
                Colors.blue[500],
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: context.theme.textTheme.headlineMedium
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(item.weather?.todayWeather?.weatherName ?? "暂无天气信息",
                style: context.theme.textTheme.headlineSmall
                    ?.copyWith(color: Colors.white)),
          ],
        ),
      ));

  @override
  void dispose() {
    Get.delete<CityListLogic>();
    super.dispose();
  }
}
