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
        this.delay});

  final Offset? startOffset;

  final Offset? endOffset;

  final Duration? duration;

  final double? startOpacity;

  final double? endOpacity;

  final Widget child;

  final Duration? delay;

  @override
  State<EnterPageAnimWidget> createState() => _EnterPageAnimWidgetState();
}

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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: _offsetAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

extension EnterPageAnimWidgetExt on Widget {
  Widget enterPageAnim({
    Offset? startOffset,
    Offset? endOffset,
    Duration? duration,
    double? startOpacity,
    double? endOpacity,
  }) {
    return EnterPageAnimWidget(
      startOffset: startOffset,
      endOffset: endOffset,
      duration: duration,
      startOpacity: startOpacity,
      endOpacity: endOpacity,
      child: this,
    );
  }
}
