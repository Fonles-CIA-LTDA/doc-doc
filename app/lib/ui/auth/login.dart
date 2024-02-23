import 'package:app/connections/auth.dart';
import 'package:app/controllers/login.controller.dart';
import 'package:app/main.dart';
import 'package:app/ui/auth/restore_password.dart';
import 'package:app/ui/helpers/colors.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:quickalert/quickalert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text("¡Bienvenido a DOC DOC!",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: colorGeneralBlue)),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Tu puerta de acceso al éxito en el ENARM. Ingresa y prepárate para brillar en la medicina.",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                _textField(context, "Correo", false, "email", _controllerEmail),
                _textField(context, "Contraseña", obscure, "password",
                    _controllerPassword),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return RestorePasswordMenu();
                          });
                    },
                    child: Text("¿Has olvidado tu contraseña?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () async {
                    getLoadingModal(context);
                    //ACTION
                    var response = await LoginControllers()
                        .login(_controllerEmail, _controllerPassword);
                    Navigator.pop(context);

                    if (response[0]) {
                      getLoadingModal(context);

                      await AuthConnections()
                          .getMembership(localStorage!.getInt("id"));
                      Navigator.pop(context);

                      Get.offAllNamed("/home");
                    } else {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          text: response[1]);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 59,
                    decoration: ShapeDecoration(
                      color: Color(0xFF2A303C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x1E000000),
                          blurRadius: 1,
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Center(
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
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  Padding _textField(
      BuildContext context, hintText, obscureParam, type, controllerParam) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          height: 59,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xfff3f3f3),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.transparent, // Color del foco al hacer clic
            ),
            child: Center(
              child: TextField(
                controller: controllerParam,
                keyboardType: type == "email"
                    ? TextInputType.emailAddress
                    : TextInputType.text,
                obscureText: obscureParam,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    hintText: hintText,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: type != "password"
                        ? null
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                            child: Container(
                                color: Colors.transparent,
                                child: Icon(obscure
                                    ? Icons.remove_red_eye
                                    : Icons.remove_red_eye_outlined)),
                          )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
