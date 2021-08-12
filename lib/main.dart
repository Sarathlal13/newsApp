import 'package:flutter/material.dart';
import 'package:news_app/screens/newslist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: NewsList(),
    );
  }
}
