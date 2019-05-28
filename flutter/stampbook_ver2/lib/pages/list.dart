import 'package:flutter/material.dart';

import '../db/event.dart';
import '../widgets/side_drawer.dart';
import '../bloc/prefs_bloc.dart';

class ListPage extends StatefulWidget {
  final PrefsBloc prefsBloc;
  final String selectedType;

  ListPage({Key key, this.prefsBloc, this.selectedType}) : super(key: key) {
    print('[ListPage - StatefulWidget] Constructor');
  }

  @override
  _ListPageState createState() {
    print('[ListPage - StatefulWidget] craeteState()');
    return _ListPageState();
  }
}

class _ListPageState extends State<ListPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('_ListPageState -> initState');
  }

  @override
  void didUpdateWidget(ListPage oldWidget) {
    print('_ListPageState - StatefulWidget -> didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    //print('_ListPageState = ${state.toString()}');
    switch (state) {
      case AppLifecycleState.inactive:
        print('*** inactive ***');
        break;
      case AppLifecycleState.paused:
        print('*** paused ***');
        break;
      case AppLifecycleState.resumed:
        print('*** resumed ***');
        if (await EventData.event.insert('Resumed', '{}')) {
          //Navigator.pop(context, true);
          Navigator.pushReplacementNamed(context, '/list/Current');
        }
        break;
      case AppLifecycleState.suspending:
        print('*** suspending ***');
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    print('_ListPageState -> dispose()');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var now = new DateTime.now();
    //print('now: $now');
    return Scaffold(
      drawer: SideDrawer(prefsBloc: widget.prefsBloc),
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
        //child: Text(_message),
        /* (prefs bloc)
        child: StreamBuilder<PrefsState>(
          stream: widget.prefsBloc.currentPrefs,
          builder: (BuildContext context, snapshot) {
            if (snapshot.data?.showWebView == true) {
              return Container(
                child: Text('111'),
              );
            } else {
              return Container(
                child: Text('222'),
              );
            }
          },
        ),
        */
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
                          /*Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                '${snapshot.data[index]['id']} $targetType 상태로 변경됨'),
                          ));*/
                          print('${snapshot.data[index]['id']} $targetType 상태로 변경됨');
                        }
                      } else if (direction == DismissDirection.startToEnd) {
                        print('Swiped start to end');
                        if (widget.selectedType == 'Current') targetType = 'Saved';
                        if (widget.selectedType == 'Saved') targetType = 'Current';
                        if (widget.selectedType == 'Deleted') targetType = 'Current';
                        if (await EventData.event.update(snapshot.data[index]['id'], targetType)) {
                          /*Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                '${snapshot.data[index]['id']} $targetType 상태로 변경됨'),
                          ));*/
                          print('${snapshot.data[index]['id']} $targetType 상태로 변경됨');
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await EventData.event.insert('Button', '{}')) {
            //Navigator.pop(context, true);
            Navigator.pushReplacementNamed(context, '/list/Current');
          }
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
      },
    );
  }
}
