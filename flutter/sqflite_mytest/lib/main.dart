import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  void _incrementCounter() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    // Delete the database
    await deleteDatabase(path);

    print(path);

    // Open the database
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE test (id INTEGER PRIMARY KEY, name TEXT, value INTEGET, num READ)');
      },
    );

    // Insert some records in a transaction
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert('INSERT INTO test (name, value, num) VALUES ("some name", 1234, 456.789)');
      print('inserted1: $id1');
      int id2 = await txn.rawInsert('INSERT INTO test (name, value, num) VALUES (?, ?, ?)', ['another name', 12345678, 3.1416]);
      print('inserted2: $id2');
    });

    // Update some record
    int count = await database.rawUpdate('UPDATE test SET name = ?, value = ? WHERE name = ?', ['updated name', 9876, 'some name']);
    print('update: $count');

    // Get the record
    List<Map> list = await database.rawQuery('SELECT * FROM test');
    List<Map> exceptList = [
      {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
      {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
    ];

    print('DB');
    print(list);
    print('Var');
    print(exceptList);

    //assert(1 == 2);

    // Count the records
    count = Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM test'));
    print('COUNT: $count');

    // Delete a record
    count = await database.rawDelete('DELETE FROM test WHERE name = ?', ['another name']);
    print('delete: $count');

    // Close the database
    await database.close();

    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
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
