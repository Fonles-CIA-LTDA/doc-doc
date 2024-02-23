import 'dart:math';

import 'package:app/connections/areas.dart';
import 'package:app/connections/exam.dart';
import 'package:app/main.dart';
import 'package:app/ui/helpers/colors.dart';
import 'package:app/ui/helpers/navigate.dart';
import 'package:app/ui/simulators/select_areas_modal.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quickalert/quickalert.dart';

class SimulatorsPage extends StatefulWidget {
  final keyS;
  const SimulatorsPage({super.key, required this.keyS});

  @override
  State<SimulatorsPage> createState() => _SimulatorsPageState();
}

class _SimulatorsPageState extends State<SimulatorsPage> {
  static const _pageSize = 25;

  final PagingController _pagingController = PagingController(firstPageKey: 1);
  int area = 0;
  bool loading = true;

  loadData(pageKey) async {
    if (area == 0) {
      var response = await AreasConnections().getAreaEspecialidad(pageKey);
      final isLastPage = response['data'].length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(response['data']);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(response['data'], nextPageKey);
      }
    } else {
      var response =
          await AreasConnections().getAreaEspecialidadVisual(pageKey);
      final isLastPage = response['data'].length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(response['data']);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(response['data'], nextPageKey);
      }
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      loadData(pageKey);
    });
    super.initState();
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
                    ],
                  ),
                ],
              ),
            ),
            PagedSliverList(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) => _modelCard(item)),
            ),
          ],
        ));
  }

  Column _modelCard(item) {
    return Column(
      children: [
        Material(
          elevation: 2,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: ListTile(
            leading: CircleAvatar(
              child: Center(
                child: Text(
                    "${item['attributes']['Titulo'].toString().split(" ")[2][0]}"),
              ),
              backgroundColor: generarColorPastel(),
            ),
            onTap: () {
              navigateMembership(context, () {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return SelectAreasModal(
                          idSelect: item['id'].toString(),
                          titleSelect: item['attributes']['Titulo'].toString(),
                          area: area);
                    });
              });
            },
            title: Text(
              "${item['attributes']['Titulo']}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Divider()
      ],
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

  Row _area() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            setState(() {
              area = 0;

              _pagingController.refresh();
            });

            // loadData(0);
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
                    : Material(
                        elevation: 2,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0)),
                        child: Container(
                          width: double.infinity,
                          height: 5,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(89, 237, 178, 1),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0))),
                        ),
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
              _pagingController.refresh();
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
                    : Material(
                        elevation: 2,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0)),
                        child: Container(
                          width: double.infinity,
                          height: 5,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(89, 237, 178, 1),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0))),
                        ),
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
                    onPressed: () async {
                      navigateMembership(context, () async {
                        getLoadingModal(context);
                        var idExam = await ExamConnections()
                            .generateTotalExam("Completo");
                        Get.back();
                        Get.toNamed("/exam?id=${idExam['data']}");
                      });
                    },
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
        "Hola, ${localStorage!.getString("name").toString().split(" ")[0]}",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
