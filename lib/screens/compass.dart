import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../consts/languages.dart' show compass;
import '../components/widgetLoadingPos.dart';
import '../consts/consts.dart';
import 'dart:math';

class QiblahCompass extends StatelessWidget {
  final   language;

  QiblahCompass({
    this.language
  });

  @override
  Widget build(BuildContext context) {
    Size   screenSize = MediaQuery.of(context).size;

    return Center(
      child: StreamBuilder(
        stream: FlutterQiblah.qiblahStream,
        builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return WidgetLoadingPos(language, screenSize);

          final qiblahDirection = snapshot.data;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: (language == AR) ? TextDirection.rtl : TextDirection.ltr,
                children: <Widget>[
                  Text(
                    compass[language],
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    "${qiblahDirection.offset.toStringAsFixed(1)}°",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 25),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Transform.rotate(
                angle: ((qiblahDirection.qiblah ?? 0) * (pi / 180) * -1),
                alignment: Alignment.center,
                child: Image.asset('assets/Qiblah.png'),
              ),
            ],
          );
        },
      ),
    );
  }
}
