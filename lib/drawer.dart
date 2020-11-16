import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'consts.dart';

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

  @override
  Widget build(BuildContext context) {
    _target = widget.target;

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              'assets/lailaha.png',
            ),
            decoration: BoxDecoration(
              color: Color(GreenyBarid),
            ),
          ),
          ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              'اعدادات التسبيح',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.calculate_outlined),
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
                        if (text.length < 5)
                          _target = int.parse(text);
                        else
                          _target = 999;
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
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  widget.initCounter();
                  Navigator.pop(context);
                }
              ),
            ],
          ),
          ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              'اعدادات القبلة',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.calculate_outlined),
            children: <Widget>[
              Container(
                child: ListTile(
                  title: Text(
                    'إعادة التعيين إلى الصفر',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
