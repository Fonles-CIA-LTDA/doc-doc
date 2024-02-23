import 'dart:convert';

import 'package:app/helpers/server.dart';
import 'package:app/main.dart';
import 'package:http/http.dart' as http;

class ConfigConnections {
  String pathConfig = "/api/users";

  getProfileInfo() async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.get(
          Uri.parse("$generalServer$pathConfig/${localStorage!.getInt("id")}"),
          headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }

  updateProfileInfo(name, state, university, email, password) async {
    try {
      var body = {};

      if (password.toString().isNotEmpty) {
        if (password.toString().length < 5) {
          return "La contraseña debe contener más de 5 caracteres.";
        } else {
          body = {
            "name": name,
            "email": email,
            "username": email,
            "state": state,
            "university": university,
            "password": password
          };
        }
      } else {
        if (name.isEmpty ||
            state.isEmpty ||
            university.isEmpty ||
            email.isEmpty) {
          return "Por favor, asegúrate de completar todos los campos";
        } else {
          body = {
            "name": name,
            "email": email,
            "username": email,
            "state": state,
            "university": university
          };
        }
      }
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.put(
          Uri.parse("$generalServer$pathConfig/${localStorage!.getInt("id")}"),
          headers: headers,
          body: jsonEncode(body));
      var decodeData = json.decode(response.body);
      if (response.statusCode != 200) {
        return "Error, Ponte en contacto con nuestro equipo de soporte.";
      } else {
        return "OK";
      }
    } catch (e) {
      return e.toString();
    }
  }

  updatePassword(password, id) async {
    try {
      if (password.toString().length < 5) {
        return "La contraseña debe contener más de 5 caracteres.";
      }

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer'
      };

      var response = await http.put(
          Uri.parse("$generalServer$pathConfig/${id}"),
          headers: headers,
          body: jsonEncode({"password": password}));
      var decodeData = json.decode(response.body);
      print(decodeData);
      if (response.statusCode != 200) {
        return "Error, Ponte en contacto con nuestro equipo de soporte.";
      } else {
        return "OK";
      }
    } catch (e) {
      return e.toString();
    }
  }

  sendEmailPassword(email, code) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer'
      };

      var response = await http.post(
          Uri.parse("$generalServer/api/send/email"),
          headers: headers,
          body: jsonEncode({"code": code, "email":email}));
      var decodeData = json.decode(response.body);
      print(decodeData);
      if (response.statusCode != 200) {
        return "Error, Ponte en contacto con nuestro equipo de soporte.";
      } else {
        return "OK";
      }
    } catch (e) {
      return e.toString();
    }
  }
}
