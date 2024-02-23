import 'dart:convert';

import 'package:app/helpers/server.dart';
import 'package:app/main.dart';
import 'package:http/http.dart' as http;

class EscalasConnections {
  String pathFlashCard = "/api/escalas";
  String pathFlashCardMenu = "/api/especialidades-escalas";
  getEscalasMenu(pageKey) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.get(
          Uri.parse(
              "$generalServer$pathFlashCardMenu?pagination[page]=$pageKey"),
          headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }
  getEscalasCards(pageKey, identificator) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.get(
          Uri.parse(
              "$generalServer$pathFlashCard?pagination[page]=$pageKey&populate=especialidades_escala&populate=Imagen&filters[especialidades_escala][Titulo][\$eq]=${identificator}"),
          headers: headers);
      var decodeData = json.decode(response.body);
      // print(decodeData);
      // return [];
      return decodeData;
    } catch (e) {
      print(e);
    }
  }
    getEscalasSearch(pageKey, query) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.get(
          Uri.parse(
              "$generalServer$pathFlashCard?pagination[page]=$pageKey&populate=Imagen&filters[Titulo][\$contains]=${query}"),
          headers: headers);
      var decodeData = json.decode(response.body);
      // print(decodeData);
      // return [];
      return decodeData;
    } catch (e) {
      print(e);
    }
  }
}
