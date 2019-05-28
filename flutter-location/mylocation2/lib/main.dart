import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My MaterialApp Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'My Location 2 Demo'),
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

  Location _locationService = new Location();
  bool _permission = false;

  LocationData _startLocation;
  LocationData _currentLocation;

  @override
  void initState() {
    _initLocationState();

    super.initState();
  }

  void _initLocationState() async {
    // _locationService 시작
    await _locationService.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData initLocation;

    _addMessage('_initLocationState');

    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      _addMessage('Service status: $serviceStatus');

      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        _addMessage('_permission: $_permission');

        if (_permission) {
          initLocation = await _locationService.getLocation();
          _addMessage('initLocation (accuracy): ${initLocation.accuracy}');
          _addMessage('initLocation (altitude): ${initLocation.altitude}');
          _addMessage('initLocation (heading): ${initLocation.heading}');
          _addMessage('initLocation (latitude): ${initLocation.latitude}');
          _addMessage('initLocation (longitude): ${initLocation.longitude}');
          _addMessage('initLocation (speed): ${initLocation.speed}');
          _addMessage('initLocation (speedAccuracy): ${initLocation.speedAccuracy}');
          _addMessage('initLocation (time): ${initLocation.time}');

          _locationService.onLocationChanged().listen((LocationData currentLocation) async {
            _addMessage('currentLocation (accuracy): ${initLocation.accuracy}');
            _addMessage('currentLocation (altitude): ${initLocation.altitude}');
            _addMessage('currentLocation (heading): ${initLocation.heading}');
            _addMessage('currentLocation (latitude): ${initLocation.latitude}');
            _addMessage('currentLocation (longitude): ${initLocation.longitude}');
            _addMessage('currentLocation (speed): ${initLocation.speed}');
            _addMessage('currentLocation (speedAccuracy): ${initLocation.speedAccuracy}');
            _addMessage('currentLocation (time): ${initLocation.time}');
          });
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        _addMessage('error: PERMISSION_DENIED');
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _addMessage('error: SERVICE_STATUS_ERROR');
      }
    }
  }

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
}
