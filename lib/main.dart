import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[200],
      child: ScrollableCanvas(),
    );
  }
}

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
      items: [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        9,
        8,
        7,
        6,
        5,
        4,
        3,
        2,
        1,
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        9,
        8,
        7,
        6,
        5,
        4,
        3,
        2,
        1,
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        9,
        8,
        7,
        6,
        5,
        4,
        3,
        2,
        1,
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        9,
        8,
        7,
        6,
        5,
        4,
        3,
        2,
        1,
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        9,
        8,
        7,
        6,
        5,
        4,
        3,
        2,
        1,
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        9,
        8,
        7,
        6,
        5,
        4,
        3,
        2,
        1,
      ],
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

class ScrollingPainter extends CustomPainter {
  final ViewData _viewData;

  ScrollingPainter(this._viewData);

  @override
  void paint(Canvas canvas, Size size) {
    if (_viewData.display == null) {
      _viewData.display = size;
    }
    _drawAxis(canvas, size);
    _drawCandles(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void _drawAxis(Canvas canvas, Size size) {
    double xPosition;
    double yPosition;
    // position for x-axis
    xPosition = 0;
    yPosition = _viewData.xAxisPosition;
    canvas.drawLine(Offset(xPosition, yPosition),
        Offset(xPosition + _viewData.yAxisPosition, yPosition), _getPaint());

    // position for y-axis
    xPosition = _viewData.yAxisPosition;
    yPosition = 0;
    canvas.drawLine(Offset(xPosition, yPosition),
        Offset(xPosition, _viewData.xAxisPosition), _getPaint());
  }

  Paint _getPaint({bool fill = false}) {
    return Paint()
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..isAntiAlias = true
      ..color = Colors.blue;
  }

  void _drawCandles(Canvas canvas, Size size) {
    double xPosition = 0;
    double yPosition =
        (size.height - _viewData.startPadding) / 2 + _viewData.startPadding;
    // int currentIndex = _viewData.currentXPosition ~/ _viewData.barWidth;
    for (int i = _viewData.startIndex; i < _viewData.items.length; i++) {
      var item = _viewData.items[i];
      if (xPosition > _viewData.yAxisPosition - _viewData.startPadding) {
        return;
      }
      canvas.drawRect(
          Rect.fromLTWH(
              xPosition + (_viewData.barWidth * 0.17),
              (yPosition - (item * 10)),
              _viewData.barWidth * 0.65,
              item * 20.0),
          _getPaint(fill: true));

      _drawText(
        canvas,
        i.toString(),
        (xPosition),
        yPosition,
        _viewData.barWidth * 0.4,
      );
      xPosition += _viewData.barWidth;
    }
  }

  void _drawText(Canvas canvas, String text, double xPosition, double yPosition,
      double fontSize) {
    TextPainter painter = TextPainter(
        text: TextSpan(
            text: text,
            style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold)),
        textAlign: TextAlign.start,
        textDirection: TextDirection.ltr);
    painter.layout();
    painter.paint(
        canvas, Offset(xPosition + fontSize * 0.5, yPosition - fontSize * 0.5));
  }
}
