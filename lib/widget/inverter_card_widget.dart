import 'package:flutter/material.dart';
import 'package:solaramps/gen/assets.gen.dart';
import 'package:solaramps/utility/top_level_variables.dart';

class InverterCardWidget extends StatefulWidget {
  const InverterCardWidget({Key? key}) : super(key: key);

  @override
  _InverterCardWidgetState createState() => _InverterCardWidgetState();
}

class _InverterCardWidgetState extends State<InverterCardWidget> {
  final inverter = TopVariable.dashboardProvider.invertersList[0].split(' | ');
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(230, 86, 39, 0.16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image.asset(
              Assets.icInverter.path,
              width: 12,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  '${inverter[0]} | ${inverter[1]}',
                  style: const TextStyle(fontSize: 10),
                ),
                Text(
                  inverter[2],
                  style: const TextStyle(fontSize: 10),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
