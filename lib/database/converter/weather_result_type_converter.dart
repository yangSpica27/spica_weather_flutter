import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:spica_weather_flutter/model/weather_response.dart';

class WeatherResultTypeConverter
    extends TypeConverter<WeatherResult?, String?> {
  const WeatherResultTypeConverter();

  @override
  WeatherResult? fromSql(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    return WeatherResult.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String? toSql(WeatherResult? value) {
    if (value == null) return "";
    return json.encode(value.toJson());
  }
}
