import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:background_fetch/background_fetch.dart';

import './pages/list.dart';

/// Receive events from BackgroundGeolocation in Headless state.
void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
  //print('📬 --> $headlessEvent');
  print('backgroundGeolocationHeadlessTask');
}

void backgroundFetchHeadlessTask() async {
  // Get current-position from BackgroundGeolocation in headless mode.
  //bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
  print('[BackgroundFetch] HeadlessTask');
  print('backgroundFetchHeadlessTask');

  BackgroundFetch.finish();
}

void main() {
  runApp(MyApp());
  print('12345');

  /// Register BackgroundGeolocation headless-task.
  bg.BackgroundGeolocation.registerHeadlessTask(backgroundGeolocationHeadlessTask);

  /// Register BackgroundFetch headless-task.
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: ListPage('Current'),
      //debugShowCheckedModeBanner: false,
      routes: {
        '/': (BuildContext context) => ListPage('Current'),
        //'/auth': (BuildContext context) => AuthPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/'); // '/detail/1'
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'list') {
          //print('list:' + pathElements[2]);
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ListPage(pathElements[2]),
          );
        }
        /*if (pathElements[1] == 'detail') {
          //print('detail:' + pathElements[2]);
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => DetailPage(int.parse(pathElements[2])),
          );
        }
        if (pathElements[1] == 'new') {
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => FormPage('new', null),
          );
        }
        if (pathElements[1] == 'modify') {
          print('modify:' + pathElements[2]);
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => FormPage('modify', int.parse(pathElements[2])),
          );
        }*/
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        print('1111');
        return null;
      },
    );
  }
}
