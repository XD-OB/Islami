import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../consts/consts.dart';

// Language Arab Button
Widget    langArContainer(int lang) {
  return Container(
            padding: EdgeInsets.all(3),
            child: SvgPicture.asset('assets/ar.svg', width: 30),
            decoration: BoxDecoration(
              border: Border.all(
              color: (lang == AR) ? Color(GreenyBarid) : Color(BGcolor),
              width: 4,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        );
}

// Language French Button
Widget    langFrContainer(int lang) {
  return Container(
            padding: EdgeInsets.all(3),
            child: SvgPicture.asset('assets/fr.svg', width: 30),
            decoration: BoxDecoration(
              border: Border.all(
              color: (lang == FR) ? Color(GreenyBarid) : Color(BGcolor),
              width: 4,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        );
}

// Language English Button
Widget    langEngContainer(int lang) {
  return Container(
            padding: EdgeInsets.all(3),
            child: SvgPicture.asset('assets/eng.svg', width: 30),
            decoration: BoxDecoration(
              border: Border.all(
              color: (lang == ENG) ? Color(GreenyBarid) : Color(BGcolor),
              width: 4,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        );
}