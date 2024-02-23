import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/route_manager.dart';

class PayInformation extends StatefulWidget {
  const PayInformation({super.key});

  @override
  State<PayInformation> createState() => _PayInformationState();
}

class _PayInformationState extends State<PayInformation> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(10.0),
      contentPadding: EdgeInsets.all(12),
      content: Platform.isAndroid
          ? Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Planes de Suscripción",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _modelPlan("Mensual","\$99.00 MXN \nRenovación automática", () {}),
                      Divider(),
                      _modelPlan("3 meses","\$249.00 MXN", () {}),
                      Divider(),
                      _modelPlan("6 Meses","\$499.00 MXN", () {}),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        title: Text('Simulador completo de 280 preguntas'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        title: Text(
                            'Examen personalizado para número de preguntas y especialidad'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        title: Text(
                            'Retroalimentación escrita / flashcard de cada pregunta; con bibliografía actualizada de Guías de Práctica Clínica (GPC)'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        title: Text('Examen visual personalizado'),
                        subtitle: Text(
                            'Ultrasonido, Radiografía, Tomografía Computarizada, Resonancia Magnética y la sección para Dermatología'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        title: Text(
                            'Estadísticas de cada examen realizado, progreso'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        title: Text(
                            'Flashcards de cada especialidad (con acceso a ele)'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        title: Text(
                            'Escalas / Clasificación / Criterios diagnósticos'),
                        subtitle:
                            Text('Ejemplo: Alvarado, Framingham, BI-RADS, etc'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        title: Text(
                            'Forma práctica de aprender lo importante sobre Vacunas'),
                        subtitle: Text('Tema relevante y constante del ENARM'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        title: Text(
                            'Enlace a Guías de Práctica Clínica (organizadas por especialidad)'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("Cerrar"))
                    ],
                  ),
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Actualmente no es posible actualizar a la versión premium en iPhone a través de la aplicación. Te invitamos a visitar nuestro sitio web en www.docdocenarm.com para obtener información detallada",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Aceptar"))
              ],
            ),
    );
  }

  GestureDetector _modelPlan(text,value, func) {
    return GestureDetector(
      onTap: () {
        func();
      },
      child: Material(
        elevation: 2,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(value)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
