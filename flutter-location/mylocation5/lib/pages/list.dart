import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import '../widgets/side_drawer.dart';

class ListPage extends StatefulWidget {
  final String selectedType;

  ListPage(this.selectedType);

  @override
  State<StatefulWidget> createState() {
    return _ListPageState();
  }
}

class _ListPageState extends State<ListPage> {
  Database _database;
  //List<Map> _list;

  @override
  void initState() {
    ////
    // 1.  Listen to events (See docs for all 12 available events).
    //

    // Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      _insertEvent('[현재위치]', location.toString());
      print('[현재위치] - $location');
      //_addMessage('[현재위치] - $location');
      //_bgData['type'] = 'onLocation';
      //_bgData['data'] = location.toString();
      //_postStampbook();
    });

    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      _insertEvent('[모션변경]', location.toString());
      print('[모션변경] - $location');
      //_addMessage('[모션변경] - $location');
    });

    // Fired whenever the state of location-services changes.  Always fired at boot
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      _insertEvent('[프로바이더]', event.toString());
      print('[프로바이더] - $event');
      //_addMessage('[프로바이더] - $event');
    });

    ////
    // 2.  Configure the plugin
    //
    bg.BackgroundGeolocation.ready(bg.Config(
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10,
            /* 10m */
            /*locationUpdateInterval: 6000,*/
            /*deferTime: 12000,*/
            forceReloadOnLocationChange: false,
            stopOnTerminate: false,
            startOnBoot: true,
            debug: false,
            /*enableHeadless: true,*/
            logLevel: bg.Config.LOG_LEVEL_ERROR,
            reset: true))
        .then((bg.State state) {
      print('시작됨 $state');
      _insertEvent('[시작됨]', state.toString());
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
    //_addMessage('[현재위치] - aaaa');
    //print(_tableData);
    //print(list);
    var now = new DateTime.now();
    print('now: $now');
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text(widget.selectedType),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key('$index'),
                    onDismissed: (DismissDirection direction) async {
                      String targetType = '';
                      if (direction == DismissDirection.endToStart) {
                        print('Swiped end to start');
                        if (widget.selectedType == 'Current') targetType = 'Deleted';
                        if (widget.selectedType == 'Saved') targetType = 'Deleted';
                        if (widget.selectedType == 'Deleted') targetType = 'Trash';
                        if (await _updateEvent(snapshot.data[index]['id'], targetType)) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('${snapshot.data[index]['id']} $targetType 상태로 변경됨'),
                          ));
                        }
                      } else if (direction == DismissDirection.startToEnd) {
                        print('Swiped start to end');
                        if (widget.selectedType == 'Current') targetType = 'Saved';
                        if (widget.selectedType == 'Saved') targetType = 'Current';
                        if (widget.selectedType == 'Deleted') targetType = 'Current';
                        if (await _updateEvent(snapshot.data[index]['id'], targetType)) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('${snapshot.data[index]['id']} $targetType 상태로 변경됨'),
                          ));
                        }
                      } else {
                        print('Other swiped');
                      }
                    },
                    background: Container(color: Colors.green),
                    secondaryBackground: Container(color: Colors.red),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage('https://demo.kidneylife.co.kr/upload/11111111/pat_profile/source/20171215102403_movie_image.jpg'),
                      ),
                      title: Text("(${snapshot.data[index]['id']}) ${snapshot.data[index]['event_type']} (${snapshot.data[index]['event_date']})"),
                      subtitle: Text(snapshot.data[index]['location_json']),
                      onTap: () {
                        //print(111);
                        //Navigator.pushNamed<bool>(context, '/detail/${snapshot.data[index].id}');
                      },
                      //onTap: () => Navigator.pushNamed<bool>(context, '/product/' + '335'),
                      //onTap: () => Navigator.pushNamed(context, '/detail/' + snapshot.data[index].index),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('no no...'),
              );
            }
          },
        ),
        //child: Text(_message),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _insertEvent('Button', '{}');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<Database> _initDatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'myStamp.db');

    // Delete the database
    //await deleteDatabase(path);

    print(path);

    // Open the database
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE dev_event (id INTEGER PRIMARY KEY, type TEXT, event_type TEXT, location_json TEXT, event_date TEXT)');
      },
    );

    return _database;
  }

  Future<List<Map>> _getData() async {
    if (_database == null) _database = await _initDatabase();

    List<Map> list = await _database
        .rawQuery("SELECT id, type, event_type, location_json, event_date FROM dev_event WHERE type = '${widget.selectedType}' ORDER BY id DESC");

    //print(list);

    return list;
  }

  void _insertEvent(String eventType, String locationJson) async {
    if (_database == null) _database = await _initDatabase();

    // Insert some records in a transaction
    await _database.transaction((txn) async {
      //int id1 = await txn.rawInsert("INSERT INTO dev_event (type, event_type, location_json, event_date) VALUES ('Current', 'Plus', 1234, 456.789)");
      //print('inserted1: $id1');
      var eventDate = new DateTime.now();
      int id2 = await txn.rawInsert('INSERT INTO dev_event (type, event_type, location_json, event_date) VALUES (?, ?, ?, ?)',
          ['Current', eventType, locationJson, eventDate.toString()]);
      print('inserted2: $id2');
    });

    //_getData();
    //List<Map> list = await _database.rawQuery('SELECT id, name, value, num FROM dev_event');
    //return list;
  }

  Future<bool> _updateEvent(int selectedId, String targetType) async {
    try {
      if (_database == null) _database = await _initDatabase();

      // Update some record
      int count = await _database.rawUpdate("UPDATE dev_event SET type = '$targetType' WHERE id = $selectedId");
      print('update: $selectedId -> $targetType');

      return true;
    } catch (error) {
      return false;
    }
  }
}
