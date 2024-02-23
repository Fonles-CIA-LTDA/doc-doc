import 'dart:math';

import 'package:app/connections/statistics.dart';
import 'package:app/ui/widgets/drawer.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class TopUsers extends StatefulWidget {
  const TopUsers({super.key});

  @override
  State<TopUsers> createState() => _TopUsersState();
}

class _TopUsersState extends State<TopUsers> {
  GlobalKey<ScaffoldState> _scaffoldKeyTopUsers = GlobalKey<ScaffoldState>();
  List top = [];
  @override
  void initState() {
    loadPromedio();
   
    super.initState();
  }

  loadPromedio() async {
    var response = await StatisticsConnections().getStatisticsTop();
    setState(() {
      top = response['data'];
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(context),
      resizeToAvoidBottomInset: true,
      key: _scaffoldKeyTopUsers,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      _scaffoldKeyTopUsers.currentState!.openDrawer();
                    },
                    icon: Icon(Icons.menu)),
                IconButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {},
                    icon: Icon(Icons.notifications))
              ],
            ),
            Text(
              "Top Usuarios",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  columns: [
                    DataColumn2(
                      label: Icon(
                        Icons.grade_outlined,
                        color: Color.fromARGB(255, 203, 191, 83),
                      ),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text('Nombre'),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text('Universidad'),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text('Estado'),
                      size: ColumnSize.L,
                    ),
                  ],
                  rows: List<DataRow>.generate(
                      top.length,
                      (index) => DataRow(cells: [
                            DataCell(Text(top[index]['promedio'].toStringAsFixed(2))),
                            DataCell(Text(top[index]['name'].toString())),
                            DataCell(Text(top[index]['university'].toString())),
                            DataCell(Text(top[index]['state'].toString())),
                          ]))),
            ),
            Text(
                "Aquí te presentamos los 10 mejores promedios de Doc Doc. ¡Esfuérzate para formar parte de este selecto grupo!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      )),
    );
  }
}
