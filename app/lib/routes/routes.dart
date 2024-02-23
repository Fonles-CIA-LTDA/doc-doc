import 'package:app/middleware/auth.middleware.dart';
import 'package:app/ui/auth/login.dart';
import 'package:app/ui/auth/register.dart';
import 'package:app/ui/escalas/escalas.dart';
import 'package:app/ui/escalas/escalas_menu.dart';
import 'package:app/ui/exam/exam.dart';
import 'package:app/ui/exam/results.dart';
import 'package:app/ui/flash_cards/flash_cards.dart';
import 'package:app/ui/flash_cards/flash_cards_menu.dart';
import 'package:app/ui/home/home.dart';
import 'package:app/ui/notifications/notifications.dart';
import 'package:app/ui/study_material/study_material.dart';
import 'package:app/ui/top_users/top_users.dart';
import 'package:app/ui/welcome/welcome.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

getRoutes() {
  return [
    GetPage(
        name: '/welcome',
        page: () => const WelcomePage(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/login',
        page: () => const LoginPage(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/register',
        page: () => const RegisterPage(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/home',
        page: () => const HomePage(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/study-material',
        page: () => const StudyMaterial(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/flash-cards',
        page: () => const FlashCards(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/flash-cards/menu',
        page: () => const FlashCardMenu(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/escalas',
        page: () => const Escalas(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/escalas/menu',
        page: () => const EscalasMenu(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/top-users',
        page: () => const TopUsers(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/notifications',
        page: () => const NotificationsPage(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/exam',
        page: () => const ExamPage(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/exam/results',
        page: () => const ResultsPageExam(),
        middlewares: [AuthMiddleware()]),
  ];
}
