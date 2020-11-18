import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'consts/languages.dart' show drawer;
import 'package:geolocator/geolocator.dart';
import 'components/langContainer.dart';
import 'components/langTiles.dart';
import 'consts/consts.dart';
import 'dart:async';


class MyDrawer extends StatefulWidget {
  final modifyTarget;
  final initCounter;
  final changeLang;
  final target;
  final language;

  MyDrawer(
      {this.modifyTarget,
      this.initCounter,
      this.changeLang,
      this.target,
      this.language});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _target;

  // Permission change:
  getLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
    }
  }

  // Share the App
  Future<void> _shareApp() async {
    await FlutterShare.share(
        title: 'Check my app',
        text: drawer[widget.language]['shareDescription'],
        linkUrl: 'https://google.com/',
        chooserTitle: 'إسلامي');
  }

  @override
  Widget build(BuildContext context) {
    _target = widget.target;
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              'assets/ico.png',
            ),
          ),
          ExpLangTile(
            text: drawer[widget.language]['tasbihSets'],
            language: widget.language,
            icon: ImageIcon(
              AssetImage('assets/tssbi7.png'),
              color: Color(GreenyBarid),
            ),
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: drawer[widget.language]['chooseGoal'],
                      ),
                      textAlign: TextAlign.center,
                      initialValue: _target.toString(),
                      onChanged: (text) {
                        _target = (text.length < 5) ? int.parse(text) : 999;
                      },
                      onEditingComplete: () {
                        widget.modifyTarget(_target);
                        Navigator.pop(context);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                  title: Text(
                    drawer[widget.language]['reset'],
                    textAlign: TextAlign.center,
                    style: btnStyle,
                  ),
                  onTap: () {
                    widget.initCounter();
                    Navigator.pop(context);
                  }),
            ],
          ),
          SizedBox(height: 20),
          ExpLangTile(
            text: drawer[widget.language]['generalSets'],
            language: widget.language,
            icon: Icon(
              Icons.settings,
              color: Color(GreenyBarid),
            ),
            children: <Widget>[
              Text(drawer[widget.language]['selectLang']),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: langArContainer(widget.language),
                      onTap: () =>
                          {if (widget.language != AR) widget.changeLang(AR)},
                    ),
                    GestureDetector(
                      child: langFrContainer(widget.language),
                      onTap: () =>
                          {if (widget.language != FR) widget.changeLang(FR)},
                    ),
                    GestureDetector(
                      child: langEngContainer(widget.language),
                      onTap: () =>
                          {if (widget.language != ENG) widget.changeLang(ENG)},
                    ),
                  ],
                ),
              ),
              Container(
                child: ListTile(
                  title: Text(
                    drawer[widget.language]['locationAccess'],
                    textAlign: TextAlign.center,
                    style: btnStyle,
                  ),
                  onTap: () {
                    getLocationPermission();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ListLangTile(
            text: drawer[widget.language]['share'],
            language: widget.language,
            onTap: _shareApp,
            icon: Icon(
              Icons.share,
              color: Color(GreenyBarid),
            ),
          ),
        ],
      ),
    );
  }
}
