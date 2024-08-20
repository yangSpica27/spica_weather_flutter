import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spica_weather_flutter/base/weather_type.dart';
import 'package:spica_weather_flutter/modules/weather/widget/fixed_grid_view/fixed_height_grid_view.dart';
import 'package:spica_weather_flutter/widget/enter_page_anim_widget.dart';

import '../../../model/weather_response.dart';

/// 生活指数卡片
class TipCard extends StatelessWidget {
  const TipCard({super.key, required this.weather});

  final WeatherResult weather;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "生活指数",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: weather.todayWeather?.iconId?.getWeatherColor() ??
                      Colors.blue[500]),
            ),
            SizedBox(
              height: 12.w,
            ),
            FixedHeightGridView(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 10.w,
                crossAxisSpacing: 10.w,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: weather.lifeIndexes?.length ?? 0,
                builder: (context, index) {
                  final item = weather.lifeIndexes![index];
                  return EnterPageAnimWidget(
                      delay: Duration(milliseconds: 150 * index),
                      startOpacity: 0,
                      duration: const Duration(milliseconds: 300),
                      startOffset: Offset(12.w, 0),
                      child: _TipItemWidget(
                          title: item.name ?? "",
                          subtitle: item.category ?? ""));
                }),
          ],
        ),
      ),
    );
  }
}

/// 生活指数ItemWidget
class _TipItemWidget extends StatelessWidget {
  const _TipItemWidget({required this.title, required this.subtitle});

  final String title;

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
          color: const Color(0x1a4a4a4a),
          borderRadius: BorderRadius.circular(8.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey[900]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Divider(
            height: 6.w,
            color: Colors.transparent,
          ),
          Text(
            subtitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
        ],
      ),
    );
  }
}
