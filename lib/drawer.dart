import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'languages.dart' show drawer;
import 'package:geolocator/geolocator.dart';
import 'langContainer.dart';
import 'consts.dart';
import 'dart:async';


class MyDrawer extends StatefulWidget {
  final   modifyTarget;
  final   initCounter;
  final   changeLang;
  final   target;
  final   language;

  MyDrawer({
    this.modifyTarget,
    this.initCounter,
    this.changeLang,
    this.target,
    this.language
  });

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
          ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              drawer[widget.language]['tasbihSets'],
              textDirection: TextDirection.rtl,
              style: titleStyle,
            ),
            trailing: ImageIcon(
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
          ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              drawer[widget.language]['generalSets'],
              textDirection: TextDirection.rtl,
              style: titleStyle,
            ),
            trailing: Icon(Icons.calculate_outlined, color: Color(GreenyBarid)),
            children: <Widget>[
              Text(drawer[widget.language]['selectLang']),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: langArContainer(widget.language),
                      onTap: () => {
                        if (widget.language != AR)
                          widget.changeLang(AR)
                      },
                    ),
                    GestureDetector(
                      child: langFrContainer(widget.language),
                      onTap: () => {
                        if (widget.language != FR)
                          widget.changeLang(FR)
                      },
                    ),
                    GestureDetector(
                      child: langEngContainer(widget.language),
                      onTap: () => {
                        if (widget.language != ENG)
                          widget.changeLang(ENG)
                      },
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
          ListTile(
            trailing: Icon(Icons.share, color: Color(GreenyBarid)),
            title: Text(
              drawer[widget.language]['share'],
              textDirection: TextDirection.rtl,
              style: titleStyle,
            ),
            onTap: _shareApp,
          ),
        ],
      ),
    );
  }
}
