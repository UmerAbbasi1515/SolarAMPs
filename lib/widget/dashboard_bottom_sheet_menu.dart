import 'package:flutter/material.dart';

class DashboardBottomSheetMenu extends StatefulWidget {
  const DashboardBottomSheetMenu({Key? key}) : super(key: key);

  @override
  _DashboardBottomSheetMenuState createState() =>
      _DashboardBottomSheetMenuState();
}

class _DashboardBottomSheetMenuState extends State<DashboardBottomSheetMenu> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: const Text('showModalBottomSheet'),
        onPressed: () {
          // when raised button is pressed
          // we display showModalBottomSheet
          showModalBottomSheet<void>(
            // context and builder are
            // required properties in this widget
            context: context,
            builder: (BuildContext context) {
              // we set up a container inside which
              // we create center column and display text
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:const <Widget>[
                       Text('GeeksforGeeks'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
