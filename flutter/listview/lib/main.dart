import 'package:flutter/material.dart';

import './pages/product_list.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLOC Title',
      home: ProductList(),
    );
  }
}
