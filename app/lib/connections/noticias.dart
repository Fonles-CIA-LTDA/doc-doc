import 'dart:convert';

import 'package:app/helpers/server.dart';
import 'package:app/main.dart';
import 'package:http/http.dart' as http;

class NoticiasConnections {
  String pathNoticias = "/api/noticias";

  getNoticias(pageKey) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response =
          await http.get(Uri.parse("$generalServer$pathNoticias?pagination[page]=$pageKey&sort[0]=id:desc&populate=Imagen"), headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }

}
