import 'dart:math';

import 'package:app/connections/material.dart';
import 'package:app/helpers/server.dart';
import 'package:app/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/route_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

class StudyMaterial extends StatefulWidget {
  const StudyMaterial({super.key});

  @override
  State<StudyMaterial> createState() => _StudyMaterialState();
}

class _StudyMaterialState extends State<StudyMaterial> {
  static const _pageSize = 25;

  final PagingController _pagingController = PagingController(firstPageKey: 1);
  GlobalKey<ScaffoldState> _scaffoldKeyStudyMaterial =
      GlobalKey<ScaffoldState>();

  loadData(pageKey) async {
    var response = await MaterialConnections().getMaterialEstudio(pageKey);
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
    _pagingController.addPageRequestListener((pageKey) {
      loadData(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(context),
      resizeToAvoidBottomInset: true,
      key: _scaffoldKeyStudyMaterial,
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
                                  _scaffoldKeyStudyMaterial.currentState!
                                      .openDrawer();
                                },
                                icon: Icon(Icons.menu)),
                            IconButton(
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  Get.toNamed("/notifications");
                                },
                                icon: Icon(Icons.notifications))
                          ],
                        ),
                        Text(
                          "Material de Estudio",
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
                  PagedSliverGrid(
                    pagingController: _pagingController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      crossAxisCount: 2,
                      mainAxisExtent: 250.0
                    ),
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, item, index) => Card(
                        child: _model(item),
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }

  _model(item) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            launchUrl(Uri.parse(item['attributes']['Link']));
          },
          child: Material(
              elevation: 2,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: SizedBox(
                width: 170,
                height: 240,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Image.network(
                    "${generalServer}${item['attributes']['Imagen']['data']['attributes']['url']}",
                    fit: BoxFit.cover,
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
