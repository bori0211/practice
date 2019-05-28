import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './db/event.dart';
import './bloc/prefs_bloc.dart';
import './pages/list.dart';

void main() async {
  //final int checkCurrentPositionAlarmID = 0;
  //await AndroidAlarmManager.initialize();
  //await AndroidAlarmManager.periodic(const Duration(minutes: 1), checkCurrentPositionAlarmID, checkCurrentPosition);

  print('main');
  // 세로만 되게
  if (await EventData.event.insert('main', '{}')) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
      final prefsBloc = PrefsBloc();
      //EventData.event.insert('Start', '{}');
      runApp(MyApp(
        prefsBloc: prefsBloc,
      ));
    });
  }
}

class MyApp extends StatelessWidget {
  final PrefsBloc prefsBloc;

  MyApp({Key key, this.prefsBloc}) : super(key: key) {
    print('[MyApp - StatelessWidget] Constructor');
  }

  @override
  Widget build(BuildContext context) {
    print('MyApp build');
    //EventData.event.insert('Start', '{}');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/': (BuildContext context) {
          //EventData.event.insert('Start', '{}');
          return ListPage(prefsBloc: prefsBloc, selectedType: 'Current');
        },
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/'); // '/detail/1'
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'list') {
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ListPage(prefsBloc: prefsBloc, selectedType: pathElements[2]),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        print('1111');
        return null;
      },
    );
  }
}
