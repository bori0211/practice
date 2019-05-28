import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

import './db/event.dart';
import './widgets/side_drawer.dart';

void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  EventData.event.insert('Alarm', '{}');
}

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 세로만 되게
  final int helloAlarmID = 0;
  await AndroidAlarmManager.initialize();
  runApp(MyApp());
  await AndroidAlarmManager.periodic(const Duration(minutes: 1), helloAlarmID, printHello);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/': (BuildContext context) => MyHomePage(selectedType: 'Current'),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/'); // '/detail/1'
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'list') {
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => MyHomePage(selectedType: pathElements[2]),
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.selectedType}) : super(key: key);

  final String selectedType;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    print('now: $now');
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text(widget.selectedType),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              print('delete all');
              _showDeleteAllDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: EventData.event.getData(widget.selectedType),
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
                        if (await EventData.event.update(snapshot.data[index]['id'], targetType)) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('${snapshot.data[index]['id']} $targetType 상태로 변경됨'),
                          ));
                        }
                      } else if (direction == DismissDirection.startToEnd) {
                        print('Swiped start to end');
                        if (widget.selectedType == 'Current') targetType = 'Saved';
                        if (widget.selectedType == 'Saved') targetType = 'Current';
                        if (widget.selectedType == 'Deleted') targetType = 'Current';
                        if (await EventData.event.update(snapshot.data[index]['id'], targetType)) {
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
          EventData.event.insert('Button', '{}');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  _showDeleteAllDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('모든 이벤트를 삭제하시겠습니까?'),
            content: Text('삭제하면 되돌릴 수 없습니다.'),
            actions: <Widget>[
              FlatButton(
                child: Text('취소'),
                textColor: Colors.grey,
                onPressed: () {
                  print('취소함');
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('삭제'),
                textColor: Colors.black,
                onPressed: () async {
                  print('승인');
                  Navigator.pop(context); // alert 닫힘
                  // 데이터 전체 UPDATE(Deleted) 후 리스트로 돌아감
                  if (await EventData.event.deleteAll('Deleted')) {
                    //Navigator.pop(context, true);
                    Navigator.pushReplacementNamed(context, '/list/Current');
                  }
                },
              ),
            ],
          );
        });
  }
}
