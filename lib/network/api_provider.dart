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
      ..interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ));
  }

  Future<Response> fetchWeather(String lonlat) {
    return dio
        .get(Api.API_FETCH_WEATHER, queryParameters: {'location': lonlat});
  }
}
