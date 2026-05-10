import 'package:flutter/material.dart';

class AuthPageChangeProvider extends ChangeNotifier {
  bool isLoginPage;
  AuthPageChangeProvider({this.isLoginPage = false});

  void changeWidget() {
    isLoginPage = !isLoginPage;
    notifyListeners();
  }
}
