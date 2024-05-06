import 'package:flutter/material.dart';

class DashboardSmallWidget extends StatefulWidget {
  final String imagePath, title, value, unit;
  const DashboardSmallWidget(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.value,
      required this.unit})
      : super(key: key);

  @override
  _DashboardSmallWidgetState createState() => _DashboardSmallWidgetState();
}

class _DashboardSmallWidgetState extends State<DashboardSmallWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: const Color.fromRGBO(255, 255, 255, 1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        // width: screenWidth!/2.5,
        height: 80,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    widget.imagePath,
                    width: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.value,
                    style: const TextStyle(
                        color: Color.fromRGBO(57, 182, 255, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    ' ${widget.unit}',
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                        color: Color.fromRGBO(46, 56, 80, 1),
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
