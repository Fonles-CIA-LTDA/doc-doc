import 'package:app/connections/flascards.dart';
import 'package:app/helpers/server.dart';
import 'package:app/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FlashCardMenu extends StatefulWidget {
  const FlashCardMenu({super.key});

  @override
  State<FlashCardMenu> createState() => _FlashCardMenuState();
}

class _FlashCardMenuState extends State<FlashCardMenu> {
  static const _pageSize = 25;
  TextEditingController _controller = TextEditingController();

  final PagingController _pagingController = PagingController(firstPageKey: 1);
  GlobalKey<ScaffoldState> _scaffoldKeyFlashCardsMenu =
      GlobalKey<ScaffoldState>();

  loadData(pageKey) async {
    var response = await FlashCardConnections().getFlashCardsMenu(pageKey);
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
      key: _scaffoldKeyFlashCardsMenu,
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
                                  _scaffoldKeyFlashCardsMenu.currentState!
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
                          "Flash Cards",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Especialidades",
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
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(
                          "Busca dentro de las Flash Cards",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        _textField(context, "Búsqueda", _controller),
                        SizedBox(
                          height: 2,
                        ),
                        Divider()
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
    return Container(
      margin: EdgeInsets.all(7.0),
      child: GestureDetector(
        onTap: () {
          Get.toNamed("/flash-cards?search=false&query="
              "&id=${item['attributes']['Titulo'].toString()}");
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Text(
              item['attributes']['Titulo'].toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }

  Padding _textField(BuildContext context, hintText, controllerParam) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xfff3f3f3),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.transparent, // Color del foco al hacer clic
            ),
            child: Center(
              child: TextField(
                controller: controllerParam,
                onSubmitted: (value) {
                  Get.toNamed("/flash-cards?search=true&query=${value}&id=''");
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: hintText,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
