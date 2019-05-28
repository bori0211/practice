class Person {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }

  greet() {
    console.log('Hello, my name is ' + this.name + ' and I am ' + this.age);
  }

  plusAge() {
    this.age += 1;
  }
}

let max = new Person('max', 20);

max.greet();
max.plusAge();
max.greet();
