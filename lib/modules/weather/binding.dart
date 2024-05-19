import 'package:get/get.dart';

import 'logic.dart';

class WeatherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WeatherLogic());
  }
}
