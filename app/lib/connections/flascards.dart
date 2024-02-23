import 'dart:convert';

import 'package:app/helpers/server.dart';
import 'package:app/main.dart';
import 'package:http/http.dart' as http;

class FlashCardConnections {
  String pathFlashCard = "/api/flash-cards";
  String pathFlashCardMenu = "/api/especialidades-flash-cards";
  getFlashCardsMenu(pageKey) async {
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
  getFlashCards(pageKey, identificator) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.get(
          Uri.parse(
              "$generalServer$pathFlashCard?pagination[page]=$pageKey&populate=especialidades_flash_card&populate=Imagen&filters[especialidades_flash_card][Titulo][\$eq]=${identificator}"),
          headers: headers);
      var decodeData = json.decode(response.body);
      // print(decodeData);
      // return [];
      return decodeData;
    } catch (e) {
      print(e);
    }
  }
    getFlashCardsById(id) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.get(
          Uri.parse(
              "$generalServer$pathFlashCard/${id}?populate=Imagen"),
          headers: headers);
      var decodeData = json.decode(response.body);
      // print(decodeData);
      // return [];
      return decodeData;
    } catch (e) {
      print(e);
    }
  }
    getFlashCardsSearch(pageKey, query) async {
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
