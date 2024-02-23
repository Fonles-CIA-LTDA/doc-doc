import 'package:app/connections/areas.dart';
import 'package:app/connections/exam.dart';
import 'package:app/ui/helpers/colors.dart';
import 'package:app/ui/simulators/select_numbers_questions.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class SelectAreasModal extends StatefulWidget {
  final String idSelect;
  final String titleSelect;
  final int area;
  const SelectAreasModal(
      {super.key,
      required this.idSelect,
      required this.titleSelect,
      required this.area});

  @override
  State<SelectAreasModal> createState() => _SelectAreasModalState();
}

class _SelectAreasModalState extends State<SelectAreasModal> {
  var selectEspecialidad = null;
  var selectEspecialidadExtras = null;

  String claveGeneral = "";
  @override
  void initState() {
    loadData();
    loadDataExtras();
    super.initState();
  }

  loadDataExtras() async {
    if (widget.area == 0) {
      var response = await AreasConnections()
          .getAreaEspecialidadSubCategoriasNotEqualID(widget.idSelect);
      for (var i = 0; i < response['data'].length; i++) {
        var newMap = response['data'][i]['attributes']['sub_especialidades']
                ['data']
            .map((e) {
          return {'seleccionado': false, ...e};
        }).toList();
        response['data'][i]['attributes']['sub_especialidades']['data'] =
            newMap;
      }

      selectEspecialidadExtras = response['data'];
      setState(() {});
    } else {
      var response = await AreasConnections()
          .getAreaVisualSubCategoriasNotEqualID(widget.idSelect);
      for (var i = 0; i < response['data'].length; i++) {
        var newMap = response['data'][i]['attributes']['sub_espe_visuals']
                ['data']
            .map((e) {
          return {'seleccionado': false, ...e};
        }).toList();
        response['data'][i]['attributes']['sub_espe_visuals']['data'] = newMap;
      }

      selectEspecialidadExtras = response['data'];
      setState(() {});
    }
  }

  loadData() async {
    if (widget.area == 0) {
      setState(() {
        claveGeneral = "sub_especialidades";
      });
      var response = await AreasConnections()
          .getAreaEspecialidadSubCategoriasID(widget.idSelect);
      var newMap =
          response['data']['attributes']['sub_especialidades']['data'].map((e) {
        return {'seleccionado': false, ...e};
      }).toList();
      response['data']['attributes']['sub_especialidades']['data'] = newMap;
      selectEspecialidad = response['data'];
      setState(() {});
    } else {
      setState(() {
        claveGeneral = "sub_espe_visuals";
      });
      var response = await AreasConnections()
          .getAreaVisualSubCategoriasID(widget.idSelect);
      var newMap =
          response['data']['attributes']['sub_espe_visuals']['data'].map((e) {
        return {'seleccionado': false, ...e};
      }).toList();
      response['data']['attributes']['sub_espe_visuals']['data'] = newMap;
      selectEspecialidad = response['data'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(15.0),
      insetPadding: EdgeInsets.all(10.0),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Preparar tu examen",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Área Seleccionada:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    selectEspecialidad == null ||
                            selectEspecialidadExtras == null
                        ? Container()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectEspecialidad['attributes']['Titulo'],
                                style: TextStyle(
                                    fontSize: 18,
                                    color: colorGeneralBlue,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "Si no seleccionas ninguna subespecialidad del área seleccionada, se tomarán todas automáticamente.",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: colorGeneralBlue,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Subespecialidades",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: colorGeneralBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ...List.generate(
                                        selectEspecialidad['attributes']
                                                [claveGeneral]['data']
                                            .length,
                                        (index) => CheckboxListTile(
                                              contentPadding:
                                                  EdgeInsets.all(2.0),
                                              value: selectEspecialidad[
                                                          'attributes']
                                                      [claveGeneral]['data']
                                                  [index]['seleccionado'],
                                              onChanged: (v) {
                                                setState(() {
                                                  selectEspecialidad['attributes']
                                                                  [claveGeneral]
                                                              ['data'][index]
                                                          ['seleccionado'] =
                                                      !selectEspecialidad[
                                                                      'attributes']
                                                                  [claveGeneral]
                                                              ['data'][index]
                                                          ['seleccionado'];
                                                });
                                              },
                                              title: Text(
                                                selectEspecialidad['attributes']
                                                            [claveGeneral]
                                                        ['data'][index]
                                                    ['attributes']['Titulo'],
                                                style: TextStyle(),
                                              ),
                                            ))
                                  ],
                                ),
                              ),
                              Divider(),
                              Text(
                                "Si deseas agregar otras áreas, puedes seleccionar alguna de sus subespecialidades.",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: colorGeneralBlue,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Divider(),
                              ...List.generate(
                                  selectEspecialidadExtras.length,
                                  (index) => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            selectEspecialidadExtras[index]
                                                ['attributes']['Titulo'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: colorGeneralBlue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Subespecialidades",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: colorGeneralBlue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                ...List.generate(
                                                    selectEspecialidadExtras[
                                                                        index][
                                                                    'attributes']
                                                                [claveGeneral]
                                                            ['data']
                                                        .length,
                                                    (interalIndex) =>
                                                        CheckboxListTile(
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          value: selectEspecialidadExtras[
                                                                              index]
                                                                          [
                                                                          'attributes']
                                                                      [
                                                                      claveGeneral]
                                                                  [
                                                                  'data'][interalIndex]
                                                              ['seleccionado'],
                                                          onChanged: (v) {
                                                            setState(() {
                                                              selectEspecialidadExtras[index]['attributes']
                                                                              [claveGeneral]
                                                                          ['data']
                                                                      [interalIndex]
                                                                  ['seleccionado'] = !selectEspecialidadExtras[index]
                                                                              ['attributes']
                                                                          [
                                                                          claveGeneral]['data']
                                                                      [
                                                                      interalIndex]
                                                                  [
                                                                  'seleccionado'];
                                                            });
                                                          },
                                                          title: Text(
                                                            selectEspecialidadExtras[index]
                                                                            [
                                                                            'attributes']
                                                                        [
                                                                        claveGeneral]['data']
                                                                    [
                                                                    interalIndex]
                                                                [
                                                                'attributes']['Titulo'],
                                                            style: TextStyle(),
                                                          ),
                                                        ))
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                        ],
                                      ))
                            ],
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onPressed: () async {
                  var response = await ExamConnections()
                      .generateTotalExamSpecificQuestions(selectEspecialidad,
                          selectEspecialidadExtras, widget.area);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return NumberQuestions(
                          questionsMax: response['data'],
                          selectEspecialidad: selectEspecialidad,
                          selectEspecialidadExtras: selectEspecialidadExtras,
                          area: widget.area,
                        );
                      });
                },
                child: Text("Continuar"))
          ],
        ),
      ),
    );
  }
}
