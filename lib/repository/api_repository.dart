import 'package:drift/drift.dart';
import 'package:spica_weather_flutter/database/database.dart';
import 'package:spica_weather_flutter/model/weather_response.dart';
import '../network/api_provider.dart';

/// The repository class that will be used to fetch data from the API.
class ApiRepository {


  static final apiProvider = ApiProvider();

  static fetchWeather() async {
    final List<CityData> cities = await AppDatabase.getInstance().city.select().get();
    for (final city in cities) {
      final response =
          await apiProvider.fetchWeather("${city.lon},${city.lat}");
      final WeatherResponse weatherResponse = WeatherResponse.fromJson(response.data);
      if (weatherResponse.code.toString() == "200") {
        await AppDatabase.getInstance().city.insertOne(
            CityCompanion.insert(
                name: city.name,
                lat: city.lat,
                lon: city.lon,
                weather: Value(weatherResponse.data)),mode: InsertMode.insertOrReplace);
        print("获取天气成功${weatherResponse}");
      } else {
        print("获取天气失败${weatherResponse}");
        throw Exception("获取天气失败${weatherResponse}");
      }
    }
  }
}
