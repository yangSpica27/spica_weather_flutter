


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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['log'] = log;
    data['lat'] = lat;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['log'] = log;
    data['lat'] = lat;
    data['weather'] = weather;
    return data;
  }

  @override
  String toString() {
    return 'CityItem{name: $name, log: $log, lat: $lat, weather: $weather}';
  }




}
