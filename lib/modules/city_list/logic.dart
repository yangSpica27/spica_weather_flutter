import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:get/get.dart';
import 'package:spica_weather_flutter/database/database.dart';

class CityListLogic extends GetxController {
  final data = <CityData>[].obs;

  @override
  void onReady() {
    super.onReady();
    data.bindStream(AppDatabase.getInstance().city.select().watch());
  }

  removeCity(CityData item) async {
    await AppDatabase.getInstance().computeWithDatabase(
        computation: (database) async {
          await database.city.deleteWhere((tbl) => tbl.name.equals(item.name));
        },
        connect: (connect) => AppDatabase(connect));
  }
}
