import 'package:flutter/material.dart';
//import 'package:map_view/map_view.dart';

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  Uri _staticMapUri;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(),
        SizedBox(
          height: 10.0,
        ),
        //Image.network(_staticMapUri.toString()),
      ],
    );
  }

  /*void getStaticMap() {
    final StaticMapProvider staticMapProvider = StaticMapProvider('AIzaSyCGcTGlgjslXN6n_iQbNVIn4VGHjKUBSxc');
    final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers(
      [
        Marker('position', 'Position', 41.40338, 2.17403),
      ],
      center: Location(41.40338, 2.17403),
      width: 500,
      height: 300,
      maptype: StaticMapViewType.roadmap,
    );

    setState(() {
      _staticMapUri = staticMapUri;
    });
  }*/
}
