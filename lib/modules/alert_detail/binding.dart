import 'package:get/get.dart';

import 'logic.dart';

class AlertDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AlertDetailLogic());
  }
}
