import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var list;
  var random;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    random = Random();
    _handleRefresh();
    //list = List.generate(random.nextInt(10), (i) => "Item $i");
  }

  Future<Null> _handleRefresh() async {
    print('_handleRefresh');
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      list = List.generate(random.nextInt(10), (i) => "Item $i");
    });
    refreshKey.currentState?.show(atTop: false);

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) => ListTile(
                title: Text(list[i]),
              ),
        ),
        onRefresh: _handleRefresh,
      ),
    );
  }

  /*List<Widget> _getItems() {
    var items = <Widget>[];

    for (int i = _counter; i < _counter + 4; _counter++) {
      var item = Column(
        children: <Widget>[
          ListTile(
            title: Text('Item $i'),
          ),
          Divider(
            height: 2.0,
          ),
        ],
      );

      items.add(item);
    }

    return items;
  }*/
}
