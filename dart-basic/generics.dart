void main() {
  // 기본
  List<String> langList = [];

  langList.add('node');
  langList.add('dart');
  //langList.add(123); <String> 으로 했기 때문에 숫자를 넣을 수 없음
  print(langList);

  // Class
  var circleSlot = new Slot<Circle>();
  //circleSlot.insert(new Square()); (Square는 넣을 수 없음)
  circleSlot.insert(new Circle());
}

class Circle {}

class Square {}

class Slot<T> {
  insert(T shape) {}
}
