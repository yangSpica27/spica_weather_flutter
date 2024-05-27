import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:spica_weather_flutter/database/converter/weather_result_type_converter.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import '../model/weather_response.dart';

part 'database.g.dart';

/// 城市表

class City extends Table {
  TextColumn get name => text()();

  TextColumn get lat => text()();

  TextColumn get lon => text()();

  Int64Column get sort => int64()();

  TextColumn get weather =>
      text().map(const WeatherResultTypeConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {name};
}

/// 数据库配置
@DriftDatabase(tables: [City])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  static AppDatabase? _instance;

  static AppDatabase getInstance() {
    if (_instance != null) {
      return _instance!;
    }
    _instance = AppDatabase();
    return _instance!;
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // 兼容旧版本Android
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;
    return NativeDatabase.createInBackground(file);
  });
}
