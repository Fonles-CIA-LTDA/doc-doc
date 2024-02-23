import 'dart:math';

import 'package:app/connections/auth.dart';
import 'package:app/connections/config.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/route_manager.dart';
import 'package:quickalert/quickalert.dart';

class RestorePasswordMenu extends StatefulWidget {
  const RestorePasswordMenu({super.key});

  @override
  State<RestorePasswordMenu> createState() => _RestorePasswordMenuState();
}

class _RestorePasswordMenuState extends State<RestorePasswordMenu> {
  int indexPage = 0;
  int code = 0;
  TextEditingController _email = TextEditingController();
  TextEditingController _code = TextEditingController();
  int idUser = -1;
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List pages = [_page1(), _page2(), _page3()];

    return AlertDialog(
      contentPadding: EdgeInsets.all(10.0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: pages[indexPage],
            ),
          ),
        ),
      ),
    );
  }

  Column _page3() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Ingresar tu nueva contraseña",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          keyboardType: TextInputType.text,
          controller: _password,
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () async {
              var update = await ConfigConnections()
                  .updatePassword(_password.text, idUser);
              if (update != "OK") {
                await QuickAlert.show(
                    title: "Alerta",
                    context: context,
                    type: QuickAlertType.error,
                    text: update.toString(),
                    confirmBtnText: 'Aceptar');
              } else {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    confirmBtnText: "Aceptar",
                    barrierDismissible: false,
                    onConfirmBtnTap: () {
                      Get.back();
                      Get.back();
                    });
              }
            },
            child: Text("Guardar"))
      ],
    );
  }

  Column _page2() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Ingresar código",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          keyboardType: TextInputType.number,
          controller: _code,
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () async {
              if (code.toString() == _code.text.toString()) {
                getLoadingModal(context);
                var response =
                    await AuthConnections().getUserByEmail(_email.text);
                Get.back();
                setState(() {
                  idUser = response[0]['id'];
                });
                setState(() {
                  indexPage++;
                });
              } else {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: "Código Incorrecto",
                    confirmBtnText: "Aceptar");
              }
            },
            child: Text("Validar código"))
      ],
    );
  }

  Column _page1() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Restablecer contraseña",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "Ingresa tu correo electrónico. Se te enviará un código único que deberás introducir a continuación",
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          keyboardType: TextInputType.emailAddress,
          controller: _email,
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () async {
              if (_email.text.isEmpty) {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: "No existe usuario",
                    confirmBtnText: "Aceptar");
                return;
              }
              var response =
                  await AuthConnections().getUserByEmail(_email.text);
              if (response.length == 0) {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: "No existe usuario",
                    confirmBtnText: "Aceptar");
                return;
              }
              code = Random().nextInt(900000) + 100000;
              getLoadingModal(context);
              var sendCode = await ConfigConnections()
                  .sendEmailPassword(_email.text, code);
              Get.back();

              print(code);
              //SEND TO API AND SEND EMAIL
              setState(() {
                indexPage++;
              });
            },
            child: Text("Enviar código"))
      ],
    );
  }
}
