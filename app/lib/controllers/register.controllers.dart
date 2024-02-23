import 'package:app/connections/auth.dart';
import 'package:flutter/material.dart';

class RegisterControllers {
  register(
    TextEditingController nameController,
    TextEditingController emailControllers,
    TextEditingController passowrdControllers,
    TextEditingController stateControllers,
    TextEditingController universityControllers,
  ) async {
    String name = nameController.text;

    String email = emailControllers.text;
    String password = passowrdControllers.text;
    String state = stateControllers.text;
    String university = universityControllers.text;

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      List response = await AuthConnections().registerUser(
        name:name,
          mail: email,
          password: password,
          state: state,
          university: university);
      return response;
    } else {
      return [false, "Por Favor, llena los campos."];
    }
  }
}
