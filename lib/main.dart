import 'package:flutter/material.dart';

import 'scrollable_canvas.dart';

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