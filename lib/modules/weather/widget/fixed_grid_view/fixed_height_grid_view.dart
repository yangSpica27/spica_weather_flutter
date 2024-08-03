
import 'package:flutter/material.dart';
import 'package:spica_weather_flutter/modules/weather/widget/fixed_grid_view/grid_row.dart';


class FixedHeightGridView extends StatelessWidget {
  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;

  const FixedHeightGridView({
    super.key,
    required this.itemCount,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 10,
    this.mainAxisSpacing = 10,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.controller,
    this.shrinkWrap = false,
    this.physics = const BouncingScrollPhysics(),
    this.padding = const EdgeInsets.only(),
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      itemBuilder: (ctx, columnIndex) {
        return GridRow(
          columnIndex: columnIndex,
          builder: builder,
          itemCount: itemCount,
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisAlignment: rowCrossAxisAlignment,
        );
      },
      itemCount: _columnLength(),
    );
  }

  int _columnLength() {
    if (itemCount % crossAxisCount == 0) {
      return itemCount ~/ crossAxisCount;
    } else {
      return (itemCount ~/ crossAxisCount) + 1;
    }
  }
}
