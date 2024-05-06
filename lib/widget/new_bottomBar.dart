// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/top_level_variables.dart';

class NewBottomBar extends StatefulWidget {
  final currentIndex = 0;
  const NewBottomBar(int index, {Key? key}) : super(key: key);

  @override
  State<NewBottomBar> createState() => _NewBottomBarState();
}

class _NewBottomBarState extends State<NewBottomBar> {
  Widget bottomBar() {
    return BottomNavigationBar(
        currentIndex: widget.currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: CustomColor.grenishColor,
        onTap: (e) {
          switch (e) {
            case 1:
              TopVariable.switchScreen("/customer_support");
              break;
            case 3:
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Notifications'),
                  content: const Text('No new notification available.'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
              break;
            default:
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_support), label: "Support"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "More"),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return bottomBar();
  }
}
