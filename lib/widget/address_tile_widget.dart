import 'package:flutter/material.dart';
import 'package:solaramps/utility/top_level_variables.dart';

class AddressTile extends StatefulWidget {
  final String addressTitle, addressDescription;
  const AddressTile(
      {Key? key, this.addressTitle = '', this.addressDescription = ''})
      : super(key: key);

  @override
  _AddressTileState createState() => _AddressTileState();
}

class _AddressTileState extends State<AddressTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          width: screenWidth,
          color: const Color.fromRGBO(245, 245, 245, 1),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.addressTitle,
                    style: TextStyle(color: appTheme.primaryColor),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.addressDescription,
                    style: const TextStyle(color: Colors.black, height: 2),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
