import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownFieldWidget<T> extends StatelessWidget {
  const DropdownFieldWidget({
    Key? key,
    this.labelText = "Select",
    this.items = const [],
    this.onChanged,
  }) : super(key: key);

  final String labelText;
  final List<String> items;
  final Function(String v)? onChanged;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String selectedItem = items[0];

    return FormField<String>(
      // initialValue: "Select",
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
              errorStyle: const TextStyle(fontSize: 16.0),
              hintText: labelText,
              labelText: labelText,
              contentPadding: const EdgeInsets.all(10.0),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.1),
              ),
              // OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              //   borderSide: const BorderSide(
              //     color: Colors.grey,
              //     width: 1.5,
              //   ),
              // ),
              labelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                height: 1,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.openSans().fontFamily,
              ),
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                height: 1,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.openSans().fontFamily,
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                borderSide: BorderSide(width: 1, color: Colors.black87),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          // isEmpty: state.value == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: state.value,
                isDense: true,
                onChanged: (newValue) {
                  if (kDebugMode) {
                    print('newValue of Drop Down ::::: $newValue');
                  }
                  state.didChange(newValue!);
                  onChanged?.call(newValue);
                  selectedItem = newValue;
                  if (kDebugMode) {
                    print('selectedItem of Drop Down ::::: $selectedItem');
                  }
                },
                hint: Text(labelText),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  height: 1,
                  fontWeight: FontWeight.w500,
                  fontFamily: GoogleFonts.openSans().fontFamily,
                ),
                items: items.toSet().map(
                  (value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                          value.contains('\n') ? value.split('\n')[0] : value),
                    );
                  },
                ).toList()),
          ),
        );
      },
    );
  }
}
