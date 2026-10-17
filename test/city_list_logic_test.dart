import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spica_weather_flutter/database/database.dart';
import 'package:spica_weather_flutter/modules/city_list/logic.dart';

void main() {
  late AppDatabase database;
  late CityListLogic logic;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    logic = CityListLogic(database: database);
    for (final (index, name) in ['南京', '北京', '上海'].indexed) {
      await database.city.insertOne(
        CityCompanion.insert(
          name: name,
          lat: '32.04',
          lon: '118.78',
          sort: BigInt.from(index),
          isLocation: index == 0,
        ),
      );
    }
    logic.data.addAll(await database.city.select().get());
  });

  tearDown(() async {
    logic.onClose();
    await database.close();
  });

  for (final (oldIndex, newIndex, expected) in [
    (0, 2, ['北京', '上海', '南京']),
    (2, 0, ['上海', '南京', '北京']),
    (1, 1, ['南京', '北京', '上海']),
  ]) {
    test(
      'Reorder $oldIndex to $newIndex uses the adjusted destination',
      () async {
        await logic.reorderCity(oldIndex, newIndex);

        expect(logic.data.map((city) => city.name), expected);
        final saved =
            await (database.city.select()
                  ..orderBy([(city) => OrderingTerm(expression: city.sort)]))
                .get();
        expect(saved.map((city) => city.name), expected);
        expect(saved.map((city) => city.sort), [
          BigInt.zero,
          BigInt.one,
          BigInt.two,
        ]);
      },
    );
  }
}
