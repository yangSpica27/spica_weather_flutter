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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
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
        ? new TodayWeather.fromJson(json['todayWeather'])
        : null;
    if (json['dailyWeather'] != null) {
      dailyWeather = <DailyWeather>[];
      json['dailyWeather'].forEach((v) {
        dailyWeather!.add(new DailyWeather.fromJson(v));
      });
    }
    if (json['hourlyWeather'] != null) {
      hourlyWeather = <HourlyWeather>[];
      json['hourlyWeather'].forEach((v) {
        hourlyWeather!.add(new HourlyWeather.fromJson(v));
      });
    }
    if (json['lifeIndexes'] != null) {
      lifeIndexes = <LifeIndexes>[];
      json['lifeIndexes'].forEach((v) {
        lifeIndexes!.add(new LifeIndexes.fromJson(v));
      });
    }
    if (json['minutely'] != null) {
      minutely = <Minutely>[];
      json['minutely'].forEach((v) {
        minutely!.add(new Minutely.fromJson(v));
      });
    }
    if (json['warnings'] != null) {
      warnings = <Warning>[];
      json['warnings'].forEach((v) {
        warnings?.add(new Warning.fromJson(v));
      });
    }
    air = json['air'] != null ? new Air.fromJson(json['air']) : null;
    descriptionForToday = json['descriptionForToday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.todayWeather != null) {
      data['todayWeather'] = this.todayWeather!.toJson();
    }
    if (this.dailyWeather != null) {
      data['dailyWeather'] = this.dailyWeather!.map((v) => v.toJson()).toList();
    }
    if (this.hourlyWeather != null) {
      data['hourlyWeather'] =
          this.hourlyWeather!.map((v) => v.toJson()).toList();
    }
    if (this.lifeIndexes != null) {
      data['lifeIndexes'] = this.lifeIndexes!.map((v) => v.toJson()).toList();
    }
    if (this.minutely != null) {
      data['minutely'] = this.minutely!.map((v) => v.toJson()).toList();
    }
    if (this.air != null) {
      data['air'] = this.air!.toJson();
    }
    if (this.warnings != null) {
      data['warnings'] = this.warnings!.map((v) => v.toJson()).toList();
    }
    data['descriptionForToday'] = this.descriptionForToday;
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

  Warning.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    title = json['title'];
    text = json['text'];
    startTime = json['startTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender'] = this.sender;
    data['title'] = this.title;
    data['text'] = this.text;
    data['startTime'] = this.startTime;
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
    data['temp'] = this.temp;
    data['feelTemp'] = this.feelTemp;
    data['iconId'] = this.iconId;
    data['windSpeed'] = this.windSpeed;
    data['water'] = this.water;
    data['windPa'] = this.windPa;
    data['weatherName'] = this.weatherName;
    data['obsTime'] = this.obsTime;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maxTemp'] = this.maxTemp;
    data['minTemp'] = this.minTemp;
    data['iconId'] = this.iconId;
    data['winSpeed'] = this.winSpeed;
    data['water'] = this.water;
    data['windPa'] = this.windPa;
    data['weatherNameDay'] = this.weatherNameDay;
    data['precip'] = this.precip;
    data['sunriseDate'] = this.sunriseDate;
    data['sunsetDate'] = this.sunsetDate;
    data['moonParse'] = this.moonParse;
    data['dayWindDir'] = this.dayWindDir;
    data['dayWindSpeed'] = this.dayWindSpeed;
    data['nightWindSpeed'] = this.nightWindSpeed;
    data['nightWindDir'] = this.nightWindDir;
    data['weatherNameNight'] = this.weatherNameNight;
    data['pressure'] = this.pressure;
    data['uv'] = this.uv;
    data['vis'] = this.vis;
    data['cloud'] = this.cloud;
    data['fxTime'] = this.fxTime;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temp'] = this.temp;
    data['iconId'] = this.iconId;
    data['windSpeed'] = this.windSpeed;
    data['water'] = this.water;
    data['windPa'] = this.windPa;
    data['weatherName'] = this.weatherName;
    data['pop'] = this.pop;
    data['fxTime'] = this.fxTime;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    data['category'] = this.category;
    data['text'] = this.text;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fxTime'] = this.fxTime;
    data['precip'] = this.precip;
    data['type'] = this.type;
    return data;
  }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aqi'] = this.aqi;
    data['category'] = this.category;
    data['primary'] = this.primary;
    data['pm10'] = this.pm10;
    data['pm2p5'] = this.pm2p5;
    data['no2'] = this.no2;
    data['so2'] = this.so2;
    data['co'] = this.co;
    data['o3'] = this.o3;
    data['fxLink'] = this.fxLink;
    return data;
  }
}
