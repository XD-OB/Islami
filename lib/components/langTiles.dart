import 'package:flutter/material.dart';
import '../consts/consts.dart';


ExpansionTile   ExpLangTile({text, language, icon, children}) {
  if (language == AR)
    return  ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                text,
                textDirection: TextDirection.rtl,
                style: titleStyle,
              ),
              trailing: icon,
              children: children,
            );
  else
    return  ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                text,
                style: titleStyle,
              ),
              leading: icon,
              children: children,
            );
}

ListTile    ListLangTile({text, language, icon, onTap}) {
  if (language == AR)
    return  ListTile(
                trailing: icon,
                title: Text(
                  text,
                  textDirection: TextDirection.rtl,
                  style: titleStyle,
                ),
                onTap: onTap,
            );
  else
    return  ListTile(
                leading: icon,
                title: Text(
                  text,
                  style: titleStyle,
                ),
                onTap: onTap,
            );
}