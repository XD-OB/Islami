import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'consts.dart';

class Tasbeeh extends StatefulWidget {
  @override
  _TasbeehState createState() => _TasbeehState();
}

class _TasbeehState extends State<Tasbeeh> {
  int _counter = 0;
  int _target = 69;
  double _percent = 0;

  // Increment Hassanat Counter:
  void _incrementCounter() {
    setState(() {
      _counter++;
      if (_percent + 1 / _target < 1)
        _percent += (1 / _target);
      else
        _percent = 1;
      print(double.parse(_percent.toStringAsFixed(3)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              'assets/5.png',
              height: 300,
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              padding: const EdgeInsets.fromLTRB(80, 20, 80, 10),
              decoration: BoxDecoration(
                border: Border.all(width: .0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'عدد التسبيحات',
                  ),
                  Text(
                    '$_counter',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Color(GreenyBarid)),
                  ),
                  Center(
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 180,
                      animation: false,
                      lineHeight: 18.0,
                      percent: double.parse(_percent.toStringAsFixed(3)),
                      center: Text(
                          '${(double.parse(_percent.toStringAsFixed(3)) * 100).toInt()}%'),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Color(GreenyBarid),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    '$_target : الهدف',
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: FloatingActionButton(
                backgroundColor: Color(GreenyBarid),
                onPressed: _incrementCounter,
                tooltip: 'تسبيح',
                child: Image.asset(
                  'assets/1.png',
                  height: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
