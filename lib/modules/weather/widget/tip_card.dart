import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spica_weather_flutter/base/weather_type.dart';
import '../../../model/weather_response.dart';

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
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: weather.todayWeather?.iconId?.getWeatherColor() ?? Colors.blue[500]),
            ),
            SizedBox(
              height: 12.w,
            ),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.w),
              children: weather.lifeIndexes
                      ?.map((e) =>
                          _buildItem(context, e.name ?? "", e.category ?? ""))
                      .toList() ??
                  [],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, String subtitle) =>
      Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
            color: const Color(0x1a4a4a4a),
            borderRadius: BorderRadius.circular(8.w)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      );
}
