import 'package:app/connections/exam.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:quickalert/quickalert.dart';

class NumberQuestions extends StatefulWidget {
  final int questionsMax;
  final int area;
  final selectEspecialidad;
  final selectEspecialidadExtras;
  const NumberQuestions(
      {super.key,
      required this.questionsMax,
      required this.selectEspecialidad,
      required this.selectEspecialidadExtras,
      required this.area});

  @override
  State<NumberQuestions> createState() => _NumberQuestionsState();
}

class _NumberQuestionsState extends State<NumberQuestions> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close)),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Ingrese el número de preguntas que desees para tu examen, máximo ${widget.questionsMax}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_controller.text.isEmpty ||
                          int.parse(_controller.text) > widget.questionsMax ||
                          int.parse(_controller.text) == 0) {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text:
                                "Por favor, selecciona un número válido. El máximo permitido es ${widget.questionsMax}",
                            confirmBtnText: "Aceptar");
                      } else {
                        var response = await ExamConnections()
                            .generateTotalExamSpecificExams(
                                widget.selectEspecialidad,
                                widget.selectEspecialidadExtras,
                                widget.area,
                                int.parse(_controller.text));
                        Get.back();
                        Get.back();

                        Get.toNamed("/exam?id=${response['data']}");
                      }
                    },
                    child: Text("Comenzar examen"))
              ],
            ),
          )),
    );
  }
}
