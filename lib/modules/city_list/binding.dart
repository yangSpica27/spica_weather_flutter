import 'package:get/get.dart';

import 'logic.dart';

class CityListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CityListLogic());
  }
}
