import 'dart:async';

import 'package:flutter/material.dart';

import '../blocs/message_bloc.dart';
import '../blocs/message_provider.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MessageBloc messageBloc = MessageProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc Sample 1'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(height: 12.0),
            Text('Sample child1'),
            _buildChild1(context),
            Container(height: 12.0),
            Text('Sample child2'),
            _buildChild2(),
            Container(height: 24.0),
            Divider(),
            _buildMessageTextFiled(messageBloc),
            Divider(),
            _buildSubmit(messageBloc),
          ],
        ),
      ),
    );
  }

  Widget _buildChild1(BuildContext context) {
    final MessageBloc messageBloc2 = MessageProvider.of(context);
    return StreamBuilder(
      stream: messageBloc2.message,
      builder: (BuildContext context, snapshot) {
        print(snapshot.data);
        return Container(
          child: Text(snapshot.data ?? ''),
        );
      },
    );
  }

  Widget _buildChild2() {
    return Container(
      child: Text('한글'),
    );
  }

  Widget _buildMessageTextFiled(MessageBloc messageBloc) {
    return StreamBuilder(
      stream: messageBloc.message,
      builder: (BuildContext context, snapshot) {
        return TextField(
          decoration: InputDecoration(
            labelText: 'Message',
            hintText: 'choco',
            errorText: snapshot.error,
          ),
          onChanged: (String str) => messageBloc.setMessage(str),
        );
      },
    );
  }

  Widget _buildSubmit(MessageBloc messageBloc) {
    return StreamBuilder(
      stream: messageBloc.message,
      builder: (BuildContext context, snapshot) {
        print(snapshot.hasData);
        return RaisedButton(
          child: Text('Submit'),
          color: Colors.blue,
          onPressed: snapshot.hasData
              ? () {
                  messageBloc.lastMessageShow(snapshot.data);
                }
              : null,
        );
      },
    );
  }
}
