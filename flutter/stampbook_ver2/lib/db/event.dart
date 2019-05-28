import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:location/location.dart';

class EventData {
  EventData._();

  static final EventData event = EventData._();
  Database _database;

  Future<Database> _initDatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'myStampBook.db');

    // Delete the database
    //await deleteDatabase(path);
    print(path);

    // Open the database
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE event (id INTEGER PRIMARY KEY, type TEXT, event_type TEXT, location_json TEXT, event_date TEXT)');
      },
    );

    return _database;
  }

  Future<List<Map>> getData(String eventType) async {
    if (_database == null) _database = await _initDatabase();

    List<Map> list = await _database.rawQuery("SELECT id, type, event_type, location_json, event_date FROM event WHERE type = '$eventType' ORDER BY id DESC");

    //print(list);

    return list;
  }

  Future<bool> insert(String eventType, String locationJson) async {
    if (_database == null) _database = await _initDatabase();

    try {
      var location = new Location();
      LocationData currentLocation = await location.getLocation();
      print('position ${currentLocation.latitude} ${currentLocation.longitude}');

      locationJson = 'latitude: ${currentLocation.latitude}, longitude: ${currentLocation.longitude}';

      // Insert some records in a transaction
      await _database.transaction((txn) async {
        //int id1 = await txn.rawInsert("INSERT INTO dev_event (type, event_type, location_json, event_date) VALUES ('Current', 'Plus', 1234, 456.789)");
        //print('inserted1: $id1');
        var eventDate = new DateTime.now();
        int id2 = await txn.rawInsert(
            'INSERT INTO event (type, event_type, location_json, event_date) VALUES (?, ?, ?, ?)', ['Current', eventType, locationJson, eventDate.toString()]);
        print('inserted2: $id2');
      });

      return true;
    } catch (e) {
      print(e);

      return false;
    }
  }

  Future<bool> update(int selectedId, String targetType) async {
    try {
      if (_database == null) _database = await _initDatabase();

      // Update some record
      int count = await _database.rawUpdate("UPDATE event SET type = '$targetType' WHERE id = $selectedId");
      print('count: $count,  $selectedId -> $targetType');

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteAll(String targetType) async {
    try {
      if (_database == null) _database = await _initDatabase();

      // Update some record
      int count = await _database.rawUpdate("UPDATE event SET type = '$targetType' WHERE type = 'Current'");
      print('update: $count (Current -> $targetType)');

      return true;
    } catch (error) {
      return false;
    }
  }
}
