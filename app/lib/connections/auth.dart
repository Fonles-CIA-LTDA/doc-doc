import 'dart:convert';

import 'package:app/main.dart';
import 'package:http/http.dart' as http;

class AuthConnections {
  String pathLogin = "/api/auth/local";
  String pathMembership = "/api/membresias";
  String pathRegister = "/api/auth/local/register";
  String generalServer = "https://admin.docdocenarm.com";
  String pathDeleteMembership = "/api/membresias/stripe/delete-subscription";
 String pathUpdateSubscriptionMail =
      "/api/membresias/stripe/update-mail-subscription";
  getUserByEmail(email) async {
    try {
      final Map<String, String> headers = {'Content-Type': 'application/json'};

      var response = await http.get(
          Uri.parse("$generalServer/api/users?filters[email][\$eq]=${email}"),
          headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }

  login({email, password}) async {
    final String url = '$generalServer$pathLogin';
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> data = {
      'identifier': email,
      'password': password,
    };
    try {
      var response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(data));
      var decodeData = json.decode(response.body);
      if (response.statusCode != 200) {
        return [false, decodeData['error']['message']];
      } else {
        localStorage!.setString("jwt", decodeData['jwt']);
        localStorage!.setInt("id", decodeData['user']['id']);
        localStorage!.setString("email", decodeData['user']['email']);
        localStorage!.setString("name", decodeData['user']['name']);
        localStorage!.setString("state", decodeData['user']['state']);
        localStorage!.setString("university", decodeData['user']['university']);
        return [true, ""];
      }
    } catch (e) {
      return [false, e.toString()];
    }
  }

  Future registerUser({name, mail, password, state, university}) async {
    final String url = '$generalServer$pathRegister';
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> data = {
      'username': mail,
      'email': mail,
      'password': password,
      'name': name,
      'state': state,
      'university': university
    };
    try {
      var response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(data));
      var decodeData = json.decode(response.body);
      if (response.statusCode != 200) {
        return [false, decodeData['error']['message']];
      } else {
        localStorage!.setString("jwt", decodeData['jwt']);
        localStorage!.setInt("id", decodeData['user']['id']);
        localStorage!.setString("email", decodeData['user']['email']);
        localStorage!.setString("name", decodeData['user']['name']);
        localStorage!.setString("state", decodeData['user']['state']);
        localStorage!.setString("university", decodeData['user']['university']);

        return [true, ""];
      }
    } catch (e) {
      return [false, e.toString()];
    }
  }

  Future getMembership(id) async {
    try {
      var request = await http.get(
        Uri.parse(
            "$generalServer$pathMembership?filters[users_permissions_user][id][\$eq]=$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${localStorage!.getString("jwt")}"
        },
      );
      var response = request.body;
      var decodeData = json.decode(response);
      if (decodeData['data'].length == 0) {
        localStorage!.setString("membresia", "close");
        localStorage!.setString("type", "-1");
      } else {
        final fechaActual = DateTime.now().millisecondsSinceEpoch ~/ 1000;

        // Fecha proporcionada en formato Unix Timestamp (1694201598)
        final fechaProporcionada = int.parse(
            decodeData['data'][0]['attributes']['End_Date'].toString());

        if (fechaActual <= fechaProporcionada) {
          localStorage!.setString("membresia", "activa");
          localStorage!.setString("endDate", fechaProporcionada.toString());
        } else {
          localStorage!.setString("membresia", "close");
        }
        localStorage!.setString(
            "type", decodeData['data'][0]['attributes']['type'].toString());
      }
      return decodeData;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future deleteMembership(id) async {
    try {
      var delete =
          await http.post(Uri.parse("$generalServer$pathDeleteMembership"),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': "Bearer ${localStorage!.getString("jwt")}"
              },
              body: jsonEncode({
                'idSubs': id,
              }));
      var decodeData = await json.decode(delete.body);
      print(decodeData);

      return [true, "Completado"];
    } catch (e) {
      return [false, e.toString()];
    }
  }
  Future updateMailMembershipCustomer(id, mail) async {
    try {
      var delete =
          await http.post(Uri.parse("$generalServer$pathUpdateSubscriptionMail"),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': "Bearer ${localStorage!.getString("jwt")}"
              },
              body: jsonEncode({'idCustomer': id, 'mail': mail}));

      return [true, "Completado"];
    } catch (e) {
      return [false, e.toString()];
    }
  }
}
