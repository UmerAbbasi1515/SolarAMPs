import 'package:flutter/material.dart';


class CustomDropdown extends StatefulWidget {
  const CustomDropdown({Key? key}) : super(key: key);


  @override
  _CustomDropdown createState() => _CustomDropdown();


}

class _CustomDropdown extends State<CustomDropdown> {
  String dropdownValue = '1 hour';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(
          color: Colors.black54,
          fontSize: 18
      ),
      underline: Container(
        height: 2,
        color: Colors.black87,
      ),
      onChanged: (newValue) =>
      (setState(() {
        dropdownValue = newValue!;
      })),
      items: <String>['1 hour', '2 hour', '3 hour', '4 hour']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

}