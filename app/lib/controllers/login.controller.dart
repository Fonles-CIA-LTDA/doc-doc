

import 'package:app/connections/auth.dart';
import 'package:flutter/material.dart';

class LoginControllers {
  login(TextEditingController emailControllers,
      TextEditingController passowrdControllers) async {
    String email = emailControllers.text;
    String password = passowrdControllers.text;

    if (email.isNotEmpty || password.isNotEmpty) {
      List response = await AuthConnections().login(email: email, password: password);
      return response;
    } else {
      return [false, "Por Favor, llena los campos."];
    }
  }
}
