import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:spica_weather_flutter/database/database.dart';

class CityListLogic extends GetxController {
  final data = <CityData>[].obs;

  final isSort = false.obs;

  @override
  void onReady() {
    super.onReady();
    data.bindStream((AppDatabase.getInstance().city.select()
          ..orderBy([(t) => OrderingTerm(expression: t.sort)]))
        .watch());
  }

  removeCity(CityData item) async {
    await AppDatabase.getInstance().computeWithDatabase(
        computation: (database) async {
          await database.city.deleteWhere((tbl) => tbl.name.equals(item.name));
        },
        connect: (connect) => AppDatabase(connect));
  }

  // 交换次序
  reorderCity(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    var child = data.removeAt(oldIndex);
    data.insert(newIndex, child);

    for (int index = 0; index < data.length; index++) {
      data[index] = data[index].copyWith(sort: BigInt.from(index));
    }
    await AppDatabase.getInstance()
        .city
        .insertAll(data, mode: InsertMode.insertOrReplace);
  }

}
