import 'dart:convert';

import 'package:app/helpers/server.dart';
import 'package:app/main.dart';
import 'package:http/http.dart' as http;

class ExamConnections {
  String pathExam = "/api/examenes";
  String pathExamQualify = "/api/qualify/exam";
  String pathGenerateTotalExam = "/api/generate/exam";
  String pathGenerateTotalSpecificQuestions = "/api/generate/specific/exam";
  String pathGeneralTotalSpecificExam = "/api/generate/specific/exam/final";
  generateTotalExam(title) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.post(
          Uri.parse("$generalServer$pathGenerateTotalExam"),
          headers: headers,
          body: json
              .encode({"idUser": localStorage!.getInt("id"), "title": title}));
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }

  getExamInformation(id) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.get(
          Uri.parse("$generalServer$pathExam/${id}?populate=preguntas_examen"),
          headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }

  qualifyInformation(questions) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.post(
          Uri.parse("$generalServer$pathExamQualify"),
          headers: headers,
          body: json.encode({"examInformation": questions}));
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }

  getExamsList(pageKey) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.get(
          Uri.parse(
              "$generalServer${pathExam}?pagination[page]=$pageKey&filters[users_permissions_user][id][\$eq]=${localStorage!.getInt("id")}&sort[0]=id:desc"),
          headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }

  deleteExam(idExam) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.delete(
          Uri.parse("$generalServer${pathExam}/${idExam}"),
          headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }

  generateTotalExamSpecificQuestions(
      selectEspecialidad, selectEspecialidadExtras, type) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.post(
          Uri.parse("$generalServer$pathGenerateTotalSpecificQuestions"),
          headers: headers,
          body: json.encode({
            "selectEspecialidad": selectEspecialidad,
            "selectEspecialidadExtras": selectEspecialidadExtras,
            "type": type
          }));
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }

  generateTotalExamSpecificExams(selectEspecialidad, selectEspecialidadExtras,
      type, numberQuestions) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.post(
          Uri.parse("$generalServer$pathGeneralTotalSpecificExam"),
          headers: headers,
          body: json.encode({
            "selectEspecialidad": selectEspecialidad,
            "selectEspecialidadExtras": selectEspecialidadExtras,
            "type": type,
            "numberQuestions": numberQuestions,
            "idUser": localStorage!.getInt("id"),
            "title": "Personalizado"
          }));
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }
}
