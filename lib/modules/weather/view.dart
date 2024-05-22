import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spica_weather_flutter/modules/weather/widget/air_desc_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/daily_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/hourly_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/now_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/tip_card.dart';
import 'package:spica_weather_flutter/routes/app_pages.dart';

import 'logic.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with TickerProviderStateMixin {
  final logic = Get.find<WeatherLogic>();

  final PageController pageController = PageController(keepPage: true);

  late TabController tabController = TabController(length: 1, vsync: this);

  @override
  Widget build(BuildContext context) {
    pageController.addListener(() {
      logic.pageIndex.value = pageController.page?.round() ?? 0;
    });

    logic.data.listen((p0) {
      tabController = TabController(length: p0.length, vsync: this);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() {
          return Text(logic.data.isNotEmpty
              ? logic.data[logic.pageIndex.value].name
              : '');
        }),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Get.toNamed(Routes.CITY_LIST);
          },
        ),
      ),
      body: EasyRefresh.builder(
        onRefresh: () async {
          await logic.loadData();
        },
        onLoad: () async {
          await logic.loadData();
        },
        childBuilder: (context, physics) => Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Obx(() => TabPageSelector(
                      controller: tabController
                        ..animateTo(logic.pageIndex.value),
                      color: const Color(0x21000000),
                      selectedColor: Colors.black87,
                    )),
              ),
              Expanded(
                flex: 1,
                child: PageView(
                  controller: pageController,
                  children: logic.data
                      .map((element) => element.weather == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView(
                              physics: physics,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 12.w),
                              children: [
                                NowCard(weather: element.weather!),
                                SizedBox(
                                  height: 12.w,
                                ),
                                HourlyCard(weather: element.weather!),
                                SizedBox(
                                  height: 12.w,
                                ),
                                DailyCard(weather: element.weather!),
                                SizedBox(
                                  height: 12.w,
                                ),
                                AirDescCard(weather: element.weather!),
                                SizedBox(
                                  height: 12.w,
                                ),
                                TipCard(weather: element.weather!),
                                SizedBox(
                                  height: 12.w,
                                ),
                                const Text(
                                  "数据来自和风天气",
                                  style: TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 20.w,
                                ),
                              ],
                            ))
                      .toList(),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<WeatherLogic>();
    pageController.dispose();
    tabController.dispose();
    super.dispose();
  }
}
