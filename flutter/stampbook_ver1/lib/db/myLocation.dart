import 'dart:async';

import 'package:location/location.dart';

class MyLocationData {
  MyLocationData._();

  static final MyLocationData myLoc = MyLocationData._();
  Location _location;

  Future<Location> _initLocation() async {
    _location = new Location();

    return _location;
  }

  Future<bool> getLoc() async {
    if (_location == null) _location = await _initLocation();

    LocationData currentLocation = await _location.getLocation();

    print('getLoc = ${currentLocation.latitude}');

    return true;
  }
}
