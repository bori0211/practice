//import 'package:prompter_sg/src/terminal.dart';
//import 'package:prompter_sg/src/option.dart';
//import 'package:prompter_sg/src/prompter.dart';
import 'package:prompter_sg/prompter_sg.dart';

void main() {
  //var terminal = new Terminal();

  /*
  terminal.clearScreen();
  terminal.printPrompt('Hi therr!');
  var input = terminal.collectInput();
  print('You just entered: $input');
  */

  /*
  terminal.printOptions(options);
  var response = terminal.collectInput();
  print('You just entered: $response');
  */

  final options = [
    new Option('I want red', '#f00'),
    new Option('I want blue', '#00f')
  ];

  final prompter = new Prompter();
  String colorCode = prompter.askMultiple('What color do you want', options);
  bool answer = prompter.askBinary('Do you like dart');

  print(colorCode);
  print(answer);
}
