import 'package:get/get.dart';

import 'logic.dart';

class CitySelectorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CitySelectorLogic());
  }
}
