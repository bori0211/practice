import 'package:flutter/material.dart';

import './pages/message.dart';
import './blocs/message_bloc.dart';
import './blocs/message_provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MessageProvider(
      child: MaterialApp(
        title: 'BLOC Title',
        home: Message(),
      ),
    );
  }
}
