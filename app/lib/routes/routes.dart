import 'package:app/ui/auth/login.dart';
import 'package:app/ui/auth/register.dart';
import 'package:app/ui/home/home.dart';
import 'package:app/ui/welcome/welcome.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

getRoutes() {
  return [
    GetPage(name: '/welcome', page: () => const WelcomePage()),
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/register', page: () => const RegisterPage()),
    GetPage(name: '/home', page: () => const HomePage()),
  ];
}
