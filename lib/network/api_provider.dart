import 'package:dio/dio.dart';
import 'package:spica_weather_flutter/base/api.dart';

class ApiProvider {
  static final ApiProvider _singleton = ApiProvider._internal();
  static final dio = Dio();

  factory ApiProvider() {
    return _singleton;
  }

  ApiProvider._internal() {
    dio
      ..options.responseType = ResponseType.json
      ..options.connectTimeout=const Duration(seconds: 10)
      ..interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ));
  }

  Future<Response> fetchWeather(String lonlat) {
    return dio
        .get(Api.weatherUrl, queryParameters: {'location': lonlat});
  }

  Future<Response> fetchCity(String lonlat) {
    return dio.get(Api.reGeoUrl, queryParameters: {
      'key': "2a83c54e436dbb1702e9b1b2718c110b",
      'location': lonlat,
      'output': 'json'
    });
  }
}
