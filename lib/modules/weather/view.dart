import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spica_weather_flutter/modules/weather/widget/air_desc_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/daily_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/details_card_list_widget.dart';
import 'package:spica_weather_flutter/modules/weather/widget/hourly_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/now_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/tip_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/warning_card.dart';
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

  late final PageController pageController = PageController(keepPage: false)
    ..addListener(() {
      logic.pageIndex.value = pageController.page?.round() ?? 0;
    });

  late TabController tabController = TabController(length: 1, vsync: this);

  @override
  Widget build(BuildContext context) {
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
              /// TabPageSelector指示器
              Center(
                child: Obx(() => TabPageSelector(
                      controller: tabController
                        ..animateTo(logic.pageIndex.value),
                      color: const Color(0x21000000),
                      selectedColor: Colors.black87,
                    )),
              ),

              /// 内容区
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
                                NowCard(
                                  weather: element.weather!,
                                ),
                                Visibility(
                                    visible: element.weather!.warnings !=
                                            null &&
                                        element.weather!.warnings!.isNotEmpty,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 12.w),
                                      child: WarningCard(
                                          weather: element.weather!),
                                    )),
                                SizedBox(
                                  height: 8.w,
                                ),
                                HourlyCard(weather: element.weather!),
                                SizedBox(
                                  height: 8.w,
                                ),
                                DailyCard(weather: element.weather!),
                                SizedBox(
                                  height: 8.w,
                                ),
                                AirDescCard(weather: element.weather!),
                                SizedBox(
                                  height: 8.w,
                                ),
                                DetailsCardListWidget(
                                    weather: element.weather!),
                                SizedBox(
                                  height: 8.w,
                                ),
                                TipCard(weather: element.weather!),
                                SizedBox(
                                  height: 8.w,
                                ),
                                RichText(
                                    textAlign: TextAlign.center,
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "数据来源于",
                                            style: TextStyle(
                                                color: Colors.black87)),
                                        WidgetSpan(child: SizedBox(width: 8,)),
                                        WidgetSpan(child: Icon(Ionicons.cloud_circle,size: 15,),alignment: PlaceholderAlignment.middle,),
                                        WidgetSpan(child: SizedBox(width: 2,)),
                                        TextSpan(
                                          text: "和风天气",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
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
