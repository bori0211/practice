import 'package:flutter/material.dart';

import '../bloc/prefs_bloc.dart';

class SideDrawer extends StatelessWidget {
  final PrefsBloc prefsBloc;

  SideDrawer({
    Key key,
    this.prefsBloc,
  }) : super(key: key);

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
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              _showPrefsSheet(context, prefsBloc);
            },
          ),
        ],
      ),
    );
  }

  void _showPrefsSheet(BuildContext context, PrefsBloc bloc) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Scaffold(
            body: Center(
              child: StreamBuilder(
                stream: bloc.currentPrefs,
                builder: (BuildContext context, AsyncSnapshot<PrefsState> snapshot) {
                  return snapshot.hasData
                      ? Switch(
                          value: snapshot.data.showWebView,
                          onChanged: (b) => bloc.showWebViewPref.add(b),
                        )
                      : Text('Nothing');
                },
              ),
            ),
          );
        });
  }
}
