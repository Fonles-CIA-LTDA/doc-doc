import 'package:app/ui/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 4,
                  child: SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image(
                          image: AssetImage("./assets/logos/DOCD.jpg"),
                          fit: BoxFit.fill,
                        )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'Descubre DOC DOC \ntu aliado para el ENARM',
                        style: TextStyle(
                          color: Color(0xFF464444),
                          fontSize: 25,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Domina cada especialidad médica con nuestro simulador de exámenes: 280 preguntas, secciones visuales con radiografías y más. ¡Tu éxito comienza aquí!\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w300,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed("/login");
                          },
                          child: Container(
                            width: double.infinity,
                            height: 65,
                            decoration: ShapeDecoration(
                              color: colorGeneralBlue,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Ingresar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed("/register");
                          },
                          child: Container(
                            width: double.infinity,
                            height: 65,
                            decoration: const ShapeDecoration(
                              color: Color(0xFFF3F3F3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      topLeft: Radius.circular(15))),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x1E000000),
                                  blurRadius: 1,
                                  offset: Offset(0, 2),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Registrarse',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF535050),
                                  fontSize: 22,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
