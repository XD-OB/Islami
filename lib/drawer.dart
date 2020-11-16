import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'consts.dart';
import 'dart:async';

// Titles Style
const TextStyle   titleStyle = TextStyle(
  color: Colors.black87,
  fontWeight: FontWeight.bold,
  fontSize: 18,
);

const TextStyle   btnStyle = TextStyle(
  color: Color(GreenyBarid),
  fontWeight: FontWeight.bold,
  fontSize: 15,
);

class MyDrawer extends StatefulWidget {
  final   modifyTarget;
  final   initCounter;
  final   target;

  MyDrawer({this.modifyTarget, this.initCounter, this.target});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _target;

  Future<void> _shareApp() async {
    await FlutterShare.share(
      title: 'تطبيق مسلمي',
      text: 'تطبيق للمسلمين للعثور على القبلة ، وتسهيل عد التسبيح وإيجاد المساجد',
      linkUrl: 'https://google.com/',
      chooserTitle: 'إسلامي'
    );
  }

  @override
  Widget build(BuildContext context) {
    _target = widget.target;
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              'assets/makkah.png',
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
                }
              ),
            ],
          ),
          SizedBox(height: 20),
          ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              'اعدادات القبلة',
              textDirection: TextDirection.rtl,
              style: titleStyle,
            ),
            trailing: Icon(
              Icons.calculate_outlined,
              color: Color(GreenyBarid)
            ),
            children: <Widget>[
              Container(
                child: ListTile(
                  title: Text(
                    'إعادة التعيين إلى الصفر',
                    textAlign: TextAlign.center,
                    style: btnStyle,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ListTile(
            trailing: Icon(
              Icons.share,
              color: Color(GreenyBarid)
            ),
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
