import 'dart:math';

import 'package:app/connections/exam.dart';
import 'package:app/connections/statistics.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quickalert/quickalert.dart';

class StatisticsPage extends StatefulWidget {
  final keyS;

  const StatisticsPage({super.key, required this.keyS});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String promedio = "0.0";
  static const _pageSize = 25;
  final PagingController _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    loadPromedio();
    _pagingController.addPageRequestListener((pageKey) {
      loadData(pageKey);
    });
    super.initState();
  }

  loadPromedio() async {
    var response = await StatisticsConnections().getStatisticsUser();

    setState(() {
      promedio = response['data'];
    });
  }

  loadData(pageKey) async {
    var exams = await ExamConnections().getExamsList(pageKey);
    final isLastPage = exams['data'].length < _pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(exams['data']);
    } else {
      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(exams['data'], nextPageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
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
                      Text(
                        "PROMEDIO",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                          elevation: 5,
                          color: const Color.fromARGB(255, 255, 255,
                              255), // Puedes personalizar el color aquí
                          borderRadius: BorderRadius.circular(
                              50.0), // Radio del borde para hacerlo circular
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(255, 223, 175, 1.0)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Center(
                              child: Text(
                                promedio,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          "Tu promedio se calcula sumando las puntuaciones obtenidas en todos los simuladores que has completado.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Simuladores Completados",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PagedSliverList(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) => Container(
                    margin: EdgeInsets.all(5.0), child: _modelListTile(item)),
              ),
            ),
          ],
        ));
  }

  Material _modelListTile(item) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: ListTile(
        onLongPress: () {
          QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              text: "¿Deseas eliminar el registro?",
              confirmBtnText: "Aceptar",
              showCancelBtn: true,
              onConfirmBtnTap: () async {
                var delete = await ExamConnections().deleteExam(item['id']);
               _pagingController.refresh();
                await loadPromedio();
                setState(() {});
                Get.back();
              },
              cancelBtnText: "Cancelar");
        },
        onTap: () {
          Get.toNamed("/exam/results?id=${item['id']}&return=true");
        },
        title: Text(
          item['attributes']['Titulo'].toString(),
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
              item['attributes']['Nota'].toString(),
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
}
