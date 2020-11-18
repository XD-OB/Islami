import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'consts/languages.dart' show menu;
import 'screens/mapScreen.dart';
import 'consts/consts.dart';
import 'screens/tasbeeh.dart';
import 'screens/compass.dart';
import 'drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
  int language = ENG;

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

  // Change language:
  void changeLang(newlang) {
    setState(() {
      language = newlang;
    });
  }

  Scaffold  LangScaffold({language, myDrawer, body, bottomNavBar}) {
    if (language == AR)
      return Scaffold(
        backgroundColor: Color(BGcolor),
        key: _scaffoldKey,
        endDrawer: myDrawer,
        body: body,
        bottomNavigationBar: bottomNavBar,
      );
    else
      return Scaffold(
        backgroundColor: Color(BGcolor),
        key: _scaffoldKey,
        drawer: myDrawer,
        body: body,
        bottomNavigationBar: bottomNavBar,
      );
  }

  @override
  Widget build(BuildContext context) {
    return LangScaffold(
        language: language,
        myDrawer: MyDrawer(
          language: language,
          target: target,
          changeLang: changeLang,
          modifyTarget: modifyTarget,
          initCounter: initCounter,
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              IndexedStack(
                index: _widgetIndex,
                children: <Widget>[
                  Tasbeeh(
                    incrementCounter: incrementCounter,
                    language: language,
                    target: target,
                    counter: counter,
                  ),
                  QiblahCompass(
                    language: language,
                  ),
                  MapScreen(
                    language: language,
                  ),
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
                  onPressed: (language == AR) ?
                    () => _scaffoldKey.currentState.openEndDrawer() :
                    () => _scaffoldKey.currentState.openDrawer(),
                ),
              ),
            ],
          ),
        ),
        bottomNavBar: ConvexAppBar(
          backgroundColor: Color(GreenyBarid),
          color: Color(BGcolor),
          items: [
            TabItem(
                isIconBlend: true,
                icon: SvgPicture.asset('assets/tassbih.svg'),
                title: menu[language]['tasbih']),
            TabItem(icon: Icons.explore, title: menu[language]['compass']),
            TabItem(icon: Icons.map, title: menu[language]['map']),
          ],
          initialActiveIndex: 1,
          onTap: (int i) => setState(() => _widgetIndex = i),
        ));
  }
}
