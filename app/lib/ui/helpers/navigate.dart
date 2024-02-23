import 'package:app/main.dart';
import 'package:app/ui/widgets/pay_information.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

navigateMembership(context, functions) {
  if (localStorage!.getString("membresia") == "activa") {
    functions();
  }else{
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
                  Center(
                      child: Icon(
                    Icons.info,
                    color: Colors.blue,
                    size: 30,
                  )),
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
                      OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("No")),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(onPressed: () {
                        showDialog(context: context, builder: (context){
                          return PayInformation();
                        });

                      }, child: Text("Si")),
                    ],
                  )
                ],
              ),
            );
          });
  }
}
