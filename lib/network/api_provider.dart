import 'package:dio/dio.dart';
import 'package:spica_weather_flutter/base/api.dart';
import 'package:spica_weather_flutter/model/batch_weather_request.dart';

class ApiProvider {
  static final ApiProvider _singleton = ApiProvider._internal();
  static final dio = Dio();

  factory ApiProvider() {
    return _singleton;
  }

  ApiProvider._internal() {
    dio
      ..options.responseType = ResponseType.json
      ..options.connectTimeout = const Duration(seconds: 10)
      ..options.receiveTimeout = const Duration(seconds: 15)
      ..interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ));
  }

  /// 批量获取多个城市天气（一次请求）
  Future<Response> fetchWeatherBatch(BatchWeatherRequest request) {
    return dio.post(
      Api.batchWeatherUrl,
      data: request.toJson(),
      options: Options(contentType: 'application/json'),
    );
  }

  /// 获取城市信息（逆地理编码）
  Future<Response> fetchCity(String lonlat) {
    return dio.get(Api.reGeoUrl, queryParameters: {
      'key': "2a83c54e436dbb1702e9b1b2718c110b",
      'location': lonlat,
      'output': 'json'
    });
  }
}
