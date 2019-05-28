import 'package:scoped_model/scoped_model.dart';

import '../models/user.dart';

mixin UserModel on Model {
  User _authenticatedUser;

  void login(String email, String password) {
    _authenticatedUser = User(id: '1234', email: email, password: password);
    print(_authenticatedUser);
  }
}

/*
import 'package:scoped_model/scoped_model.dart';

import '../models/user.dart';

class UserModel extends Model {
  User _authenticatedUser;

  void login(String email, String password) {
    _authenticatedUser = User(id: 'fdalsdfasf', email: email, password: password);
  }
}
*/
