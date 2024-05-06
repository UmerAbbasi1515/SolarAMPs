import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solaramps/utility/top_level_variables.dart';

import '../gen/assets.gen.dart';

class ForecastWeatherWidget extends StatefulWidget {
  final String date, description, tempMin, tempMax;
  const ForecastWeatherWidget(
      {Key? key,
      required this.date,
      required this.description,
      required this.tempMin,
      required this.tempMax})
      : super(key: key);

  @override
  _ForecastWeatherWidgetState createState() => _ForecastWeatherWidgetState();
}

class _ForecastWeatherWidgetState extends State<ForecastWeatherWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      elevation: 1,
      child: Container(
        padding:const EdgeInsets.symmetric(vertical: 5),
        margin:const EdgeInsets.only(right: 9, left: 3),
        alignment: Alignment.topCenter,
        width: screenWidth! / 6,
        height: screenHeight! / 6,
        child: Column(
          children: [
            Text(
              widget.date,
              style:const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
           const SizedBox(
              height: 5,
            ),
            SvgPicture.asset(Assets.sun, height: 30, width: 30),
           const SizedBox(
              height: 8,
            ),
            Text(
              widget.description + "\n",
              maxLines: 2,
              style:const TextStyle(color: Colors.black, fontSize: 10),
            ),
          const  SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.up_arrow,
                    size: 10, color: appTheme.primaryColor),
                Text(
                  '${widget.tempMax} °C',
                  style: TextStyle(fontSize: 10, color: appTheme.primaryColor),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const  Icon(CupertinoIcons.down_arrow, size: 10, color: Colors.blue),
                Text(
                  '${widget.tempMin} °C',
                  style:const TextStyle(fontSize: 10, color: Colors.blue),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
