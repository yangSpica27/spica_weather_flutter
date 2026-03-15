import 'package:spica_weather_flutter/model/weather_response.dart';

// ─────────────────────────────────────────────
// 请求体
// ─────────────────────────────────────────────

class BatchWeatherRequest {
  final List<LocationRequest> locations;
  final bool includeHourly;
  final bool includeMinutely;
  final bool includeAqi;
  final bool includeAlerts;

  const BatchWeatherRequest({
    required this.locations,
    this.includeHourly = true,
    this.includeMinutely = true,
    this.includeAqi = true,
    this.includeAlerts = true,
  });

  Map<String, dynamic> toJson() => {
        'locations': locations.map((e) => e.toJson()).toList(),
        'includeHourly': includeHourly,
        'includeMinutely': includeMinutely,
        'includeAqi': includeAqi,
        'includeAlerts': includeAlerts,
      };
}

class LocationRequest {
  /// 自定义 ID，用于在响应中匹配结果，这里复用城市名（DB 主键）
  final String locationId;
  final String longitude;
  final String latitude;
  final String? name;

  const LocationRequest({
    required this.locationId,
    required this.longitude,
    required this.latitude,
    this.name,
  });

  Map<String, dynamic> toJson() => {
        'locationId': locationId,
        'longitude': longitude,
        'latitude': latitude,
        if (name != null) 'name': name,
      };
}

// ─────────────────────────────────────────────
// 响应体
// ─────────────────────────────────────────────

class BatchWeatherResponse {
  final int code;
  final String message;
  final BatchWeatherData? data;

  BatchWeatherResponse(
      {required this.code, required this.message, this.data});

  factory BatchWeatherResponse.fromJson(Map<String, dynamic> json) {
    return BatchWeatherResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      data: json['data'] != null
          ? BatchWeatherData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class BatchWeatherData {
  final List<BatchWeatherResult> results;

  BatchWeatherData({required this.results});

  factory BatchWeatherData.fromJson(Map<String, dynamic> json) {
    return BatchWeatherData(
      results: (json['results'] as List)
          .map((e) =>
              BatchWeatherResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BatchWeatherResult {
  final String locationId;
  final bool success;
  final AggregatedWeatherData? data;
  final String? error;

  BatchWeatherResult({
    required this.locationId,
    required this.success,
    this.data,
    this.error,
  });

  factory BatchWeatherResult.fromJson(Map<String, dynamic> json) {
    return BatchWeatherResult(
      locationId: json['locationId'] as String,
      success: json['success'] as bool,
      data: json['data'] != null
          ? AggregatedWeatherData.fromJson(
              json['data'] as Map<String, dynamic>)
          : null,
      error: json['error'] as String?,
    );
  }
}

// ─────────────────────────────────────────────
// 聚合天气数据（服务端返回的新格式）
// ─────────────────────────────────────────────

class AggregatedWeatherData {
  final String? generatedAt;
  final LocationInfo location;
  final CurrentWeatherData current;
  final ForecastSummaryData forecast;
  final MinutelyPrecipSummaryData? minutelyPrecip;
  final AirQualitySummaryData airQuality;
  final List<WeatherAlertSummaryData>? weatherAlerts;

  AggregatedWeatherData({
    this.generatedAt,
    required this.location,
    required this.current,
    required this.forecast,
    this.minutelyPrecip,
    required this.airQuality,
    this.weatherAlerts,
  });

  factory AggregatedWeatherData.fromJson(Map<String, dynamic> json) {
    return AggregatedWeatherData(
      generatedAt: json['generatedAt'] as String?,
      location: LocationInfo.fromJson(
          json['location'] as Map<String, dynamic>),
      current: CurrentWeatherData.fromJson(
          json['current'] as Map<String, dynamic>),
      forecast: ForecastSummaryData.fromJson(
          json['forecast'] as Map<String, dynamic>),
      minutelyPrecip: json['minutelyPrecip'] != null
          ? MinutelyPrecipSummaryData.fromJson(
              json['minutelyPrecip'] as Map<String, dynamic>)
          : null,
      airQuality: AirQualitySummaryData.fromJson(
          json['airQuality'] as Map<String, dynamic>),
      weatherAlerts: (json['weatherAlerts'] as List?)
          ?.map((e) => WeatherAlertSummaryData.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 将聚合数据映射为应用内部使用的 WeatherResult，无需改动任何 Widget
  WeatherResult toWeatherResult() {
    return WeatherResult(
      todayWeather: TodayWeather(
        temp: current.temperature,
        feelTemp: current.feelsLike,
        iconId: int.tryParse(current.icon),
        windSpeed: current.windSpeed,
        water: current.humidity,
        windPa: current.pressure,
        weatherName: current.condition,
        obsTime: current.obsTime,
      ),
      dailyWeather: forecast.next7Days
          .map((f) => DailyWeather(
                maxTemp: f.tempMax,
                minTemp: f.tempMin,
                iconId: int.tryParse(f.dayIcon),
                winSpeed: int.tryParse(f.windSpeedDay),
                water: f.humidity,
                precip: f.precipitation,
                sunriseDate: f.sunrise,
                sunsetDate: f.sunset,
                dayWindDir: f.windDirDay,
                dayWindSpeed: f.windSpeedDay,
                nightWindSpeed: f.windSpeedNight,
                nightWindDir: f.windDirNight,
                weatherNameDay: f.dayCondition,
                weatherNameNight: f.nightCondition,
                uv: f.uvIndex.toString(),
                vis: int.tryParse(f.vis),
                cloud: int.tryParse(f.cloud),
                fxTime: f.date,
              ))
          .toList(),
      hourlyWeather: forecast.next24Hours
          ?.map((h) => HourlyWeather(
                temp: h.temperature,
                iconId: int.tryParse(h.icon),
                windSpeed: h.windSpeed.round(),
                water: h.humidity,
                weatherName: h.condition,
                pop: h.precipProbability,
                fxTime: h.time,
              ))
          .toList(),
      minutely: minutelyPrecip?.next2Hours
          .map((m) => Minutely(
                fxTime: m.time,
                precip: m.precipitation.toString(),
                type: m.type,
              ))
          .toList(),
      air: Air(
        aqi: airQuality.aqi,
        category: airQuality.category,
        primary: airQuality.primaryPollutant,
        pm10: airQuality.pm10,
        pm2p5: airQuality.pm25,
      ),
      warnings: weatherAlerts
          ?.map((w) => Warning(
                title: w.headline,
                text: w.description,
                startTime: w.issuedTime,
              ))
          .toList(),
      descriptionForToday: minutelyPrecip?.summary,
      lifeIndexes: null, // 新 API 暂不提供生活指数
    );
  }
}

class LocationInfo {
  final String name;
  final String latitude;
  final String longitude;

  LocationInfo(
      {required this.name,
      required this.latitude,
      required this.longitude});

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      name: json['name'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }
}

class CurrentWeatherData {
  final String obsTime;
  final int temperature;
  final int feelsLike;
  final String condition;
  final String icon;
  final int humidity;
  final double precipitation;
  final int pressure;
  final int visibility;
  final int windDirection;
  final String windDirectionText;
  final String windScale;
  final int windSpeed;
  final int cloudCover;

  CurrentWeatherData({
    required this.obsTime,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.precipitation,
    required this.pressure,
    required this.visibility,
    required this.windDirection,
    required this.windDirectionText,
    required this.windScale,
    required this.windSpeed,
    required this.cloudCover,
  });

  factory CurrentWeatherData.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherData(
      obsTime: json['obsTime'] as String,
      temperature: json['temperature'] as int,
      feelsLike: json['feelsLike'] as int,
      condition: json['condition'] as String,
      icon: json['icon'] as String,
      humidity: json['humidity'] as int,
      precipitation: (json['precipitation'] as num).toDouble(),
      pressure: json['pressure'] as int,
      visibility: json['visibility'] as int,
      windDirection: json['windDirection'] as int,
      windDirectionText: json['windDirectionText'] as String,
      windScale: json['windScale'] as String,
      windSpeed: json['windSpeed'] as int,
      cloudCover: json['cloudCover'] as int,
    );
  }
}

class ForecastSummaryData {
  final DailyForecastData today;
  final DailyForecastData tomorrow;
  final List<DailyForecastData> next7Days;
  final List<HourlyForecastData>? next24Hours;

  ForecastSummaryData({
    required this.today,
    required this.tomorrow,
    required this.next7Days,
    this.next24Hours,
  });

  factory ForecastSummaryData.fromJson(Map<String, dynamic> json) {
    return ForecastSummaryData(
      today: DailyForecastData.fromJson(
          json['today'] as Map<String, dynamic>),
      tomorrow: DailyForecastData.fromJson(
          json['tomorrow'] as Map<String, dynamic>),
      next7Days: (json['next7Days'] as List)
          .map((e) =>
              DailyForecastData.fromJson(e as Map<String, dynamic>))
          .toList(),
      next24Hours: (json['next24Hours'] as List?)
          ?.map((e) =>
              HourlyForecastData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DailyForecastData {
  final String date;
  final int tempMax;
  final int tempMin;
  final String dayCondition;
  final String dayIcon;
  final String nightCondition;
  final String nightIcon;
  final double precipitation;
  final int humidity;
  final int uvIndex;
  final String sunrise;
  final String sunset;
  final String vis;
  final String cloud;
  final double wind360Day;
  final double wind360Night;
  final String windDirDay;
  final String windDirNight;
  final String windSpeedDay;
  final String windSpeedNight;
  final String windScaleDay;
  final String windScaleNight;

  DailyForecastData({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.dayCondition,
    required this.dayIcon,
    required this.nightCondition,
    required this.nightIcon,
    required this.precipitation,
    required this.humidity,
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
    required this.vis,
    required this.cloud,
    required this.wind360Day,
    required this.wind360Night,
    required this.windDirDay,
    required this.windDirNight,
    required this.windSpeedDay,
    required this.windSpeedNight,
    required this.windScaleDay,
    required this.windScaleNight,
  });

  factory DailyForecastData.fromJson(Map<String, dynamic> json) {
    return DailyForecastData(
      date: json['date'] as String,
      tempMax: json['tempMax'] as int,
      tempMin: json['tempMin'] as int,
      dayCondition: json['dayCondition'] as String,
      dayIcon: json['dayIcon'] as String,
      nightCondition: json['nightCondition'] as String,
      nightIcon: json['nightIcon'] as String,
      precipitation: (json['precipitation'] as num).toDouble(),
      humidity: json['humidity'] as int,
      uvIndex: json['uvIndex'] as int,
      sunrise: json['sunrise'] as String,
      sunset: json['sunset'] as String,
      vis: json['vis'] as String,
      cloud: json['cloud'] as String,
      wind360Day: (json['wind360Day'] as num).toDouble(),
      wind360Night: (json['wind360Night'] as num).toDouble(),
      windDirDay: json['windDirDay'] as String,
      windDirNight: json['windDirNight'] as String,
      windSpeedDay: json['windSpeedDay'] as String,
      windSpeedNight: json['windSpeedNight'] as String,
      windScaleDay: json['windScaleDay'] as String,
      windScaleNight: json['windScaleNight'] as String,
    );
  }
}

class HourlyForecastData {
  final String time;
  final int temperature;
  final String condition;
  final String icon;
  final int precipProbability;
  final double precipitation;
  final String windDirection;
  final String windScale;
  final int humidity;
  final double wind360;
  final double pop;
  final double windSpeed;

  HourlyForecastData({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.precipProbability,
    required this.precipitation,
    required this.windDirection,
    required this.windScale,
    required this.humidity,
    required this.wind360,
    required this.pop,
    required this.windSpeed,
  });

  factory HourlyForecastData.fromJson(Map<String, dynamic> json) {
    return HourlyForecastData(
      time: json['time'] as String,
      temperature: json['temperature'] as int,
      condition: json['condition'] as String,
      icon: json['icon'] as String,
      precipProbability: json['precipProbability'] as int,
      precipitation: (json['precipitation'] as num).toDouble(),
      windDirection: json['windDirection'] as String,
      windScale: json['windScale'] as String,
      humidity: json['humidity'] as int,
      wind360: (json['wind360'] as num).toDouble(),
      pop: (json['pop'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
    );
  }
}

class MinutelyPrecipSummaryData {
  final String summary;
  final bool isPrecipitating;
  final String? precipType;
  final double currentIntensity;
  final List<MinutelyPrecipData> next2Hours;

  MinutelyPrecipSummaryData({
    required this.summary,
    required this.isPrecipitating,
    this.precipType,
    required this.currentIntensity,
    required this.next2Hours,
  });

  factory MinutelyPrecipSummaryData.fromJson(Map<String, dynamic> json) {
    return MinutelyPrecipSummaryData(
      summary: json['summary'] as String,
      isPrecipitating: json['isPrecipitating'] as bool,
      precipType: json['precipType'] as String?,
      currentIntensity: (json['currentIntensity'] as num).toDouble(),
      next2Hours: (json['next2Hours'] as List)
          .map((e) =>
              MinutelyPrecipData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MinutelyPrecipData {
  final String time;
  final double precipitation;
  final String type;

  MinutelyPrecipData({
    required this.time,
    required this.precipitation,
    required this.type,
  });

  factory MinutelyPrecipData.fromJson(Map<String, dynamic> json) {
    return MinutelyPrecipData(
      time: json['time'] as String,
      precipitation: (json['precipitation'] as num).toDouble(),
      type: json['type'] as String,
    );
  }
}

class AirQualitySummaryData {
  final int aqi;
  final int level;
  final String category;
  final String primaryPollutant;
  final String primaryPollutantName;
  final String healthEffect;
  final String healthAdvice;
  final double? pm25;
  final double? pm10;

  AirQualitySummaryData({
    required this.aqi,
    required this.level,
    required this.category,
    required this.primaryPollutant,
    required this.primaryPollutantName,
    required this.healthEffect,
    required this.healthAdvice,
    this.pm25,
    this.pm10,
  });

  factory AirQualitySummaryData.fromJson(Map<String, dynamic> json) {
    return AirQualitySummaryData(
      aqi: json['aqi'] as int,
      level: json['level'] as int,
      category: json['category'] as String,
      primaryPollutant: json['primaryPollutant'] as String,
      primaryPollutantName: json['primaryPollutantName'] as String,
      healthEffect: json['healthEffect'] as String,
      healthAdvice: json['healthAdvice'] as String,
      pm25: (json['pm25'] as num?)?.toDouble(),
      pm10: (json['pm10'] as num?)?.toDouble(),
    );
  }
}

class WeatherAlertSummaryData {
  final String id;
  final String headline;
  final String eventType;
  final String eventCode;
  final String severity;
  final String colorCode;
  final String description;
  final String instruction;
  final String issuedTime;
  final String effectiveTime;
  final String expireTime;

  WeatherAlertSummaryData({
    required this.id,
    required this.headline,
    required this.eventType,
    required this.eventCode,
    required this.severity,
    required this.colorCode,
    required this.description,
    required this.instruction,
    required this.issuedTime,
    required this.effectiveTime,
    required this.expireTime,
  });

  factory WeatherAlertSummaryData.fromJson(Map<String, dynamic> json) {
    return WeatherAlertSummaryData(
      id: json['id'] as String,
      headline: json['headline'] as String,
      eventType: json['eventType'] as String,
      eventCode: json['eventCode'] as String,
      severity: json['severity'] as String,
      colorCode: json['colorCode'] as String,
      description: json['description'] as String,
      instruction: json['instruction'] as String,
      issuedTime: json['issuedTime'] as String,
      effectiveTime: json['effectiveTime'] as String,
      expireTime: json['expireTime'] as String,
    );
  }
}
