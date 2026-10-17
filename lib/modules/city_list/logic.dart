import 'package:drift/drift.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:spica_weather_flutter/database/database.dart';

class CityListLogic extends GetxController {
  CityListLogic({AppDatabase? database})
    : _database = database ?? AppDatabase.getInstance();

  final AppDatabase _database;

  final data = <CityData>[].obs;

  final isSort = false.obs;

  @override
  void onReady() {
    super.onReady();
    data.bindStream(
      (_database.city.select()
            ..orderBy([(t) => OrderingTerm(expression: t.sort)]))
          .watch(),
    );
  }

  Future<void> removeCity(CityData item) async {
    await _database.computeWithDatabase(
      computation: (database) async {
        await database.city.deleteWhere((tbl) => tbl.name.equals(item.name));
      },
      connect: (connect) => AppDatabase(connect),
    );
  }

  // 交换次序
  Future<void> reorderCity(int oldIndex, int newIndex) async {
    var child = data.removeAt(oldIndex);
    data.insert(newIndex, child);

    for (int index = 0; index < data.length; index++) {
      data[index] = data[index].copyWith(sort: BigInt.from(index));
    }
    await _database.city.insertAll(data, mode: InsertMode.insertOrReplace);
  }
}
