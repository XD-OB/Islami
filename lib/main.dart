import 'package:flutter/material.dart';
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
  var _widgetIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(BGcolor),
        key: _scaffoldKey,
        endDrawer: MyDrawer(),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              IndexedStack(
                index: _widgetIndex,
                children: <Widget>[
                  Tasbeeh(),
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
            TabItem(icon: Icons.calculate, title: 'tassbi7'),
            TabItem(icon: Icons.explore, title: 'compass'),
            TabItem(icon: Icons.map, title: 'Map'),
          ],
          initialActiveIndex: 1,
          onTap: (int i) => setState(() => _widgetIndex = i),
        ));
  }
}
