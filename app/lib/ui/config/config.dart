import 'dart:math';

import 'package:app/connections/auth.dart';
import 'package:app/connections/config.dart';
import 'package:app/main.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:app/ui/widgets/pay_information.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:quickalert/quickalert.dart';

class ConfigPage extends StatefulWidget {
  final keyS;

  const ConfigPage({super.key, required this.keyS});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool enable = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _university = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  String idMem = "";
  String status = "";
  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    var response = await ConfigConnections().getProfileInfo();
    var membership = await AuthConnections().getMembership(response['id']);
    setState(() {
      idMem = membership['data'][0]['attributes']['Id_Membresia'].toString();
      status = membership['data'][0]['attributes']['Status'].toString();

      _name.text = response['name'];
      _state.text = response['state'];
      _university.text = response['university'];
      _email.text = response['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      widget.keyS.currentState!.openDrawer();
                    },
                    icon: Icon(Icons.menu)),
                IconButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      Get.toNamed("/notifications");
                    },
                    icon: Icon(Icons.notifications))
              ],
            ),
            Center(
              child: Text(
                "Mi Cuenta",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            localStorage!.getString("membresia") == "activa"
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ">Tu membresía está actualmente activa.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 11, 128, 89)),
                      ),
                      Text(
                        "Fin: ${convertDate(localStorage!.getString("endDate"))} ",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        "Estado: ${status} ",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  )
                : Column(
                    children: [
                      Text(
                          "En este momento, no dispones de una membresía activa. ¡Actualiza a la membresía premium para aprovechar al máximo todas las funciones de Doc Doc!"),
                      SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return PayInformation();
                                });
                          },
                          child: Text("Suscribirse en Doc Doc")),
                      SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent),
                          onPressed: () async {
                            getLoadingModal(context);
                            await AuthConnections()
                                .getMembership(localStorage!.getInt("id"));
                            setState(() {});
                            Get.back();
                          },
                          child: Text(
                            "Recargar el estado de membresía.",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
            SizedBox(
              height: 10,
            ),
            enable
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _password.clear();
                            enable = false;
                          });
                        },
                        child: Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            var update = await ConfigConnections()
                                .updateProfileInfo(
                                    _name.text,
                                    _state.text,
                                    _university.text,
                                    _email.text,
                                    _password.text);
                            if (update != "OK") {
                              await QuickAlert.show(
                                  title: "Alerta",
                                  context: context,
                                  type: QuickAlertType.error,
                                  text: update.toString(),
                                  confirmBtnText: 'Aceptar');
                            } else {
                              await QuickAlert.show(
                                  title: "Alerta",
                                  context: context,
                                  type: QuickAlertType.success,
                                  text: "Completado.",
                                  confirmBtnText: 'Aceptar');
                              setState(() {
                                enable = false;
                              });
                            }
                            _password.clear();
                          },
                          child: Text("Guardar"))
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        localStorage!.getString("membresia") != "activa" ||
                                localStorage!.getString("type") != "0" ||
                                status == "canceled" ||
                                status == ""
                            ? Container()
                            : Wrap(
                                children: [
                                 status == "canceled" ?    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return PayInformation();
                                            });
                                      },
                                      child: Text("Suscribirse en Doc Doc")):Container(),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent),
                                      onPressed: () async {
                                        await QuickAlert.show(
                                            title: "Cancelar Membresía",
                                            context: context,
                                            type: QuickAlertType.warning,
                                            showCancelBtn: true,
                                            cancelBtnText: 'Cancelar',
                                            text: "",
                                            onConfirmBtnTap: () async {
                                              getLoadingModal(context);
                                              var update =
                                                  await AuthConnections()
                                                      .deleteMembership(idMem);
                                              await loadData();
                                              Get.back();
                                              Get.back();
                                            },
                                            confirmBtnText: 'Aceptar');
                                      },
                                      child: Text(
                                        "Cancelar Membresía",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ],
                              ),
                        ElevatedButton(
                            onPressed: () async {
                              await QuickAlert.show(
                                  title: "Alerta",
                                  context: context,
                                  type: QuickAlertType.warning,
                                  text:
                                      "Si prefieres no modificar la contraseña, simplemente deja el campo correspondiente en blanco.",
                                  confirmBtnText: 'Aceptar');
                              setState(() {
                                enable = true;
                              });
                            },
                            child: Text("Editar")),
                      ],
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            _model("Nombre", _name),
            _model("Estado", _state),
            _model("Universidad", _university),
            _model("Correo", _email),
            _model("Contraseña", _password),
          ],
        ),
      ),
    );
  }

  Material _model(label, controllerParam) {
    return Material(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          enabled: enable,
          controller: controllerParam,
          decoration: InputDecoration(
              label: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Material _modelListTile(prefix, name, puntuation) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(
          child: Center(
            child: Text(prefix),
          ),
          backgroundColor: generarColorPastel(),
        ),
        onTap: () {},
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Fecha: 28-12-2023",
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Puntuación",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              puntuation,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Color generarColorPastel() {
    Random random = Random();

    // Generar componentes de color
    int red = 200 + random.nextInt(56); // Rango: 200-255
    int green = 200 + random.nextInt(50); // Rango: 200-255
    int blue = 200 + random.nextInt(50); // Rango: 200-255

    // Crear y devolver el color pastel
    return Color.fromARGB(255, red, green, blue);
  }

  convertDate(date) {
    if (date.toString().isNotEmpty) {
      DateTime fecha =
          DateTime.fromMillisecondsSinceEpoch(int.parse(date) * 1000);

      // Formatea la fecha en el formato que deseas
      String fechaFormateada =
          "${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute}";
      return fechaFormateada;
    } else {
      return "";
    }
  }
}
