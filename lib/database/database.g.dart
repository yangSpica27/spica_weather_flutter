// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CityTable extends City with TableInfo<$CityTable, CityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<String> lat = GeneratedColumn<String>(
      'lat', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<String> lon = GeneratedColumn<String>(
      'lon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortMeta = const VerificationMeta('sort');
  @override
  late final GeneratedColumn<BigInt> sort = GeneratedColumn<BigInt>(
      'sort', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _isLocationMeta =
      const VerificationMeta('isLocation');
  @override
  late final GeneratedColumn<bool> isLocation = GeneratedColumn<bool>(
      'is_location', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_location" IN (0, 1))'));
  static const VerificationMeta _weatherMeta =
      const VerificationMeta('weather');
  @override
  late final GeneratedColumnWithTypeConverter<WeatherResult?, String> weather =
      GeneratedColumn<String>('weather', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<WeatherResult?>($CityTable.$converterweather);
  @override
  List<GeneratedColumn> get $columns =>
      [name, lat, lon, sort, isLocation, weather];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'city';
  @override
  VerificationContext validateIntegrity(Insertable<CityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
          _latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
          _lonMeta, lon.isAcceptableOrUnknown(data['lon']!, _lonMeta));
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('sort')) {
      context.handle(
          _sortMeta, sort.isAcceptableOrUnknown(data['sort']!, _sortMeta));
    } else if (isInserting) {
      context.missing(_sortMeta);
    }
    if (data.containsKey('is_location')) {
      context.handle(
          _isLocationMeta,
          isLocation.isAcceptableOrUnknown(
              data['is_location']!, _isLocationMeta));
    } else if (isInserting) {
      context.missing(_isLocationMeta);
    }
    context.handle(_weatherMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  CityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CityData(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      lat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lat'])!,
      lon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lon'])!,
      sort: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}sort'])!,
      isLocation: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_location'])!,
      weather: $CityTable.$converterweather.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weather'])),
    );
  }

  @override
  $CityTable createAlias(String alias) {
    return $CityTable(attachedDatabase, alias);
  }

  static TypeConverter<WeatherResult?, String?> $converterweather =
      const WeatherResultTypeConverter();
}

class CityData extends DataClass implements Insertable<CityData> {
  final String name;
  final String lat;
  final String lon;
  final BigInt sort;
  final bool isLocation;
  final WeatherResult? weather;
  const CityData(
      {required this.name,
      required this.lat,
      required this.lon,
      required this.sort,
      required this.isLocation,
      this.weather});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['lat'] = Variable<String>(lat);
    map['lon'] = Variable<String>(lon);
    map['sort'] = Variable<BigInt>(sort);
    map['is_location'] = Variable<bool>(isLocation);
    if (!nullToAbsent || weather != null) {
      map['weather'] =
          Variable<String>($CityTable.$converterweather.toSql(weather));
    }
    return map;
  }

  CityCompanion toCompanion(bool nullToAbsent) {
    return CityCompanion(
      name: Value(name),
      lat: Value(lat),
      lon: Value(lon),
      sort: Value(sort),
      isLocation: Value(isLocation),
      weather: weather == null && nullToAbsent
          ? const Value.absent()
          : Value(weather),
    );
  }

  factory CityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CityData(
      name: serializer.fromJson<String>(json['name']),
      lat: serializer.fromJson<String>(json['lat']),
      lon: serializer.fromJson<String>(json['lon']),
      sort: serializer.fromJson<BigInt>(json['sort']),
      isLocation: serializer.fromJson<bool>(json['isLocation']),
      weather: serializer.fromJson<WeatherResult?>(json['weather']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'lat': serializer.toJson<String>(lat),
      'lon': serializer.toJson<String>(lon),
      'sort': serializer.toJson<BigInt>(sort),
      'isLocation': serializer.toJson<bool>(isLocation),
      'weather': serializer.toJson<WeatherResult?>(weather),
    };
  }

  CityData copyWith(
          {String? name,
          String? lat,
          String? lon,
          BigInt? sort,
          bool? isLocation,
          Value<WeatherResult?> weather = const Value.absent()}) =>
      CityData(
        name: name ?? this.name,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        sort: sort ?? this.sort,
        isLocation: isLocation ?? this.isLocation,
        weather: weather.present ? weather.value : this.weather,
      );
  @override
  String toString() {
    return (StringBuffer('CityData(')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('sort: $sort, ')
          ..write('isLocation: $isLocation, ')
          ..write('weather: $weather')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, lat, lon, sort, isLocation, weather);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CityData &&
          other.name == this.name &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.sort == this.sort &&
          other.isLocation == this.isLocation &&
          other.weather == this.weather);
}

class CityCompanion extends UpdateCompanion<CityData> {
  final Value<String> name;
  final Value<String> lat;
  final Value<String> lon;
  final Value<BigInt> sort;
  final Value<bool> isLocation;
  final Value<WeatherResult?> weather;
  final Value<int> rowid;
  const CityCompanion({
    this.name = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.sort = const Value.absent(),
    this.isLocation = const Value.absent(),
    this.weather = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CityCompanion.insert({
    required String name,
    required String lat,
    required String lon,
    required BigInt sort,
    required bool isLocation,
    this.weather = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        lat = Value(lat),
        lon = Value(lon),
        sort = Value(sort),
        isLocation = Value(isLocation);
  static Insertable<CityData> custom({
    Expression<String>? name,
    Expression<String>? lat,
    Expression<String>? lon,
    Expression<BigInt>? sort,
    Expression<bool>? isLocation,
    Expression<String>? weather,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (sort != null) 'sort': sort,
      if (isLocation != null) 'is_location': isLocation,
      if (weather != null) 'weather': weather,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CityCompanion copyWith(
      {Value<String>? name,
      Value<String>? lat,
      Value<String>? lon,
      Value<BigInt>? sort,
      Value<bool>? isLocation,
      Value<WeatherResult?>? weather,
      Value<int>? rowid}) {
    return CityCompanion(
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      sort: sort ?? this.sort,
      isLocation: isLocation ?? this.isLocation,
      weather: weather ?? this.weather,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lat.present) {
      map['lat'] = Variable<String>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<String>(lon.value);
    }
    if (sort.present) {
      map['sort'] = Variable<BigInt>(sort.value);
    }
    if (isLocation.present) {
      map['is_location'] = Variable<bool>(isLocation.value);
    }
    if (weather.present) {
      map['weather'] =
          Variable<String>($CityTable.$converterweather.toSql(weather.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CityCompanion(')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('sort: $sort, ')
          ..write('isLocation: $isLocation, ')
          ..write('weather: $weather, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $CityTable city = $CityTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [city];
}

typedef $$CityTableInsertCompanionBuilder = CityCompanion Function({
  required String name,
  required String lat,
  required String lon,
  required BigInt sort,
  required bool isLocation,
  Value<WeatherResult?> weather,
  Value<int> rowid,
});
typedef $$CityTableUpdateCompanionBuilder = CityCompanion Function({
  Value<String> name,
  Value<String> lat,
  Value<String> lon,
  Value<BigInt> sort,
  Value<bool> isLocation,
  Value<WeatherResult?> weather,
  Value<int> rowid,
});

class $$CityTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CityTable,
    CityData,
    $$CityTableFilterComposer,
    $$CityTableOrderingComposer,
    $$CityTableProcessedTableManager,
    $$CityTableInsertCompanionBuilder,
    $$CityTableUpdateCompanionBuilder> {
  $$CityTableTableManager(_$AppDatabase db, $CityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CityTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CityTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$CityTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> name = const Value.absent(),
            Value<String> lat = const Value.absent(),
            Value<String> lon = const Value.absent(),
            Value<BigInt> sort = const Value.absent(),
            Value<bool> isLocation = const Value.absent(),
            Value<WeatherResult?> weather = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CityCompanion(
            name: name,
            lat: lat,
            lon: lon,
            sort: sort,
            isLocation: isLocation,
            weather: weather,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String name,
            required String lat,
            required String lon,
            required BigInt sort,
            required bool isLocation,
            Value<WeatherResult?> weather = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CityCompanion.insert(
            name: name,
            lat: lat,
            lon: lon,
            sort: sort,
            isLocation: isLocation,
            weather: weather,
            rowid: rowid,
          ),
        ));
}

class $$CityTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $CityTable,
    CityData,
    $$CityTableFilterComposer,
    $$CityTableOrderingComposer,
    $$CityTableProcessedTableManager,
    $$CityTableInsertCompanionBuilder,
    $$CityTableUpdateCompanionBuilder> {
  $$CityTableProcessedTableManager(super.$state);
}

class $$CityTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CityTable> {
  $$CityTableFilterComposer(super.$state);
  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get lat => $state.composableBuilder(
      column: $state.table.lat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get lon => $state.composableBuilder(
      column: $state.table.lon,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<BigInt> get sort => $state.composableBuilder(
      column: $state.table.sort,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isLocation => $state.composableBuilder(
      column: $state.table.isLocation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<WeatherResult?, WeatherResult, String>
      get weather => $state.composableBuilder(
          column: $state.table.weather,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));
}

class $$CityTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CityTable> {
  $$CityTableOrderingComposer(super.$state);
  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get lat => $state.composableBuilder(
      column: $state.table.lat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get lon => $state.composableBuilder(
      column: $state.table.lon,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<BigInt> get sort => $state.composableBuilder(
      column: $state.table.sort,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isLocation => $state.composableBuilder(
      column: $state.table.isLocation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get weather => $state.composableBuilder(
      column: $state.table.weather,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$CityTableTableManager get city => $$CityTableTableManager(_db, _db.city);
}
