import 'package:app/ui/config/config.dart';
import 'package:app/ui/simulators/simulators.dart';
import 'package:app/ui/statistics/statistics.dart';
import 'package:app/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKeyHome = GlobalKey<ScaffoldState>();

  int indexPage = 0;
  late Image _doc1;
  late Image _doc1Select;
  late Image _doc2;
  late Image _doc2Select;
  late Image _doc3;
  late Image _doc3Select;
  Map<String, Widget> docsImages = {};
  List pages = [];
  @override
  void initState() {
    setState(() {
      pages = [
        SimulatorsPage(
          keyS: _scaffoldKeyHome,
        ),
        StatisticsPage(
          keyS: _scaffoldKeyHome,
        ),
        ConfigPage(
          keyS: _scaffoldKeyHome,
        )
      ];
      _doc1 = Image.asset("./assets/icons/doc1.png");
      _doc1Select = Image.asset("./assets/icons/doc1_select.png");
      _doc2 = Image.asset("./assets/icons/doc2.png");
      _doc2Select = Image.asset("./assets/icons/doc2_select.png");
      _doc3 = Image.asset("./assets/icons/doc3.png");
      _doc3Select = Image.asset("./assets/icons/doc3_select.png");
      docsImages = {
        "_doc1": _doc1,
        "_doc1Select": _doc1Select,
        "_doc2": _doc2,
        "_doc2Select": _doc2Select,
        "_doc3": _doc3,
        "_doc3Select": _doc3Select,
      };
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: getDrawer(context),
        resizeToAvoidBottomInset: true,
        key: _scaffoldKeyHome,
        body: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          return SafeArea(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: indexPage!=2? Image.asset("./assets/logos/DOCD MA2.png"):SizedBox(),
                ),
                Column(
                  children: [Expanded(child: pages[indexPage]),isKeyboardVisible?Container(): _doc()],
                ),
              ],
            ),
          );
        }));
  }

  _doc() {
    return Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.50,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFFEFEBF4),
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x0F1A0433),
              blurRadius: 8,
              offset: Offset(0, -4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _dot(0, "Simuladores"),
            _dot(1, "Resultados"),
            _dot(2, "Configuración")
          ],
        ));
  }

  GestureDetector _dot(index, text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          indexPage = index;
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            docsImages.isEmpty
                ? SizedBox()
                : SizedBox(
                    child: docsImages[index == indexPage
                        ? '_doc${index + 1}Select'
                        : '_doc${index + 1}'],
                  ),
            SizedBox(
              height: 2,
            ),
            Text(
              text,
              style: TextStyle(
                  color: indexPage == index
                      ? Color.fromRGBO(119, 0, 225, 1.0)
                      : Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
