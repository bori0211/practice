import 'dart:async';

class DarkThemeBloc {
  final _darkThemeEnabled = StreamController<bool>.broadcast();

  // Stream
  Stream<bool> get darkThemeStream => _darkThemeEnabled.stream;

  // Sink
  Function(bool) get setDarkTheme => _darkThemeEnabled.sink.add;

  DarkThemeBloc() {
    init();
    //setDarkTheme(false);
  }

  init() async {
    //await Future.delayed(Duration(seconds: 5));
    setDarkTheme(false);
  }

  dispose() {
    _darkThemeEnabled.close();
  }
}
