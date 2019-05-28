import 'package:flutter/material.dart';

import './message_bloc.dart';

class MessageProvider extends InheritedWidget {
  final MessageBloc messageBloc = MessageBloc();

  MessageProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static MessageBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(MessageProvider) as MessageProvider).messageBloc;
  }
}
