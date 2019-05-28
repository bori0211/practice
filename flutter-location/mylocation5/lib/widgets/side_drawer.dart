import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Current'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/list/Current');
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Saved'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/list/Saved');
            },
          ),
          ListTile(
            leading: Icon(Icons.send),
            title: Text('Deleted'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/list/Deleted');
            },
          ),
        ],
      ),
    );
  }
}
