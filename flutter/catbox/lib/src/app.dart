import 'package:flutter/material.dart';

import 'screens/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '고양이 상자',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}
