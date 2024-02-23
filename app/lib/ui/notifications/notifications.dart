import 'dart:math';

import 'package:app/connections/noticias.dart';
import 'package:app/ui/widgets/drawer.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/route_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  GlobalKey<ScaffoldState> _scaffoldKeyNotifications =
      GlobalKey<ScaffoldState>();

  static const _pageSize = 25;

  final PagingController _pagingController = PagingController(firstPageKey: 1);

  loadData(pageKey) async {
    var response = await NoticiasConnections().getNoticias(pageKey);
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
      key: _scaffoldKeyNotifications,
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
                                  _scaffoldKeyNotifications.currentState!
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
                          "Noticias DOC DOC",
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
                      itemBuilder: (context, item, index) => Card(
                        child: _model(item),
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }

  SizedBox _model(item) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Center(
                          child: Image(
                              image: AssetImage("./assets/logos/DOCD.png")),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "DOC DOC",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                markdownToWidget(item['attributes']['Noticia'], 500, true),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Fecha: ${item['attributes']['Fecha'].toString() == "null" ? "" : item['attributes']['Fecha']}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget markdownToWidget(String markdown, int maxWords, show) {
    return MarkdownBody(
      data: markdown,
      selectable: show,
    );
  }
}
