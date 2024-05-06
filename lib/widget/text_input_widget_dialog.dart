// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputDialogWidget extends StatefulWidget {
  final String label;
  final String? initialValue;
  final Icon? icon;
  VoidCallback? callback;
  FocusNode? focusNode;
  final TextInputType? textInputType;
  ValueChanged<String>? onChanged;
  final TextEditingController? textEditingController;
  final List<TextInputFormatter>? inputFormatter;
  TextInputDialogWidget(
      {
        this.textEditingController,
        this.callback,
        Key? key,
        required this.label,
        this.initialValue = "",
        this.icon,
        this.focusNode,
        this.textInputType,
        this.onChanged,
        this.inputFormatter //[ FilteringTextInputFormatter.allow(  RegExp('[0-9]')),]
      })
      : super(key: key);

  @override
  _TextInputDialogWidget createState() => _TextInputDialogWidget();
}

class _TextInputDialogWidget extends State<TextInputDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 1, left: 10, right: 10),
          height: 60,
          child: TextFormField(
         //   readOnly: true,
            initialValue:
                widget.initialValue == '' ? null : widget.initialValue,
            textDirection: TextDirection.ltr,
            //   expands: true,
            maxLines: 1,
            minLines: 1,
            //    maxLength: 2,
            focusNode: widget.focusNode,
            controller: widget.textEditingController,
            onTap: widget.callback,
            decoration: InputDecoration(
              suffixIcon: widget.icon,
              labelText: widget.label,

            ),
            //    focusNode: widget.focusNode,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black54

            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter some value";
              } else {
                return null;
              }
            },
            keyboardType: widget.textInputType,
            inputFormatters:widget.inputFormatter,
            // style: Theme.of(context).textTheme.caption,

            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
