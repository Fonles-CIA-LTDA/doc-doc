import 'dart:convert';

import 'package:app/connections/exam.dart';
import 'package:app/helpers/server.dart';
import 'package:app/ui/helpers/colors.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  List options = ["a", "b", "c", "d", "e", "f", "g", "h", "i"];
  bool loading = true;
  String idExam = "";
  int indexQuestion = 1;
  int indexQuestionSelect = -1;
  String question = "";
  String pathImage = "";
  List respuestas = [];
  String title = "";
  var data = {};
  @override
  void initState() {
    setState(() {
      idExam = Get.parameters['id']!;
    });
    loadExam();

    super.initState();
  }

  loadExam() async {
    var response = await ExamConnections().getExamInformation(idExam);
    setState(() {
      data = response['data'];
      title = data['attributes']['Titulo'];

      generateVisualData();
      loading = false;
    });
    // print(response);
  }

  generateVisualData() {
    var currentQuestion = data['attributes']['preguntas_examen']['data']
        [(indexQuestion - 1)]['attributes'];

    if (currentQuestion['Respuesta'] != null &&
        currentQuestion['Respuesta'].toString().isNotEmpty) {
      setState(() {
        indexQuestionSelect =
            int.parse(currentQuestion['Respuesta'].toString());
      });
    }
    var currentQuestionDataDecode = json.decode(currentQuestion['pregunta']);
    setState(() {
      question = currentQuestionDataDecode['elemento']['Contenido'];

      if (currentQuestionDataDecode['elemento']['Imagen'] != null) {
        pathImage = currentQuestionDataDecode['elemento']['Imagen']['url'];
      }
      var temporalList = currentQuestionDataDecode['elemento']['Respuestas']
          .toString()
          .split("\n");
      respuestas = temporalList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: loading
              ? Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _headerNavigator(),
                      _generateNumberQuestions(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          question,
                          style:
                              TextStyle(color: colorGeneralBlue, fontSize: 16),
                        ),
                      ),
                      pathImage.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Image.network("${generalServer}${pathImage}"))
                          : Container(),
                      Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: List.generate(
                                respuestas.length,
                                (index) => Container(
                                      margin: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          border: Border.all(
                                              width: 0.5, color: Colors.grey)),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: indexQuestionSelect == index
                                                ? Color.fromARGB(
                                                    255, 75, 93, 246)
                                                : Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        child: ListTile(
                                          onTap: () {
                                            data['attributes']
                                                            ['preguntas_examen']
                                                        ['data']
                                                    [
                                                    (indexQuestion -
                                                        1)]['attributes']
                                                ['Respuesta'] = index;
                                            setState(() {
                                              indexQuestionSelect = index;
                                            });
                                          },
                                          title: Text(
                                            "${options[index]}.- ${respuestas[index].toString()}",
                                            style: TextStyle(
                                                color:
                                                    indexQuestionSelect == index
                                                        ? Colors.white
                                                        : Colors.black),
                                          ),
                                        ),
                                      ),
                                    )),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: colorGeneralBlue,
                                minimumSize: Size(double.infinity, 55)),
                            onPressed: () async {
                              if (indexQuestion ==
                                  data['attributes']['preguntas_examen']['data']
                                      .length) {
                                getLoadingModal(context);
                                var postexam = await ExamConnections()
                                    .qualifyInformation(data);
                                Get.back();
                                Get.offNamedUntil("/exam/results?id=${idExam}&return=false", (route) => false);
                              } else {
                                setState(() {
                                  indexQuestionSelect = -1;
                                  pathImage = "";
                                  respuestas = [];
                                  question = "";
                                  indexQuestion++;
                                  generateVisualData();
                                });
                              }
                            },
                            child: Text(
                              indexQuestion ==
                                      data['attributes']['preguntas_examen']
                                              ['data']
                                          .length
                                  ? "Finalizar"
                                  : "Siguiente",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18),
                            )),
                      )
                    ],
                  ),
                )),
    );
  }

  Padding _headerNavigator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: colorGeneralBlue,
              )),
          Flexible(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorGeneralBlue),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                "Doc Doc",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ))
        ],
      ),
    );
  }

  SizedBox _generateNumberQuestions() {
    return SizedBox(
      width: double.infinity,
      height: 88,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              "Preguntas",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: const Color.fromARGB(255, 187, 187, 187)),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...List.generate(
                      data['attributes']['preguntas_examen']['data'].length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              indexQuestionSelect = -1;
                              pathImage = "";
                              respuestas = [];
                              question = "";
                              indexQuestion = (index + 1);
                              generateVisualData();
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: (index + 1) == indexQuestion
                                ? colorGeneralBlue
                                : Colors.white,
                            radius: 25,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0,
                                      color:
                                          Color.fromARGB(255, 212, 212, 212)),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                      color: (index + 1) == indexQuestion
                                          ? Colors.white
                                          : Color.fromARGB(255, 109, 109, 109),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
