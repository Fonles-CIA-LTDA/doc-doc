import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

getDrawer() {
  return Drawer(
    backgroundColor: Colors.white,
    child: SafeArea(
        child: Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.close),
                  padding: EdgeInsets.all(0.0),
                ),
              ),
              SizedBox(
                  width: 200,
                  child: Image(image: AssetImage("./assets/logos/DOCD.png"))),
              SizedBox(
                height: 20,
              ),
              ListTile(
                onTap: () {},
                title: Text(
                  "Top Usuarios",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "POWERED BY DOC DOC",
                  style: TextStyle(fontSize: 10),
                ),
              ),
              Divider(),
              ListTile(
                onTap: () {},
                title: Text(
                  "Material de estudio",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "POWERED BY DOC DOC",
                  style: TextStyle(fontSize: 10),
                ),
              ),
              Divider(),
            ],
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.redAccent,),
          onTap: () {
            Get.offAllNamed("/welcome");
          },
          title: Text(
            "Cerrar Sesión",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
        ),
      ],
    )),
  );
}
