import 'package:flutter/material.dart';

import './dark_theme_bloc.dart';

class DarkThemeProvider extends InheritedWidget {
  final DarkThemeBloc darkThemeBloc = DarkThemeBloc();

  DarkThemeProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static DarkThemeBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(DarkThemeProvider) as DarkThemeProvider).darkThemeBloc;
  }
}
