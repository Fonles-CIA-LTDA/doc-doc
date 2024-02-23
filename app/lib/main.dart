import 'package:app/connections/auth.dart';
import 'package:app/controllers/home.controller.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? localStorage;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  localStorage = await SharedPreferences.getInstance();
    if (localStorage!.getString("name") != null) {
    await AuthConnections().getMembership(localStorage!.getInt("id"));
  }


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<HomeControllers>(create: (_) => HomeControllers())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doc Doc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: getRoutes(),
      initialRoute: "/welcome",
      unknownRoute: GetPage(
          name: '/notfound',
          page: () => Scaffold(
                body: Center(
                  child: Text('Ruta no encontrada: ${Get.currentRoute}'),
                ),
              )),
    );
  }
}
