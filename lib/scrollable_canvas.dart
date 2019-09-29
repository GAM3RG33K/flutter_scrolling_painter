import 'dart:math';

import 'package:flutter/material.dart';

import 'scrollable_painter.dart';

class ScrollableCanvas extends StatefulWidget {
  @override
  _ScrollableCanvasState createState() => _ScrollableCanvasState();
}

class _ScrollableCanvasState extends State<ScrollableCanvas> {
  ViewData _viewData;

  double _previousScale;

  @override
  void initState() {
    _viewData = ViewData(
      items: getDummyItems(),
      barWidth: 25,
      startPadding: 8,
      initialPosition: 0,
      startIndex: 0,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onHorizontalDragUpdate: onDragUpdate,
        onScaleStart: onScaleStart,
        onScaleUpdate: onScaleUpdate,
        onScaleEnd: onScaleEnd,
        child: Container(
          color: Colors.white,
          child: CustomPaint(
            foregroundPainter: ScrollingPainter(_viewData),
            child: Container(),
          ),
        ),
        behavior: HitTestBehavior.opaque,
      ),
    );
  }

  void onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _viewData.setPosition(details.delta.dx);
    });
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      var scale = details.scale;
      var difference = (_previousScale - scale).abs();
      if (difference >= 0.4) {
        _viewData.barWidth *= scale;
        _previousScale = scale;
      }
    });
  }

  void onScaleEnd(ScaleEndDetails details) {
    _previousScale = 0.0;
  }

  void onScaleStart(ScaleStartDetails details) {
    _previousScale = 0.0;
  }
}

class ViewData {
  List<int> items;
  double barWidth = 0;
  double startPadding = 0;
  double initialPosition = 0;
  int startIndex = 0;
  int endIndex = 0;
  Size display;

  double get displayWidth => display?.width ?? 0;
  double get displayHeight => display?.height ?? 0;

  double get xAxisPosition => displayHeight - startPadding;
  double get yAxisPosition => displayWidth - startPadding;
  int get maxIndex => items.length;
  int get minIndex => 0;
  double get maxWidth => maxIndex * barWidth + startPadding - displayWidth;
  double get minWidth => (minIndex * barWidth) + startPadding;

  ViewData(
      {this.items,
      this.barWidth,
      this.initialPosition,
      this.startPadding,
      this.startIndex,
      this.display}) {
    endIndex = startIndex + visualCandles;
  }

  double get currentXPosition => startPadding + startIndex * barWidth;

  int get visualCandles => ((displayWidth - startPadding) ~/ barWidth);

  setPosition(double newPosition) {
    int index = getVisualIndex(-newPosition);
    updateIndex(index);
  }

  int getVisualIndex(double newPosition) {
    var difference = (newPosition ~/ barWidth);
    return difference;
  }

  void updateIndex(int index) {
    startIndex += index;
    if (startIndex < minIndex) {
      startIndex = minIndex;
    }

    endIndex = startIndex + visualCandles;
    if (endIndex > maxIndex) {
      endIndex = maxIndex;
      startIndex = endIndex - visualCandles;
    }
  }
}

List<int> getDummyItems() {
  List<int> items = List<int>(120);
  for (int i = 0; i < items.length; i++) {
    var randomVal = Random().nextInt(items.length);
    items[i] = randomVal % 15 +1;
  }
  return items;
}
