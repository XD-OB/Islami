import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:geolocator/geolocator.dart';
import 'langTap.dart';
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
        title: 'تطبيق مسلمي',
        text:
            'تطبيق للمسلمين للعثور على القبلة ، وتسهيل عد التسبيح وإيجاد المساجد',
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
              'اعدادات التسبيح',
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
                        hintText: 'اختر هدفك في عدد التسبيحات',
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
                    'إعادة التعيين إلى الصفر',
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
              'اعدادات عامة',
              textDirection: TextDirection.rtl,
              style: titleStyle,
            ),
            trailing: Icon(Icons.calculate_outlined, color: Color(GreenyBarid)),
            children: <Widget>[
              Text('اختيار اللغة'),
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
                    'تحديد الموقع',
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
              'سأشارك هذا التطبيق',
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
