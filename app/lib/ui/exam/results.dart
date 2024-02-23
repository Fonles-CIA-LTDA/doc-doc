import 'dart:convert';

import 'package:app/connections/exam.dart';
import 'package:app/connections/flascards.dart';
import 'package:app/helpers/server.dart';
import 'package:app/ui/helpers/colors.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ResultsPageExam extends StatefulWidget {
  const ResultsPageExam({super.key});

  @override
  State<ResultsPageExam> createState() => _ResultsPageExamState();
}

class _ResultsPageExamState extends State<ResultsPageExam> {
  List options = ["a", "b", "c", "d", "e", "f", "g", "h", "i"];

  var data = {};
  String idExam = "";
  bool loading = true;
  String title = "";
  String returnParam = "";

  @override
  void initState() {
    setState(() {
      idExam = Get.parameters['id']!;
      returnParam = Get.parameters['return']!;
    });
    loadExam();
    super.initState();
  }

  loadExam() async {
    var response = await ExamConnections().getExamInformation(idExam);
    setState(() {
      data = response['data'];
      title = data['attributes']['Titulo'];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: loading == true
              ? Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Resultado",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: colorGeneralBlue),
                        ),
                        Text(
                          "DOC DOC",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Calificación",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: colorGeneralBlue),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                                child: Text(
                                    "${data['attributes']['Nota'].toString()}/100")),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Fecha",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: colorGeneralBlue),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                                child: Text(
                                    data['attributes']['Fecha'].toString())),
                          ],
                        ),
                        Divider(),
                        ...List.generate(
                            data['attributes']['preguntas_examen']['data']
                                .length,
                            (index) => generateResultCard(data['attributes']
                                ['preguntas_examen']['data'][index])),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: colorGeneralBlue,
                                  minimumSize: Size(double.infinity, 55)),
                              onPressed: () async {
                               if (returnParam=="false") {
                                  Get.offNamedUntil("/home", (route) => false);
                               } else {
                                 Get.back();
                               }
                              },
                              child: Text(
                                "Finalizar",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }

  generateResultCard(item) {
    var decodeDataQuestion = json.decode(item['attributes']['pregunta']);
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              decodeDataQuestion['elemento']['Contenido'].toString(),
              style: TextStyle(fontSize: 16),
            ),
            decodeDataQuestion['elemento']['Imagen'] != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                        "${generalServer}${decodeDataQuestion['elemento']['Imagen']['url']}"))
                : Container(),
            SizedBox(
              height: 5,
            ),
            ...List.generate(
                decodeDataQuestion['elemento']['Respuestas']
                    .toString()
                    .split("\n")
                    .length,
                (index) => Container(
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(width: 0.5, color: Colors.grey)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: decodeDataQuestion['elemento']
                                        ['Respuesta_Correcta'] ==
                                    (index + 1)
                                ? Colors.green
                                : item['attributes']['Respuesta'] ==
                                        (index + 1).toString()
                                    ? item['attributes']['correcto'] == false
                                        ? Colors.redAccent
                                        : Color.fromARGB(255, 104, 184, 106)
                                    : Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: ListTile(
                          onTap: () {},
                          title: Text(
                            "${options[index]}.- ${decodeDataQuestion['elemento']['Respuestas'].toString().split("\n")[index].toString()}",
                            style: TextStyle(
                                color: decodeDataQuestion['elemento']
                                            ['Respuesta_Correcta'] ==
                                        (index + 1)
                                    ? Colors.white
                                    : item['attributes']['Respuesta'] ==
                                            (index + 1).toString()
                                        ? Colors.white
                                        : Colors.black),
                          ),
                        ),
                      ),
                    )),
            SizedBox(
              height: 5,
            ),
            Divider(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Feedback:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorGeneralBlue),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(decodeDataQuestion['elemento']['Feedback'].toString()),
              ],
            ),
            decodeDataQuestion['elemento']['flash_card'] == null
                ? Container()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Contenido Relacionado:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorGeneralBlue),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      OutlinedButton(
                          onPressed: () async {
                            getLoadingModal(context);
                            var flashCardInformation =
                                await FlashCardConnections().getFlashCardsById(
                                    decodeDataQuestion['elemento']['flash_card']
                                        ['id']);
                            var flashUrl = flashCardInformation['data']
                                        ['attributes']['Imagen']['data']
                                    ['attributes']['url']
                                .toString();
                            Get.back();
                            final imageProvider =
                                Image.network("${generalServer}$flashUrl")
                                    .image;
                            showImageViewer(context, imageProvider,
                                onViewerDismissed: () {},
                                doubleTapZoomable: true);
                          },
                          child: Text("Flash Card")),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
