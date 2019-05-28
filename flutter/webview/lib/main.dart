import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebviewScaffold(
        url: 'https://www.datafirst.co.kr',
        withZoom: false,
        scrollBar: false,
      ),
    );

    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    /*
    return Scaffold(
      //appBar: AppBar(),
      body: WebviewScaffold(
        url: 'https://www.datafirst.co.kr',
        withZoom: false,
        scrollBar: false,
        appBar: new AppBar(
          title: new Text("Widget webview"),
        ),
      ),
    ); */
  }
}
