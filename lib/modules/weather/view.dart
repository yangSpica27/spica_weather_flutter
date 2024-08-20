import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spica_weather_flutter/base/weather_type.dart';
import 'package:spica_weather_flutter/database/database.dart';
import 'package:spica_weather_flutter/modules/weather/widget/air_desc_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/daily_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/details_card_list_widget.dart';
import 'package:spica_weather_flutter/modules/weather/widget/hourly_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/now_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/precipitation_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/tip_card.dart';
import 'package:spica_weather_flutter/modules/weather/widget/warning_card.dart';
import 'package:spica_weather_flutter/routes/app_pages.dart';
import 'package:spica_weather_flutter/widget/enter_page_anim_widget.dart';

import 'logic.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with TickerProviderStateMixin {
  final logic = Get.find<WeatherLogic>();

  late final PageController pageController = PageController(keepPage: false);

  late TabController tabController = TabController(length: 1, vsync: this);

  @override
  Widget build(BuildContext context) {
    logic.data.listen((p0) {
      tabController = TabController(length: p0.length, vsync: this);
      pageController.jumpToPage(0);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() {
          return Text((logic.data.isNotEmpty &&
                  logic.pageIndex.value < logic.data.length)
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
                  child: TabPageSelector(
                controller: tabController,
                color: const Color(0x21000000),
                selectedColor: Colors.black87,
              )),

              /// 内容区
              Expanded(
                flex: 1,
                child: PageView(
                  onPageChanged: (index) {
                    if (index < tabController.length) {
                      tabController.animateTo(index);
                    }
                    logic.pageIndex.value = index;
                  },
                  controller: pageController,
                  children: logic.data
                      .map((element) => element.weather == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : InfoListWidget(data: element, physics: physics))
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
    super.dispose();
  }
}

class InfoListWidget extends StatelessWidget {
  const InfoListWidget({super.key, required this.data, this.physics});

  final CityData data;

  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final items = [
      NowCard(
        key: UniqueKey(),
        weather: data.weather!,
      ),
      HourlyCard(weather: data.weather!),
      DailyCard(weather: data.weather!),
      AirDescCard(weather: data.weather!),
      DetailsCardListWidget(weather: data.weather!),
      TipCard(weather: data.weather!),
      EnterPageAnimWidget(
          startOffset: Offset(0, -8.w),
          delay: const Duration(milliseconds: 200),
          child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                      text: "数据来源于", style: TextStyle(color: Colors.black87)),
                  WidgetSpan(
                      child: SizedBox(
                    width: 8,
                  )),
                  WidgetSpan(
                    child: Icon(
                      Ionicons.cloud_circle,
                      size: 15,
                    ),
                    alignment: PlaceholderAlignment.middle,
                  ),
                  WidgetSpan(
                      child: SizedBox(
                    width: 2,
                  )),
                  TextSpan(
                    text: "和风天气",
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
                ],
              ))),
    ];

    if (data.weather?.warnings != null &&
        data.weather?.warnings?.isNotEmpty == true) {
      items.insert(1, WarningCard(weather: data.weather!));
    }

    if (data.weather?.todayWeather?.iconId
                ?.getWeatherType()
                .getWeatherAnimType() ==
            WeatherAnimType.RAIN &&
        data.weather?.minutely != null) {
      items.insert(1, PrecipitationCard(weather: data.weather!));
    }

    return ListView.separated(
        physics: physics,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.w),
        itemBuilder: (context, index) => items[index],
        separatorBuilder: (context, index) => Divider(
              height: 8.w,
              color: Colors.transparent,
            ),
        itemCount: items.length);
  }
}
