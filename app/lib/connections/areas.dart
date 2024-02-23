import 'dart:convert';

import 'package:app/helpers/server.dart';
import 'package:app/main.dart';
import 'package:http/http.dart' as http;

class AreasConnections {
  String pathAreas = "/api/especialidades";
  String pathAreasVisual = "/api/especialidades-visuales";

  getAreaEspecialidad(pageKey) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response =
          await http.get(Uri.parse("$generalServer$pathAreas?pagination[page]=$pageKey"), headers: headers);
      var decodeData = json.decode(response.body);
      print(localStorage!.getString("jwt"));
      return decodeData;
    } catch (e) {
      print(e);
    }
  }
    getAreaEspecialidadVisual(pageKey) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response =
          await http.get(Uri.parse("$generalServer$pathAreasVisual?pagination[page]=$pageKey"), headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }

    getAreaEspecialidadSubCategoriasID(id) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response =
          await http.get(Uri.parse("$generalServer$pathAreas/${id}?populate=sub_especialidades"), headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }
    getAreaEspecialidadSubCategoriasNotEqualID(id) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response =
          await http.get(Uri.parse("$generalServer$pathAreas?populate=sub_especialidades&filters[id][\$ne]=${id}"), headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }
     getAreaVisualSubCategoriasNotEqualID(id) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response =
          await http.get(Uri.parse("$generalServer$pathAreasVisual?populate=sub_espe_visuals&filters[id][\$ne]=${id}"), headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }

    getAreaVisualSubCategoriasID(id) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response =
          await http.get(Uri.parse("$generalServer$pathAreasVisual/${id}?populate=sub_espe_visuals"), headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }
}
