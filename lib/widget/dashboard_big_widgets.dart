import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utility/top_level_variables.dart';

class DashboardBigWidgets extends StatefulWidget {
  final String imagePath, title, value;
  final Color background, valueColor, descriptionColor;
  const DashboardBigWidgets(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.value,
      required this.background,
      required this.valueColor,
      required this.descriptionColor})
      : super(key: key);

  @override
  _DashboardBigWidgetsState createState() => _DashboardBigWidgetsState();
}

class _DashboardBigWidgetsState extends State<DashboardBigWidgets> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color:const Color.fromRGBO(255, 255, 255, 1),
      child: SizedBox(
        width: screenWidth! / 2 - 12,
        height: 100,
        child: Container(
          color: widget.background,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    widget.imagePath,
                    height: 30,
                    fit: BoxFit.cover,
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //  SizedBox(width: 5,),
                  Text(
                    widget.value == 'null' ? '0' : widget.value,
                    style: TextStyle(
                        color: widget.valueColor,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            const  SizedBox(
                height: 5,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                        color: widget.descriptionColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
