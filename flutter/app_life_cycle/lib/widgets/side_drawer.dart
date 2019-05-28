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
            title: Text('대기중인 제품'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/list/대기중');
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('판매중인 제품'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/list/판매중');
            },
          ),
          ListTile(
            leading: Icon(Icons.send),
            title: Text('판매 종료된 제품'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/list/판매종료');
            },
          ),
        ],
      ),
    );
  }
}
