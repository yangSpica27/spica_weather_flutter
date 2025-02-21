import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spica_weather_flutter/model/weather_response.dart';

import 'logic.dart';

/// 预警信息详情
class AlertDetailPage extends StatelessWidget {
  AlertDetailPage({super.key});
  // 获取逻辑层
  final logic = Get.find<AlertDetailLogic>();
  // 获取状态
  final state = Get.find<AlertDetailLogic>().state;

  @override
  Widget build(BuildContext context) {
    // 判断是否传递了参数
    if (Get.arguments == null) {
      // 没有参数时展示提示页面
      return Scaffold(
        appBar: AppBar(
          title: const Text('预警信息'),
        ),
        body: const Center(
          child: Text('暂无预警信息'),
        ),
      );
    }
    // 展示预警信息列表
    return Scaffold(
      appBar: AppBar(
        title: const Text('预警信息'),
      ),
      body: ListView(
        children:
        (Get.arguments as List<Warning>).map((e) => _AlertItemWidget(warning: e)).toList(),
      ),
    );
  }
}

class _AlertItemWidget extends StatelessWidget {
  final Warning warning;

  const _AlertItemWidget({required this.warning});

  @override
  Widget build(BuildContext context) {
    // 展示容器
    return Container(
      // 设置内边距
      padding: const EdgeInsets.all(10),
      child: Column(
        // 子组件左对齐
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
