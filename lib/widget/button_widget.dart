// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color? color;


  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(child: ElevatedButton(
    //style: Theme.of(context).elevatedButtonTheme.style,
    style: ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      onPrimary: Colors.white,
      fixedSize: Size(MediaQuery.of(context).size.width/2.3, 50),
      primary: color ?? Theme.of(context).buttonTheme.colorScheme?.primary,
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
    child: Text(text, style: Theme.of(context).primaryTextTheme.subtitle1,),
    onPressed: onClicked,
  ),
  );
}