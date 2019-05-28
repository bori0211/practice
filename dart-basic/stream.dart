import 'dart:async';

class Cake {}

class Order {
  String type;
  Order(this.type);
}

// Sink는 이벤트의 소스 (주로 flutter에서 제공함) (직접 만들지 않음)
// button.onClick일 경우 (ElementStream<MouseEvent>)

void main() {
  final controller = new StreamController();

  final order = new Order('choco'); // 고객 (원하는 케익을 주문)

  // 케익을 만드는 사람
  final baker = new StreamTransformer.fromHandlers(handleData: (cakeType, sink) {
    if (cakeType == 'choco') {
      sink.add(new Cake()); // 최종 케익을 생성
    } else {
      sink.addError('I cant bake the type!!!');
    }
  });

  controller.sink.add(order); // 주문을 받는 사람

  // 주문을 검사(Inspector)하는 사람, Pickup Office (최종 결과물)
  controller.stream
      .map(
        (order) => order.type,
      )
      .transform(baker)
      .listen(
        (cake) => print('Heres your cake $cake'),
        onError: (err) => print(err),
      );
}
