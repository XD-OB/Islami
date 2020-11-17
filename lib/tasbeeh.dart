import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'languages.dart' show tasbih;
import 'consts.dart';

class Tasbeeh extends StatefulWidget {
  final int   counter;
  final int   target;
  final int   language;
  final       incrementCounter;

  Tasbeeh({
    this.target,
    this.counter,
    this.language,
    this.incrementCounter,
  });

  @override
  _TasbeehState createState() => _TasbeehState();
}

class _TasbeehState extends State<Tasbeeh> {
  double percent;
  Size screenSize;

  @override
  Widget build(BuildContext context) {
    // Affect percent
    screenSize = MediaQuery.of(context).size;
    percent = ((widget.counter + 1) / widget.target) < 1
        ? widget.counter / widget.target
        : 1;

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              'assets/TasbeehBG.png',
              height: (screenSize.height / 3),
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
                    tasbih[widget.language]['count'],
                  ),
                  Text(
                    '${widget.counter}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenSize.height / 12,
                        color: Color(GreenyBarid)),
                  ),
                  Center(
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 180,
                      animation: false,
                      lineHeight: 18.0,
                      percent: double.parse(percent.toStringAsFixed(3)),
                      center: Text(
                          '${(double.parse(percent.toStringAsFixed(3)) * 100).toInt()}%'),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Color(GreenyBarid),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    '${widget.target} : ${tasbih[widget.language]['count']}',
                  ),
                ],
              ),
            ),
            SizedBox(
              width: screenSize.height / 7,
              height: screenSize.width / 4,
              child: FloatingActionButton(
                backgroundColor: Color(GreenyBarid),
                onPressed: widget.incrementCounter,
                tooltip: tasbih[widget.language]['tasbih'],
                child: Image.asset(
                  'assets/tssbi7.png',
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
