import 'dart:math';

import 'package:app/connections/escalas.dart';
import 'package:app/connections/flascards.dart';
import 'package:app/connections/material.dart';
import 'package:app/helpers/server.dart';
import 'package:app/ui/widgets/drawer.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/route_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

class Escalas extends StatefulWidget {
  const Escalas({super.key});

  @override
  State<Escalas> createState() => _EscalasState();
}

class _EscalasState extends State<Escalas> {
  static const _pageSize = 25;

  final PagingController _pagingController = PagingController(firstPageKey: 1);
  GlobalKey<ScaffoldState> _scaffoldKeyFlashCards = GlobalKey<ScaffoldState>();
  String identificator = "";
  String query = "";
  String search = "";
  loadData(pageKey) async {
    var response =
        await EscalasConnections().getEscalasCards(pageKey, identificator);
    final isLastPage = response['data'].length < _pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(response['data']);
    } else {
      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(response['data'], nextPageKey);
    }
  }

  loadDataSearch(pageKey) async {
    var response = await EscalasConnections().getEscalasSearch(pageKey, query);
    final isLastPage = response['data'].length < _pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(response['data']);
    } else {
      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(response['data'], nextPageKey);
    }
  }

  @override
  void initState() {
    var searchG = Get.parameters['search'];
    setState(() {
      search = searchG!;
    });
    if (searchG == "false") {
      setState(() {
        identificator = Get.parameters['id']!;
      });
      _pagingController.addPageRequestListener((pageKey) {
        loadData(pageKey);
      });
    } else {
      setState(() {
        query = Get.parameters['query']!;
      });
      _pagingController.addPageRequestListener((pageKey) {
        loadDataSearch(pageKey);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(context),
      resizeToAvoidBottomInset: true,
      key: _scaffoldKeyFlashCards,
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(10.0),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.arrow_back_ios)),
                          ],
                        ),
                        Text(
                          "Escalas",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${search == "true" ? "Búsqueda" : identificator}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  PagedSliverList(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, item, index) => _model(item),
                    ),
                  ),
                ],
              ))),
    );
  }

  _model(item) {
    return Material(
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              final imageProvider = Image.network(
                      "${generalServer}${item['attributes']['Imagen']['data']['attributes']['url']}")
                  .image;
              showImageViewer(context, imageProvider, onViewerDismissed: () {
              }, doubleTapZoomable: true);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Image.network(
                "${generalServer}${item['attributes']['Imagen']['data']['attributes']['url']}",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 0,
                ),
                Text(
                  "Título",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  item['attributes']['Titulo'].toString(),
                  style: TextStyle(),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Descripción",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  item['attributes']['Descripcion'].toString(),
                  style: TextStyle(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
