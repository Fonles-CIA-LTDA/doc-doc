import 'package:app/ui/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:quickalert/quickalert.dart';

class SimulatorsPage extends StatefulWidget {
  final keyS;
  const SimulatorsPage({super.key, required this.keyS});

  @override
  State<SimulatorsPage> createState() => _SimulatorsPageState();
}

class _SimulatorsPageState extends State<SimulatorsPage> {
  int area = 0;
  List optionsSpecialized = [
    {"name": "Examen de Cirugía", "prefix": "C", "id": 0},
    {"name": "Examen de Urgencias", "prefix": "U", "id": 0},
    {"name": "Examen de Medicina Interna", "prefix": "I", "id": 0},
    {"name": "Examen de Ginecología y Obstetricia", "prefix": "G", "id": 0},
    {"name": "Examen de Medicina Familiar", "prefix": "F", "id": 0}
  ];
  List optionsVisual = [
    {"name": "Examen de Radiografías", "prefix": "R", "id": 0},
    {"name": "Examen de USG", "prefix": "U", "id": 0},
    {"name": "Examen de TAC", "prefix": "T", "id": 0},
    {"name": "Examen de RM", "prefix": "T", "id": 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
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
                    onPressed: () {},
                    icon: Icon(Icons.notifications))
              ],
            ),
            _header(),
            SizedBox(
              height: 20,
            ),
            _completeExamen(),
            SizedBox(
              height: 20,
            ),
            _area(),
            SizedBox(
              height: 10,
            ),
            _generateList()
          ],
        ),
      ),
    );
  }

  _generateList() {
    if (area == 0) {
      return Column(
        children: List.generate(
            optionsSpecialized.length,
            (index) => Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Center(
                          child: Text(optionsSpecialized[index]['prefix']),
                        ),
                      ),
                      onTap: () {
                        navigate();
                      },
                      title: Text(
                        optionsSpecialized[index]['name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider()
                  ],
                )),
      );
    } else {
      return Column(
        children: List.generate(
            optionsVisual.length,
            (index) => Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Center(
                          child: Text(optionsVisual[index]['prefix']),
                        ),
                      ),
                      onTap: () {
                        navigate();
                      },
                      title: Text(
                        optionsVisual[index]['name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider()
                  ],
                )),
      );
    }
  }

  navigate() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                  SizedBox(
                  height: 10,
                ),
                Center(child: Icon(Icons.info, color: Colors.blue,size: 30,)),
                  SizedBox(
                  height: 10,
                ),
                Text(
                  "Disponible sólo para suscriptores",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                
                Text(
                  "¿Deseas suscribirte ahora?",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedButton(onPressed: () {
                      Get.back();
                    }, child: Text("No")),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(onPressed: () {}, child: Text("Si")),
                  ],
                )
              ],
            ),
          );
        });
  }

  Row _area() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              area = 0;
            });
          },
          child: Container(
            color: Colors.transparent,
            width: 130,
            child: Column(
              children: [
                Text(
                  "Especializado",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                area != 0
                    ? SizedBox()
                    : Container(
                        width: double.infinity,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(244, 207, 127, 1.0),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                topLeft: Radius.circular(20.0))),
                      )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              area = 1;
            });
          },
          child: Container(
            width: 60,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Visual",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                area != 1
                    ? SizedBox()
                    : Container(
                        width: double.infinity,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(244, 207, 127, 1.0),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                topLeft: Radius.circular(20.0))),
                      )
              ],
            ),
          ),
        )
      ],
    );
  }

  Container _completeExamen() {
    return Container(
        width: double.infinity,
        height: 106,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: colorGeneralBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.49),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "280",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.70,
                        ),
                      ),
                      TextSpan(text: "Preguntas")
                    ])),
                    SizedBox(
                      height: 5,
                    ),
                    Flexible(
                      child: Text(
                        'Examen completo de 280 preguntas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {},
                    child: Text(
                      "Haz el examen",
                      style: TextStyle(fontSize: 13),
                    )),
              )
            ],
          ),
        ));
  }

  Container _header() {
    return Container(
      width: double.infinity,
      child: Text(
        "Hola, Barzilai",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
