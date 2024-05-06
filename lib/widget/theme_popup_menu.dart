import 'package:flutter/material.dart';
import '../../shared/controllers/theme_controller.dart';

// Widget used to change the used FlexSchemeData index in example 5.
class ThemePopupMenu extends StatelessWidget {
  const ThemePopupMenu({
    Key? key,
    required this.controller,
    this.contentPadding,
  }) : super(key: key);
  final ThemeController controller;
  // Defaults to 16, like ListTile does.
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
   final ColorScheme colorScheme = theme.colorScheme;

    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      onSelected: controller.setSchemeIndex,
      itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
        for (int i = 0; i < 10; i++)
          PopupMenuItem<int>(
            value: i,
            child: ListTile(

              title:Text('$i hour'),
            ),
          )
      ],
      child: ListTile(
        contentPadding:
        contentPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        title: const Text(
          'Check Call Interval',
        ),
        trailing: Icon(
          Icons.arrow_drop_down,
          color: colorScheme.primary,
          size: 40,
        ),
      ),
    );
  }
}
