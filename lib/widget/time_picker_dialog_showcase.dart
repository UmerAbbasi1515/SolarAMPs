import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../shared/widgets/universal/header_card.dart';
import '../shared/widgets/universal/theme_showcase.dart';


// ignore: unused_element
class _TimePickerDialogShowcase extends StatelessWidget {
  const _TimePickerDialogShowcase(
      {Key? key, required this.isOpen, required this.onTap})
      : super(key: key);
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HeaderCard(
      isOpen: isOpen,
      onTap: onTap,
      title: const Text('Themed TimePickerDialog'),
      child: const TimePickerDialogShowcase(),
    );
  }
}