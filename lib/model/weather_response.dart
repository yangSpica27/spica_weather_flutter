/// 接口返回对象
class WeatherResponse {
  int? code;
  String? message;
  WeatherResult? data;

  WeatherResponse({this.code, this.message, this.data});

  WeatherResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? WeatherResult.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class WeatherResult {
  TodayWeather? todayWeather;
  List<DailyWeather>? dailyWeather;
  List<HourlyWeather>? hourlyWeather;
  List<LifeIndexes>? lifeIndexes;
  List<Minutely>? minutely;
  Air? air;
  String? descriptionForToday;
  List<Warning>? warnings;

  int? _upperLimit;

  int? _lowerLimit;

  // 获取最高温度[一周内]
  int upperLimit() {
    if (_upperLimit != null) {
      return _upperLimit!;
    }
    if (dailyWeather == null) {
      return 0;
    }
    int max = dailyWeather![0].maxTemp!;
    for (int i = 1; i < dailyWeather!.length; i++) {
      if (dailyWeather![i].maxTemp! > max) {
        max = dailyWeather![i].maxTemp!;
      }
    }
    return _upperLimit = max;
  }

  // 获取最低温度[一周内]
  int lowerLimit() {
    if (_lowerLimit != null) {
      return _lowerLimit!;
    }
    if (dailyWeather == null) {
      return 0;
    }
    int min = dailyWeather![0].minTemp!;
    for (int i = 1; i < dailyWeather!.length; i++) {
      if (dailyWeather![i].minTemp! < min) {
        min = dailyWeather![i].minTemp!;
      }
    }
    return _lowerLimit = min;
  }

  WeatherResult(
      {this.todayWeather,
      this.dailyWeather,
      this.hourlyWeather,
      this.lifeIndexes,
      this.minutely,
      this.air,
      this.warnings,
      this.descriptionForToday});

  WeatherResult.fromJson(Map<String, dynamic> json) {
    todayWeather = json['todayWeather'] != null
        ? TodayWeather.fromJson(json['todayWeather'])
        : null;
    if (json['dailyWeather'] != null) {
      dailyWeather = <DailyWeather>[];
      json['dailyWeather'].forEach((v) {
        dailyWeather!.add(DailyWeather.fromJson(v));
      });
    }
    if (json['hourlyWeather'] != null) {
      hourlyWeather = <HourlyWeather>[];
      json['hourlyWeather'].forEach((v) {
        hourlyWeather!.add(HourlyWeather.fromJson(v));
      });
    }
    if (json['lifeIndexes'] != null) {
      lifeIndexes = <LifeIndexes>[];
      json['lifeIndexes'].forEach((v) {
        lifeIndexes!.add(LifeIndexes.fromJson(v));
      });
    }
    if (json['minutely'] != null) {
      minutely = <Minutely>[];
      json['minutely'].forEach((v) {
        minutely!.add(Minutely.fromJson(v));
      });
    }
    if (json['warnings'] != null) {
      warnings = <Warning>[];
      json['warnings'].forEach((v) {
        warnings?.add(Warning.fromJson(v));
      });
    }
    air = json['air'] != null ? Air.fromJson(json['air']) : null;
    descriptionForToday = json['descriptionForToday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (todayWeather != null) {
      data['todayWeather'] = todayWeather!.toJson();
    }
    if (dailyWeather != null) {
      data['dailyWeather'] = dailyWeather!.map((v) => v.toJson()).toList();
    }
    if (hourlyWeather != null) {
      data['hourlyWeather'] = hourlyWeather!.map((v) => v.toJson()).toList();
    }
    if (lifeIndexes != null) {
      data['lifeIndexes'] = lifeIndexes!.map((v) => v.toJson()).toList();
    }
    if (minutely != null) {
      data['minutely'] = minutely!.map((v) => v.toJson()).toList();
    }
    if (air != null) {
      data['air'] = air!.toJson();
    }
    if (warnings != null) {
      data['warnings'] = warnings!.map((v) => v.toJson()).toList();
    }
    data['descriptionForToday'] = descriptionForToday;
    return data;
  }

  @override
  String toString() {
    return 'WeatherResult{todayWeather: $todayWeather,warnings:$warnings, dailyWeather: $dailyWeather, hourlyWeather: $hourlyWeather, lifeIndexes: $lifeIndexes, minutely: $minutely, air: $air, descriptionForToday: $descriptionForToday}';
  }
}

class Warning {
  String? sender;
  String? title;
  String? text;
  String? startTime;

  Warning({this.sender, this.title, this.text, this.startTime});

  static final RegExp regExp = RegExp('^[^发布\n]+发布');

  String getShortTitle() {
    return title?.replaceAll(regExp.firstMatch(title!)?.group(0) ?? "", '') ??
        title ??
        "";
  }

  Warning.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    title = json['title'];
    text = json['text'];
    startTime = json['startTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender'] = sender;
    data['title'] = title;
    data['text'] = text;
    data['startTime'] = startTime;
    return data;
  }

  @override
  String toString() {
    return 'Warning{sender: $sender, title: $title, text: $text, startTime: $startTime}';
  }
}

class TodayWeather {
  int? temp;
  int? feelTemp;
  int? iconId;
  int? windSpeed;
  int? water;
  int? windPa;
  String? weatherName;
  String? obsTime;

  TodayWeather(
      {this.temp,
      this.feelTemp,
      this.iconId,
      this.windSpeed,
      this.water,
      this.windPa,
      this.weatherName,
      this.obsTime});

  TodayWeather.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    feelTemp = json['feelTemp'];
    iconId = json['iconId'];
    windSpeed = json['windSpeed'];
    water = json['water'];
    windPa = json['windPa'];
    weatherName = json['weatherName'];
    obsTime = json['obsTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temp'] = temp;
    data['feelTemp'] = feelTemp;
    data['iconId'] = iconId;
    data['windSpeed'] = windSpeed;
    data['water'] = water;
    data['windPa'] = windPa;
    data['weatherName'] = weatherName;
    data['obsTime'] = obsTime;
    return data;
  }

  @override
  String toString() {
    return 'TodayWeather{temp: $temp, feelTemp: $feelTemp, iconId: $iconId, windSpeed: $windSpeed, water: $water, windPa: $windPa, weatherName: $weatherName, obsTime: $obsTime}';
  }
}

class DailyWeather {
  int? maxTemp;
  int? minTemp;
  int? iconId;
  int? winSpeed;
  int? water;
  int? windPa;
  String? weatherNameDay;
  double? precip;
  String? sunriseDate;
  String? sunsetDate;
  String? moonParse;
  String? dayWindDir;
  String? dayWindSpeed;
  String? nightWindSpeed;
  String? nightWindDir;
  String? weatherNameNight;
  String? pressure;
  String? uv;
  int? vis;
  int? cloud;
  String? fxTime;

  DailyWeather(
      {this.maxTemp,
      this.minTemp,
      this.iconId,
      this.winSpeed,
      this.water,
      this.windPa,
      this.weatherNameDay,
      this.precip,
      this.sunriseDate,
      this.sunsetDate,
      this.moonParse,
      this.dayWindDir,
      this.dayWindSpeed,
      this.nightWindSpeed,
      this.nightWindDir,
      this.weatherNameNight,
      this.pressure,
      this.uv,
      this.vis,
      this.cloud,
      this.fxTime});

  DailyWeather.fromJson(Map<String, dynamic> json) {
    maxTemp = json['maxTemp'];
    minTemp = json['minTemp'];
    iconId = json['iconId'];
    winSpeed = json['winSpeed'];
    water = json['water'];
    windPa = json['windPa'];
    weatherNameDay = json['weatherNameDay'];
    precip = json['precip'];
    sunriseDate = json['sunriseDate'];
    sunsetDate = json['sunsetDate'];
    moonParse = json['moonParse'];
    dayWindDir = json['dayWindDir'];
    dayWindSpeed = json['dayWindSpeed'];
    nightWindSpeed = json['nightWindSpeed'];
    nightWindDir = json['nightWindDir'];
    weatherNameNight = json['weatherNameNight'];
    pressure = json['pressure'];
    uv = json['uv'];
    vis = json['vis'];
    cloud = json['cloud'];
    fxTime = json['fxTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maxTemp'] = maxTemp;
    data['minTemp'] = minTemp;
    data['iconId'] = iconId;
    data['winSpeed'] = winSpeed;
    data['water'] = water;
    data['windPa'] = windPa;
    data['weatherNameDay'] = weatherNameDay;
    data['precip'] = precip;
    data['sunriseDate'] = sunriseDate;
    data['sunsetDate'] = sunsetDate;
    data['moonParse'] = moonParse;
    data['dayWindDir'] = dayWindDir;
    data['dayWindSpeed'] = dayWindSpeed;
    data['nightWindSpeed'] = nightWindSpeed;
    data['nightWindDir'] = nightWindDir;
    data['weatherNameNight'] = weatherNameNight;
    data['pressure'] = pressure;
    data['uv'] = uv;
    data['vis'] = vis;
    data['cloud'] = cloud;
    data['fxTime'] = fxTime;
    return data;
  }
}

class HourlyWeather {
  int? temp;
  int? iconId;
  int? windSpeed;
  int? water;
  int? windPa;
  String? weatherName;
  int? pop;
  String? fxTime;

  @override
  String toString() {
    return 'HourlyWeather{temp: $temp, iconId: $iconId, windSpeed: $windSpeed, water: $water, windPa: $windPa, weatherName: $weatherName, pop: $pop, fxTime: $fxTime}';
  }

  HourlyWeather(
      {this.temp,
      this.iconId,
      this.windSpeed,
      this.water,
      this.windPa,
      this.weatherName,
      this.pop,
      this.fxTime});

  HourlyWeather.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    iconId = json['iconId'];
    windSpeed = json['windSpeed'];
    water = json['water'];
    windPa = json['windPa'];
    weatherName = json['weatherName'];
    pop = json['pop'];
    fxTime = json['fxTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temp'] = temp;
    data['iconId'] = iconId;
    data['windSpeed'] = windSpeed;
    data['water'] = water;
    data['windPa'] = windPa;
    data['weatherName'] = weatherName;
    data['pop'] = pop;
    data['fxTime'] = fxTime;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HourlyWeather &&
          runtimeType == other.runtimeType &&
          temp == other.temp &&
          iconId == other.iconId &&
          windSpeed == other.windSpeed &&
          water == other.water &&
          windPa == other.windPa &&
          weatherName == other.weatherName &&
          pop == other.pop &&
          fxTime == other.fxTime;

  @override
  int get hashCode =>
      temp.hashCode ^
      iconId.hashCode ^
      windSpeed.hashCode ^
      water.hashCode ^
      windPa.hashCode ^
      weatherName.hashCode ^
      pop.hashCode ^
      fxTime.hashCode;
}

class LifeIndexes {
  int? type;
  String? name;
  String? category;
  String? text;

  LifeIndexes({this.type, this.name, this.category, this.text});

  LifeIndexes.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    category = json['category'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['category'] = category;
    data['text'] = text;
    return data;
  }
}

class Minutely {
  String? fxTime;
  String? precip;
  String? type;

  Minutely({this.fxTime, this.precip, this.type});

  Minutely.fromJson(Map<String, dynamic> json) {
    fxTime = json['fxTime'];
    precip = json['precip'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fxTime'] = fxTime;
    data['precip'] = precip;
    data['type'] = type;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Minutely &&
          runtimeType == other.runtimeType &&
          fxTime == other.fxTime &&
          precip == other.precip &&
          type == other.type;

  @override
  int get hashCode => fxTime.hashCode ^ precip.hashCode ^ type.hashCode;
}

class Air {
  int? aqi;
  String? category;
  String? primary;
  double? pm10;
  double? pm2p5;
  double? no2;
  double? so2;
  double? co;
  double? o3;
  Null fxLink;

  Air(
      {this.aqi,
      this.category,
      this.primary,
      this.pm10,
      this.pm2p5,
      this.no2,
      this.so2,
      this.co,
      this.o3,
      this.fxLink});

  Air.fromJson(Map<String, dynamic> json) {
    aqi = json['aqi'];
    category = json['category'];
    primary = json['primary'];
    pm10 = json['pm10'];
    pm2p5 = json['pm2p5'];
    no2 = json['no2'];
    so2 = json['so2'];
    co = json['co'];
    o3 = json['o3'];
    fxLink = json['fxLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aqi'] = aqi;
    data['category'] = category;
    data['primary'] = primary;
    data['pm10'] = pm10;
    data['pm2p5'] = pm2p5;
    data['no2'] = no2;
    data['so2'] = so2;
    data['co'] = co;
    data['o3'] = o3;
    data['fxLink'] = fxLink;
    return data;
  }
}
