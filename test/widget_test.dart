import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:spica_weather_flutter/main.dart';
import 'package:spica_weather_flutter/modules/splash/logic.dart';
import 'package:spica_weather_flutter/modules/splash/view.dart';

class _SplashPreviewLogic extends SplashLogic {
  @override
  void onReady() {
    // Keep this UI test independent of location, network and background tasks.
  }
}

void main() {
  testWidgets('App opens the weather splash screen', (tester) async {
    Get.testMode = true;
    Get.put<SplashLogic>(_SplashPreviewLogic());
    addTearDown(Get.reset);

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('初始化中...'), findsOneWidget);
    for (final character in '柠檬天气'.split('')) {
      expect(find.text(character), findsOneWidget);
    }
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
