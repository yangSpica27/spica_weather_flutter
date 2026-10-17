import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:spica_weather_flutter/modules/city_selector/logic.dart';
import 'package:spica_weather_flutter/modules/city_selector/view.dart';

Future<void> _waitForCities(CitySelectorLogic logic) async {
  if (logic.isLoadingState.value) {
    await logic.isLoadingState.stream
        .firstWhere((loading) => !loading)
        .timeout(const Duration(seconds: 5));
  }
}

Future<CitySelectorLogic> _loadCities() async {
  final logic = CitySelectorLogic();
  addTearDown(logic.onDelete.call);
  logic.onReady();
  await _waitForCities(logic);
  expect(logic.showItems, isNotEmpty);
  return logic;
}

Future<void> _waitForSearch() =>
    Future<void>.delayed(const Duration(milliseconds: 350));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Searching the real city assets completes without an isolate error',
    () async {
      final logic = await _loadCities();

      logic.onSearch('南京');
      await _waitForSearch();

      expect(logic.isLoadingState.value, isFalse);
      expect(logic.showItems.map((city) => city.name), ['南京']);
    },
  );

  test('A search without matches finishes with an empty result', () async {
    final logic = await _loadCities();

    logic.onSearch('不存在的城市');
    await _waitForSearch();

    expect(logic.showItems, isEmpty);
    expect(logic.isLoadingState.value, isFalse);
  });

  test(
    'Clearing input cancels the pending search and restores every city',
    () async {
      final logic = await _loadCities();
      final allCities = logic.showItems.toList();

      logic.onSearch('南京');
      logic.onSearch('');

      expect(logic.showItems, orderedEquals(allCities));
      await _waitForSearch();
      expect(logic.showItems, orderedEquals(allCities));
      expect(logic.isLoadingState.value, isFalse);
    },
  );

  test('Leading and trailing whitespace are ignored', () async {
    final logic = await _loadCities();
    final allCities = logic.showItems.toList();

    logic.onSearch('  南京  ');
    await _waitForSearch();
    expect(logic.showItems.map((city) => city.name), ['南京']);

    logic.onSearch('   ');
    expect(logic.showItems, orderedEquals(allCities));
  });

  test('Rapid input only applies the most recent search', () async {
    final logic = await _loadCities();
    final initialCount = logic.showItems.length;

    logic.onSearch('南京');
    await Future<void>.delayed(const Duration(milliseconds: 150));
    logic.onSearch('北京');
    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(logic.showItems.length, initialCount);

    await Future<void>.delayed(const Duration(milliseconds: 150));
    expect(logic.showItems.map((city) => city.name), ['北京市']);
    expect(logic.isLoadingState.value, isFalse);
  });

  test(
    'Input entered while cities are loading is applied after loading',
    () async {
      final logic = CitySelectorLogic();
      addTearDown(logic.onDelete.call);

      logic.onReady();
      expect(logic.isLoadingState.value, isTrue);
      logic.onSearch('南京');
      await _waitForCities(logic);

      expect(logic.showItems.map((city) => city.name), ['南京']);
      await _waitForSearch();
      expect(logic.showItems.map((city) => city.name), ['南京']);
    },
  );

  test('Closing the controller cancels a pending search', () async {
    final logic = await _loadCities();
    final allCities = logic.showItems.toList();

    logic.onSearch('南京');
    logic.onDelete();
    await _waitForSearch();

    expect(logic.isClosed, isTrue);
    expect(logic.showItems, orderedEquals(allCities));
  });

  testWidgets('The search field displays filtered cities and an empty state', (
    tester,
  ) async {
    Get.testMode = true;
    addTearDown(Get.reset);
    final logic = Get.put(CitySelectorLogic());

    await tester.runAsync(() async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 812),
          builder: (context, child) =>
              const GetMaterialApp(home: CitySelectorPage()),
        ),
      );
      await _waitForCities(logic);
    });
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.enterText(find.byType(TextField), '南京');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(find.text('南京'), findsNWidgets(2));
    expect(find.byType(ListTile), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.enterText(find.byType(TextField), '不存在的城市');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.text('暂无数据'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();
    expect(find.text('暂无数据'), findsNothing);
    expect(find.byType(ListTile), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
