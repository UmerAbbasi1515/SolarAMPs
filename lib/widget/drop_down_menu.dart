import 'package:flutter/material.dart';

import '../theme/color.dart';
import '../utility/constants.dart';

// ignore: must_be_immutable
class DropDownWidget extends StatefulWidget {
  ValueChanged<String>? onValueChanged;
  String value = Constants.TAG_RELATIONSHIP;
  DropDownWidget({Key? key,this.onValueChanged,required this.value}) : super(key: key);

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  // String dropdownValue = 'Relationship';

  @override
  Widget build(BuildContext context) {
    // dropdownValue = widget.value!;
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.only(bottom: 5, left: 10), child: const Align( alignment:Alignment.topLeft,child:Text("Relationship"))),
          Container(padding: const EdgeInsets.only(bottom: 1, left: 10, right: 10), child:
            DecoratedBox(
              decoration: BoxDecoration(
              //background color of dropdown button
              color:Theme.of(context).inputDecorationTheme.fillColor,
              border: Border.all(color: CustomColor.primary, width:2), //border of dropdown button
              borderRadius: BorderRadius.circular(20), //border raiuds of dropdown button

              ),
              child:  Padding(
              padding: const EdgeInsets.only(left:10, right:10, top: 5, bottom: 5),
              child: DropdownButton<String>(
                value: widget.value,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(color: Colors.black54),
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    widget.value = newValue!;
                    widget.onValueChanged!(newValue);
                  });
                },
         /*    Uncle Aunt Grandmother Grandfather*/

             items: <String>['Relationship','Father', 'Mother', 'Sister', 'Brother','Father in law', 'Mother in law', 'Sister in law',
              'Brother in law','Acquaintance','Colleague','Uncle','Aunt','Grandfather','Grandmother',]
                .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )))
          )
        ]
    );

  }
}
