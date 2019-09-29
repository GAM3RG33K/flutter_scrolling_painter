import 'package:flutter/material.dart';

import 'scrollable_canvas.dart';

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
