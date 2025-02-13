import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spica_weather_flutter/routes/app_pages.dart';

import '../../../model/weather_response.dart';

class WarningCard extends StatefulWidget {
  const WarningCard({super.key, required this.weather});

  final WeatherResult weather;

  @override
  State<WarningCard> createState() => _WarningCardState();
}

class _WarningCardState extends State<WarningCard> {
  late final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    if (widget.weather.warnings == null || widget.weather.warnings!.isEmpty) {
      return Card(
          child: Padding(
        padding: EdgeInsets.all(15.w),
        child: const Text.rich(
          TextSpan(
            text: '暂无预警信息',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ));
    }
    final list = widget.weather.warnings!.map((e) => WarnItem(e)).toList();
    return Card(
        child: InkWell(
      onTap: () {
        Get.toNamed(Routes.ALERT_DETAIL,
            arguments: widget.weather.warnings ?? []);
      },
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          children: [
            SizedBox(
              height: 102.w,
              child: PageView(
                controller: pageController,
                children: list,
              ),
            ),
            Visibility(
                visible: list.length > 1,
                child: Padding(
                    padding: EdgeInsets.only(top: 10.w),
                    child: SmoothPageIndicator(
                        controller: pageController,
                        count: list.length,
                        effect: WormEffect(
                          dotHeight: 2.w,
                          dotWidth: 12.w,
                          radius: 2.w,
                          activeDotColor:
                              Theme.of(context).colorScheme.onSurface,
                          dotColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.3),
                        ))))
          ],
        ),
      ),
    ));
  }
}

class WarnItem extends StatelessWidget {
  final Warning e;

  const WarnItem(this.e, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          e.getShortTitle(),
          maxLines: 1,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(),
        ),
        Text(
          e.startTime ?? "",
          maxLines: 1,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.4),
              ),
        ),
        const Spacer(),
        Text(
          e.text ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.5),
              ),
        )
      ],
    );
  }
}
