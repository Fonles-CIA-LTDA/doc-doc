import 'dart:math';

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

class FlashCards extends StatefulWidget {
  const FlashCards({super.key});

  @override
  State<FlashCards> createState() => _FlashCardsState();
}

class _FlashCardsState extends State<FlashCards> {
  static const _pageSize = 25;

  final PagingController _pagingController = PagingController(firstPageKey: 1);
  GlobalKey<ScaffoldState> _scaffoldKeyFlashCards = GlobalKey<ScaffoldState>();
  String identificator = "";
  String query = "";
  String search = "";
  loadData(pageKey) async {
    var response =
        await FlashCardConnections().getFlashCards(pageKey, identificator);
    final isLastPage = response['data'].length < _pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(response['data']);
    } else {
      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(response['data'], nextPageKey);
    }
  }

  loadDataSearch(pageKey) async {
    var response = await FlashCardConnections()
        .getFlashCardsSearch(pageKey, query);
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
                          "Flash Cards",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${search=="true"?"Búsqueda":identificator}",
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
        children: [
          GestureDetector(
            onTap: () {
              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return AlertDialog(
              //         contentPadding: EdgeInsets.all(0.0),
              //         insetPadding: EdgeInsets.all(0.0),
              //         content: SizedBox(
              //           child: Material(
              //             elevation: 2,
              //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //             child: Column(
              //               children: [
              //                 Align(
              //                   alignment: Alignment.centerRight,
              //                   child: IconButton(
              //                       onPressed: () {
              //                         Get.back();
              //                       },
              //                       icon: Icon(Icons.close)),
              //                 ),
              //                 Expanded(
              //                   child: ClipRRect(
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(10.0)),
              //                     child: Image.network(
              //                       "${generalServer}${item['attributes']['Imagen']['data']['attributes']['url']}",
              //                       fit: BoxFit.contain,
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       );
              //     });
              final imageProvider = Image.network(
                      "${generalServer}${item['attributes']['Imagen']['data']['attributes']['url']}")
                  .image;
              showImageViewer(context, imageProvider, onViewerDismissed: () {
                print("dismissed");
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
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
