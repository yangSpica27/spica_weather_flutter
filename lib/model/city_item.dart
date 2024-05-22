import 'package:drift/drift.dart';
import 'package:spica_weather_flutter/database/database.dart';

/// json文件对象
class Province {
  String? name;
  String? log;
  String? lat;
  List<CityItem>? children;

  Province({this.name, this.log, this.lat, this.children});

  Province.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    log = json['log'];
    lat = json['lat'];
    if (json['children'] != null) {
      children = <CityItem>[];
      json['children'].forEach((v) {
        children!.add(CityItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['log'] = this.log;
    data['lat'] = this.lat;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityItem {
  String? name;
  String? log;
  String? lat;
  String? weather;

  CityItem(
      {required this.name,
      required this.log,
      required this.lat,
      required this.weather});

  CityItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    log = json['log'];
    lat = json['lat'];
    weather = json['weather'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['log'] = this.log;
    data['lat'] = this.lat;
    data['weather'] = this.weather;
    return data;
  }

  @override
  String toString() {
    return 'CityItem{name: $name, log: $log, lat: $lat, weather: $weather}';
  }
}
