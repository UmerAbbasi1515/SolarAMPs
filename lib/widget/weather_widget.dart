import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/utility/top_level_variables.dart';

import '../providers/dashboard_provider.dart';
import 'detailed_weather_widget.dart';

class WeatherWidget extends StatefulWidget {
  final String city, country, lat, lng, weatherIcon;
  final double temp;
  const WeatherWidget(
      {Key? key,
      required this.city,
      required this.country,
      required this.temp,
      required this.lat,
      required this.lng,
      required this.weatherIcon})
      : super(key: key);

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    double tempInC = widget.temp - 275.15;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () async {
          await TopVariable.dashboardProvider
              .fetchWeatherForecastData(widget.lat, widget.lng)
              .then((value) => showDetailedWeatherWidget(
                  '${widget.city}, ${widget.country}', widget.lat, widget.lng));
        },
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            margin: EdgeInsets.zero,
            elevation: 2,
            child: Container(
              width: screenWidth,
              height: 120,
              color: tempInC <= 10
                  ?const Color.fromRGBO(130, 199, 240, 1)
                  : tempInC <= 20
                      ?const Color.fromRGBO(130, 199, 240, 1)
                      : const Color.fromRGBO(130, 199, 240, 1),
              child: Stack(
                children: [
                  Positioned(
                      top: 15,
                      left: 17,
                      child: Row(
                        children: [
                          //Icon(Icons.location_pin, color: Colors.white,size: 15,),
                          /*Lottie.asset(tempInC<=10?'assets/lottie/thunderstorm.json':tempInC<=20?'assets/lottie/cloudy.json':
                        'assets/lottie/thunderstorm.json', width: 50, height: 50, fit: BoxFit.fill),*/
                          Image.network(
                            'http://openweathermap.org/img/wn/${widget.weatherIcon}@2x.png',
                            width: 60,
                          ),
                          //SizedBox(width: 5,),
                          Text(
                            '${double.parse((tempInC).toStringAsFixed(2))}',
                            style: TextStyle(
                                fontSize: appTheme
                                    .primaryTextTheme.headline6!.fontSize!,
                                color: Colors.white),
                          ),
                          Text(
                            '°C',
                            style: TextStyle(
                                fontSize: appTheme
                                    .primaryTextTheme.bodyText1!.fontSize,
                                color: Colors.white),
                          )
                        ],
                      )),
                  Positioned(
                      bottom: 15,
                      left: 30,
                      child: Row(
                        children: [
                         const Icon(
                            Icons.location_pin,
                            color: Colors.white,
                            size: 15,
                          ),
                          Text(
                            ' ${widget.city}, ${widget.country}',
                            style: TextStyle(
                                fontSize: appTheme
                                    .primaryTextTheme.subtitle2!.fontSize,
                                color: Colors.white),
                          ),
                        ],
                      )),
                  Positioned(
                      top: 30,
                      right: 15,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: [
                                Consumer<DashboardProvider>(builder:
                                    (context, dashboardConsumer, child) {
                                  /*child = ProductionGraph(graphData: dashboardConsumer.allGraphSeries.toString(), width: screenHeight!-50, height: screenWidth!-100,
                      xAxisData: dashboardConsumer.graphXAxis.toString(), graphType: dashboardConsumer.graphType,);*/
                                  child = Text(
                                    dashboardConsumer.currentPowerValueToday,
                                    style:const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  );
                                  return child;
                                }),
                               const Text(
                                  ' Watts',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                         const Text(
                            'CURRENT VALUE TODAY',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                 const Positioned(
                    bottom: 15,
                    right: 50,
                    child: Text(
                      '1 Inverter',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
