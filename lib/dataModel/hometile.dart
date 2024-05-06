
import 'package:flutter/cupertino.dart';

class HomeTile {
  const HomeTile(
      {  this.icon,
        required this.title,
        required this.desc,
        required this.navigationPath,
      });

  final String title;
  final String desc;
  final Icon? icon;
  final String navigationPath;


  @override
  String toString() => "$title (desc=$desc)";
}