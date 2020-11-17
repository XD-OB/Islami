import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'mapScreen.dart';
import 'consts.dart';
import 'tasbeeh.dart';
import 'compass.dart';
import 'drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Color(BGcolor),
        primaryColor: Color(GreenyBarid),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _widgetIndex = 1;
  int target = 99;
  int counter = 0;

  // Modify target:
  void modifyTarget(int nbr) {
    setState(() {
      if (nbr > 1000 || nbr == 0) {
        nbr = 99;
      }
      target = nbr;
      counter = 0;
    });
  }

  // init Hassanat Counter:
  void initCounter() {
    setState(() {
      counter = 0;
    });
  }

  // Increment Hassanat Counter:
  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(BGcolor),
        key: _scaffoldKey,
        endDrawer: MyDrawer(
            target: target,
            modifyTarget: modifyTarget,
            initCounter: initCounter),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              IndexedStack(
                index: _widgetIndex,
                children: <Widget>[
                  Tasbeeh(
                      incrementCounter: incrementCounter,
                      target: target,
                      counter: counter),
                  QiblahCompass(),
                  MapScreen(),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: EdgeInsets.all(20.0),
                  color: Color(GreenyBarid),
                  icon: Icon(
                    Icons.settings,
                    size: 35,
                  ),
                  onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Color(GreenyBarid),
          color: Color(BGcolor),
          items: [
            TabItem(
                isIconBlend: true,
                icon: SvgPicture.asset('assets/tassbih.svg'),
                title: 'حساب تسابيح'),
            TabItem(icon: Icons.explore, title: 'اتجاه القِبلة'),
            TabItem(icon: Icons.map, title: 'خريطة المساجد'),
          ],
          initialActiveIndex: 1,
          onTap: (int i) => setState(() => _widgetIndex = i),
        ));
  }
}
