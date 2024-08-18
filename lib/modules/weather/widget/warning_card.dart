import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../model/weather_response.dart';

class WarningCard extends StatelessWidget {
  const WarningCard({super.key, required this.weather});

  final WeatherResult weather;

  @override
  Widget build(BuildContext context) {
    if (weather.warnings == null || weather.warnings!.isEmpty) {
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
    return Card(
        child: Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        children:
            weather.warnings?.map((e) => _warnItem(e, context)).toList() ?? [],
      ),
    ));
  }

  Widget _warnItem(Warning warning, BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          warning.title ?? "",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        tilePadding: EdgeInsets.zero,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 12.w,
          ),
          Text(
            "开始时间 ${warning.startTime}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: 12.w,
          ),
          Text(
            warning.text ?? "",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: 12.w,
          ),
          Text(
            "来源:${warning.sender}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: 12.w,
          )
        ],
      ),
    );
  }
//
// String formatMinutesAgo(DateTime pastTime) {
//   final now = DateTime.now();
//   final minutesAgo = now.difference(pastTime).inMinutes;
//   if (minutesAgo < 1) {
//     return '几秒前';
//   } else if (minutesAgo < 60) {
//     return '$minutesAgo分钟前';
//   } else {
//     return '${minutesAgo ~/ 60}小时前';
//   }
// }
}
