import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

import '../main.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (route == "/welcome" ||
        route == "/register" ||
        route == "/reset-password" ||
        route == "/login") {
      return localStorage!.getString("jwt") != null
          ? const RouteSettings(name: "/home")
          : null;
    } else {
      return localStorage!.getString("jwt") == null
          ? const RouteSettings(name: "/welcome")
          : null;
    }
  }
}
