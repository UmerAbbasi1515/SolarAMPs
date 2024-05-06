// ignore_for_file: prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class _TheState {}

var _theState = RM.inject(() => _TheState());

class _SelectRow extends StatelessWidget {
  final Function(bool) onChange;
  final bool selected;
  final String text;

  const _SelectRow(
      {Key? key,
      required this.onChange,
      required this.selected,
      required this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: .8,
          child: Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.5),
              ),
              value: selected,
              onChanged: (x) {
                onChange(x!);
                _theState.notify();
              }),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 10, fontFamily: GoogleFonts.notoSans().fontFamily),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

///
/// A Dropdown multiselect menu
///
///
class DropDownMultiSelectCustom extends StatefulWidget {
  /// The options form which a user can select
  final List<String> options;

  /// Selected Values
  final List<String> selectedValues;

  /// This function is called whenever a value changes
  final Function(List<String>) onChanged;

  /// defines whether the field is dense
  final bool isDense;

  /// defines whether the widget is enabled;
  final bool enabled;

  /// Input decoration
  final InputDecoration? decoration;

  /// this text is shown when there is no selection
  final String? whenEmpty;

  /// a function to build custom childern
  final Widget Function(List<String> selectedValues)? childBuilder;

  /// a function to build custom menu items
  final Widget Function(String option)? menuItembuilder;

  const DropDownMultiSelectCustom({
    Key? key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    required this.whenEmpty,
    this.childBuilder,
    this.menuItembuilder,
    this.isDense = false,
    this.enabled = true,
    this.decoration,
  }) : super(key: key);
  @override
  _DropDownMultiSelectCustomState createState() =>
      _DropDownMultiSelectCustomState();
}

class _DropDownMultiSelectCustomState extends State<DropDownMultiSelectCustom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            _theState.rebuild(() => widget.childBuilder != null
                ? widget.childBuilder!(widget.selectedValues)
                : Align(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Text(
                        'Search Inverters',
                        style: TextStyle(
                            fontSize: 13,
                            color: const Color.fromRGBO(156, 156, 156, 100),
                            fontFamily: GoogleFonts.notoSans().fontFamily),
                      ),
                    ),
                    alignment: Alignment.centerLeft)),
            Align(
              alignment: Alignment.centerLeft,
              child: DropdownButtonFormField<String>(
                icon: const Icon(
                  Icons.search,
                  color: Color.fromRGBO(156, 156, 156, 100),
                ),
                // itemHeight: 0,
                //  hint: Text('Search Inverters', style: TextStyle(fontSize: 13),),
                dropdownColor: const Color.fromRGBO(255, 255, 255, 1),
                style: TextStyle(
                    fontFamily: GoogleFonts.notoSans().fontFamily,
                    fontSize: 9,
                    color: const Color.fromRGBO(0, 0, 0, 1),
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis),
                isExpanded: true,
                decoration: widget.decoration != null
                    ? widget.decoration
                    : const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 7,
                          horizontal: 7,
                        ),
                      ),
                isDense: true,
                onChanged: widget.enabled
                    ? (x) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    : null,
                value: null,
                selectedItemBuilder: (context) {
                  return widget.options
                      .map((e) => DropdownMenuItem(
                            child: widget.menuItembuilder != null
                                ? widget.menuItembuilder!(e)
                                : const Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ))
                      .toList();
                },
                items: widget.options
                    .map((x) => DropdownMenuItem(
                          child: _theState.rebuild(() {
                            return widget.menuItembuilder != null
                                ? widget.menuItembuilder!(x)
                                : _SelectRow(
                                    selected: widget.selectedValues.contains(x),
                                    text: x,
                                    onChange: (isSelected) {
                                      if (isSelected) {
                                        var ns = widget.selectedValues;
                                        ns.add(x);
                                        widget.onChanged(ns);
                                      } else {
                                        var ns = widget.selectedValues;
                                        ns.remove(x);
                                        widget.onChanged(ns);
                                      }
                                      setState(() {
                                        allSelectedInverters = [];
                                        for (final selectedInverter
                                            in widget.selectedValues) {
                                          allSelectedInverters.add(
                                              InverterSelected(
                                                  selectedOption:
                                                      selectedInverter,
                                                  onCrossPressed: (value) {
                                                    var ns =
                                                        widget.selectedValues;
                                                    ns.remove(selectedInverter);
                                                    widget.onChanged(ns);
                                                    allSelectedInverters
                                                        .remove(value);
                                                  }));
                                        }
                                      });
                                    },
                                  );
                          }),
                          value: x,
                          onTap: () {
                            if (widget.selectedValues.contains(x)) {
                              var ns = widget.selectedValues;
                              ns.remove(x);
                              widget.onChanged(ns);
                            } else {
                              var ns = widget.selectedValues;
                              ns.add(x);
                              widget.onChanged(ns);
                            }
                            setState(() {
                              allSelectedInverters = [];
                              for (final selectedInverter
                                  in widget.selectedValues) {
                                Widget oneSelectedInverter = InverterSelected(
                                  selectedOption: selectedInverter,
                                  onCrossPressed: (value) {
                                    var ns = widget.selectedValues;
                                    ns.remove(selectedInverter);
                                    widget.onChanged(ns);
                                    allSelectedInverters.remove(value);
                                    // allSelectedInverters.remove(selectedInverter);
                                  },
                                );
                                allSelectedInverters.add(oneSelectedInverter);
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          child: Column(
            children: allSelectedInverters,
          ),
        ),
      ],
    );
  }
}

List<Widget> allSelectedInverters = [];

class InverterSelected extends StatefulWidget {
  final String selectedOption;
  final CallBackFunction onCrossPressed;
  const InverterSelected(
      {Key? key, required this.selectedOption, required this.onCrossPressed})
      : super(key: key);

  @override
  _InverterSelectedState createState() => _InverterSelectedState();
}

class _InverterSelectedState extends State<InverterSelected> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: const Color.fromRGBO(255, 241, 236, 10),
      child: Container(
        width: screenWidth! - 35,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: 35,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                'assets/ic_inverter.png',
                height: 20,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Text(
                widget.selectedOption,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
              ),
            ),
            IconButton(
              onPressed: () async {
                widget.onCrossPressed(widget);
              },
              icon: const Icon(
                Icons.close,
              ),
              iconSize: 18,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerRight,
            ),
            /*InkWell(
              onTap: () async{
                */ /*setState(() {
                  allSelectedInverters.remove(widget);
                });*/ /*
                widget.onCrossPressed;
                */ /*ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please complete the form properly.')),
                );*/ /*
              },
              child: const Icon(
                Icons.close,
                size: 18,
              ),
            )*/
          ],
        ),
      ),
    );
  }
}

typedef CallBackFunction = void Function(Widget);
