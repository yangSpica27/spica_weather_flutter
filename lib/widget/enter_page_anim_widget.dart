import 'dart:async';

import 'package:flutter/material.dart';

/// 封装的实现组件入场效果的Widget
class EnterPageAnimWidget extends StatefulWidget {
  const EnterPageAnimWidget(
      {super.key,
      this.startOffset,
      this.endOffset,
      required this.child,
      this.startOpacity,
      this.endOpacity,
      this.duration,
      this.startScale = 1.0,
      this.endScale = 1.0,
      this.delay});

  /// 开始的偏移量
  final Offset? startOffset;

  /// 结束的偏移量
  final Offset? endOffset;

  /// 动画持续时间
  final Duration? duration;

  /// 开始的透明度
  final double? startOpacity;

  /// 结束的透明度
  final double? endOpacity;

  /// 子组件
  final Widget child;

  /// 延迟时间
  final Duration? delay;

  /// 开始的缩放比例
  final double startScale;

  /// 结束的缩放比例
  final double endScale;

  @override
  State<EnterPageAnimWidget> createState() => _EnterPageAnimWidgetState();
}

/// 实现组件入场效果的State
class _EnterPageAnimWidgetState extends State<EnterPageAnimWidget>
    with SingleTickerProviderStateMixin {
  late final Tween<double> _opacityTween = Tween<double>(
      begin: widget.startOpacity ?? 0.0, end: widget.endOpacity ?? 1.0);

  late final Tween<Offset> _offsetTween = Tween<Offset>(
      begin: widget.startOffset ?? const Offset(0, 0),
      end: widget.endOffset ?? const Offset(0, 0));

  late final AnimationController _controller = AnimationController(
    duration: widget.duration ?? const Duration(milliseconds: 750),
    vsync: this,
  );

  late final Animation<double> _opacityAnimation = _opacityTween.animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );

  late final Animation<Offset> _offsetAnimation = _offsetTween.animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );

  late final _scaleAnimation =
      Tween<double>(begin: widget.startScale, end: widget.endScale)
          .animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutBack,
  ));

  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay ?? Duration.zero, () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// 使用RepaintBoundary包裹，避免动画过程中的重绘
    return RepaintBoundary(
      child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: SlideTransition(
              position: _offsetAnimation,
              child: widget.child,
            ),
          )),
    );
  }
}
