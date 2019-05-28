import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

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
  String _message = 'first';
  final Map<String, dynamic> _bgData = {'act': 'insert', 'type': 'default', 'data': 'default'};

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _addMessage(String message) {
    setState(() {
      _message += '\n$message';
    });
  }

  @override
  void initState() {
    ////
    // 1.  Listen to events (See docs for all 12 available events).
    //

    // Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[현재위치] - $location');
      _addMessage('[현재위치] - $location');
      _bgData['type'] = 'onLocation';
      _bgData['data'] = location.toString();
      _postStampbook();
    });

    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print('[모션변경] - $location');
      _addMessage('[모션변경] - $location');
    });

    // Fired whenever the state of location-services changes.  Always fired at boot
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      print('[프로바이더] - $event');
      _addMessage('[프로바이더] - $event');
    });

    ////
    // 2.  Configure the plugin
    //
    bg.BackgroundGeolocation.ready(bg.Config(
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            /*distanceFilter: 10.0, */ /* 자동 계산됨 */
            stopOnTerminate: false,
            startOnBoot: true,
            debug: false,
            logLevel: bg.Config.LOG_LEVEL_ERROR,
            reset: true))
        .then((bg.State state) {
      print('시작됨 ${state.enabled}');
      if (!state.enabled) {
        ////
        // 3.  Start the plugin.
        //
        bg.BackgroundGeolocation.start();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              '$_message',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<bool> _postStampbook() async {
    try {
      //print(json.encode(_formData));
      final http.Response response = await http.post(
        'https://express.datafirst.co.kr/stampbook/models',
        headers: {"Content-Type": "application/json"},
        body: json.encode(_bgData),
      );
      if (response.statusCode != 200 && response.statusCode != 201) return false;
      // 여기에서 State에 저장
      return true;
    } catch (error) {
      return false;
    }
  }
}
