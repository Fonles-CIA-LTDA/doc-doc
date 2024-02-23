import 'dart:convert';

import 'package:app/helpers/server.dart';
import 'package:app/main.dart';
import 'package:http/http.dart' as http;

class StatisticsConnections {
  String pathStatistics = "/api/qualify/user";

  getStatisticsUser() async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.post(Uri.parse("$generalServer$pathStatistics"),
          headers: headers, body: json.encode({
            "idUser":localStorage!.getInt("id")
          }));
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }
    getStatisticsTop() async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${localStorage!.getString("jwt")}'
      };

      var response = await http.get(Uri.parse("$generalServer/api/qualify/top"),
          headers: headers);
      var decodeData = json.decode(response.body);
      return decodeData;
    } catch (e) {
      print(e);
    }
  }
}
