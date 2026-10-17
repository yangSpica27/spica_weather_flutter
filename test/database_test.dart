import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spica_weather_flutter/database/database.dart';
import 'package:spica_weather_flutter/model/weather_response.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test(
    'SQLite native assets preserve an existing v2 weather database',
    () async {
      final directory = await Directory.systemTemp.createTemp('spica-weather-');
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/db.sqlite');
      final weather = {
        'todayWeather': {'temp': 23, 'weatherName': '晴', 'iconId': 100},
        'descriptionForToday': '晴转多云',
      };
      final expectedWeather = WeatherResult.fromJson(weather).toJson();
      final legacy = sqlite3.open(file.path);
      try {
        legacy.execute('''
        CREATE TABLE city (
          name TEXT NOT NULL PRIMARY KEY,
          lat TEXT NOT NULL,
          lon TEXT NOT NULL,
          sort INTEGER NOT NULL,
          is_location INTEGER NOT NULL CHECK (is_location IN (0, 1)),
          weather TEXT
        )
      ''');
        legacy.execute('PRAGMA user_version = 2');
        legacy.execute('INSERT INTO city VALUES (?, ?, ?, ?, ?, ?)', [
          '南京',
          '32.04',
          '118.78',
          42,
          1,
          jsonEncode(weather),
        ]);
      } finally {
        legacy.close();
      }

      var database = AppDatabase(NativeDatabase.createInBackground(file));
      addTearDown(() => database.close());
      final saved = await database.city.select().getSingle();
      expect(saved.name, '南京');
      expect(saved.isLocation, isTrue);
      expect(saved.sort, BigInt.from(42));
      expect(saved.weather?.toJson(), expectedWeather);

      final largeSort = BigInt.parse('9007199254740993');
      await database.city.insertOne(
        CityCompanion.insert(
          name: '北京',
          lat: '39.90',
          lon: '116.40',
          sort: largeSort,
          isLocation: false,
        ),
      );
      await database.close();

      database = AppDatabase(NativeDatabase.createInBackground(file));
      final cities =
          await (database.city.select()
                ..orderBy([(city) => OrderingTerm(expression: city.sort)]))
              .get();
      expect(cities.map((city) => city.name), ['南京', '北京']);
      expect(cities.first.weather?.toJson(), expectedWeather);
      expect(cities.last.sort, largeSort);
      expect(cities.last.weather, isNull);
    },
  );
}
