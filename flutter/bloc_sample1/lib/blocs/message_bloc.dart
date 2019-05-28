import 'dart:async';

class MessageBloc {
  final _message = StreamController<String>.broadcast();

  // Stream
  //Stream<String> get message => _message.stream;
  Stream<String> get message => _message.stream.transform(messageTransformer);

  // Sink
  Function(String) get setMessage => _message.sink.add;

  MessageBloc() {
    init();
  }

  init() async {
    //print('init');
    await Future.delayed(Duration(seconds: 2));
    setMessage('message');
  }

  final messageTransformer = new StreamTransformer<String, String>.fromHandlers(handleData: (message, sink) {
    if (message == 'choco') {
      sink.add('choco'); // 최종 케익을 생성
    } else {
      sink.addError('input choco!!!');
    }
  });

  lastMessageShow(String validMessage) {
    //final validMessage = message.toString();
    print('Message is $validMessage');
  }

  dispose() {
    _message.close();
  }
}
