import 'package:flutter/material.dart';

/// 数据加载失败视图
class FailDataView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const FailDataView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(message),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}
