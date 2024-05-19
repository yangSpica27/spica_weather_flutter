import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 加载中的View
class LoadingDataView extends StatelessWidget {
  const LoadingDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 10.w),
          Text(
            '加载中...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
          ),
        ],
      ),
    );
  }
}
