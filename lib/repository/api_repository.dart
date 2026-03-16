import 'package:drift/drift.dart';
import 'package:spica_weather_flutter/database/database.dart';
import 'package:spica_weather_flutter/model/batch_weather_request.dart';

import '../network/api_provider.dart';

/// 天气数据仓库，使用批量接口一次请求所有城市天气
class ApiRepository {
  static final apiProvider = ApiProvider();

  /// 批量获取所有城市天气，单次 POST 替代原来的 N 次串行 GET
  static Future<void> fetchWeather() async {
    final List<CityData> cities =
        await AppDatabase.getInstance().city.select().get();

    if (cities.isEmpty) return;

    // 构建批量请求，用城市名作为 locationId（城市名是 DB 主键，全局唯一）
    final request = BatchWeatherRequest(
      locations: cities
          .map((city) => LocationRequest(
                locationId: city.name,
                longitude: city.lon,
                latitude: city.lat,
                name: city.name,
              ))
          .toList(),
    );

    final response = await apiProvider.fetchWeatherBatch(request);
    final batchResponse =
        BatchWeatherResponse.fromJson(response.data as Map<String, dynamic>);

    if (batchResponse.code != 200 || batchResponse.data == null) {
      throw Exception('批量天气请求失败：${batchResponse.message}');
    }

    // 按 locationId 建立索引，快速查找
    final resultMap = {
      for (final r in batchResponse.data!.results) r.locationId: r
    };

    final List<CityCompanion> weatherResults = [];
    for (final city in cities) {
      final result = resultMap[city.name];
      if (result == null || !result.success || result.data == null) {
        // 单个城市失败时跳过，不影响其他城市
        continue;
      }
      weatherResults.add(CityCompanion.insert(
        name: city.name,
        lat: city.lat,
        isLocation: city.isLocation,
        lon: city.lon,
        sort: city.sort,
        weather: Value(result.data!.toWeatherResult()),
      ));
    }

    if (weatherResults.isNotEmpty) {
      await AppDatabase.getInstance()
          .city
          .insertAll(weatherResults, mode: InsertMode.insertOrReplace);
    }
  }
}
