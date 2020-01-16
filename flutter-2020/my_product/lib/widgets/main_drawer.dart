import "package:flutter/material.dart";

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Choose"),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("HOME"),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
          ListTile(
            leading: Icon(Icons.portrait),
            title: Text('PRODUCT'),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/product");
            },
          ),
        ],
      ),
    );
  }
}
