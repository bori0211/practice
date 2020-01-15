import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:map_view/map_view.dart';

import './pages/auth.dart';
import './pages/list.dart';
import './pages/detail.dart';
import './pages/form.dart';

void main() {
  //MapView.setApiKey('AIzaSyCGcTGlgjslXN6n_iQbNVIn4VGHjKUBSxc');
  runApp(MySplash());
}
//void main() => runApp(LifeCycleApp());

class MySplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.grey,
      ),*/
      theme: ThemeData.light(),
      //home: SplashScreen(),
      routes: {
        '/': (BuildContext context) => SplashScreen(),
        //'/': (BuildContext context) => LifeCycleApp(),
        '/auth': (BuildContext context) => AuthPage(),
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
        if (pathElements[1] == 'detail') {
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
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        print('1111');
        return null;
      },
      //debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //Timer(Duration(seconds: 5), () => print('Splash Done'));
    Timer(Duration(seconds: 5), () => Navigator.pushReplacementNamed(context, '/auth'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.redAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50.0,
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.greenAccent,
                        size: 50.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                      ),
                    ),
                    Text(
                      'FlutKart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                      ),
                    ),
                    Text(
                      'Online Store\nFor Everyone',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/*
 [Stateless Widgets]
 1. Constructor Function
 2. build()
 */
class LifeCycleApp extends StatelessWidget {
  LifeCycleApp() {
    print('[LifeCycleApp - StatelessWidget] Constructor Function');
  }

  @override
  Widget build(BuildContext context) {
    print('[LifeCycleApp - StatelessWidget] build()');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

/*
 [Stateful Widgets]
 1. Constructor Function
 2. initState()
 3. build()
 4. setState()
 5. didUpdateWidget()
 6. build()
 */
class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key) {
    print('[MyHomePage - StatefulWidget] Constructor');
  }

  @override
  _MyHomePageState createState() {
    print('[MyHomePage - StatefulWidget] craeteState()');
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    print('[MyHomePage - StatefulWidget] initState()');
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    print('[MyHomePage - StatefulWidget] didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print('[MyHomePage - StatefulWidget] dispose()');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('[MyHomePage - StatefulWidget] build()');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: OrientationBuilder(builder: (BuildContext context, Orientation orientation) {
        print('orientation: $orientation');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
                style: TextStyle(
                  color: orientation == Orientation.portrait ? Colors.blue : Colors.red,
                ),
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = ${state.toString()}');
    /*switch (state) {
      case AppLifecycleState.inactive:
        print('*** inactive ***');
        break;
      case AppLifecycleState.paused:
        print('*** paused ***');
        break;
      case AppLifecycleState.resumed:
        print('*** resumed ***');
        break;
      case AppLifecycleState.suspending:
        print('*** suspending ***');
        break;
    }*/
    super.didChangeAppLifecycleState(state);
  }
}
