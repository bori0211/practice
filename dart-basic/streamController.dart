import 'dart:async';

void main() {
  final controller = StreamController.broadcast();

  final newStream = controller.stream.map((event) {
    print(event);
    return event;
  });

  newStream.listen((event) {});
  newStream.listen((event) {});
  newStream.listen((event) {});
  newStream.listen((event) {});
  newStream.listen((event) {});

  controller.sink.add(1);
}
