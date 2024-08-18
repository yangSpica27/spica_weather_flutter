import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spica_weather_flutter/model/weather_response.dart';

import 'logic.dart';

class AlertDetailPage extends StatelessWidget {
  AlertDetailPage({super.key});

  final logic = Get.find<AlertDetailLogic>();
  final state = Get.find<AlertDetailLogic>().state;

  @override
  Widget build(BuildContext context) {
    if (Get.arguments == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('预警信息'),
        ),
        body: const Center(
          child: Text('暂无预警信息'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('预警信息'),
      ),
      body: ListView(
        children:
            Get.arguments.map((e) => _AlertItemWidget(warning: e)).toList(),
      ),
    );
  }
}

class _AlertItemWidget extends StatelessWidget {
  final Warning warning;

  const _AlertItemWidget({required this.warning});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('预警类型：${warning.title}'),
          Text('预警等级：${warning.startTime}'),
          Text('预警信息：${warning.text}'),
          Text('源：${warning.sender}'),
        ],
      ),
    );
  }
}
