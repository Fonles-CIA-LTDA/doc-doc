import 'dart:convert';

import 'package:app/helpers/server.dart';
import 'package:app/main.dart';
import 'package:http/http.dart' as http;

class MaterialConnections {
  String pathMaterial = "/api/material-estudios";

  getMaterialEstudio(pageKey) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response =
          await http.get(Uri.parse("$generalServer$pathMaterial?pagination[page]=$pageKey&populate=Imagen"), headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }

}
