import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/gen/assets.gen.dart';
import 'package:solaramps/providers/dashboard_provider.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import 'forecast_weather_widget.dart';
import 'inverter_card_widget.dart';

class WeatherWidgetDetailed extends StatefulWidget {
  final String loc, lat, lng;
  const WeatherWidgetDetailed({Key? key, required this.loc, required this.lat, required this.lng}) : super(key: key);

  @override
  _WeatherWidgetDetailedState createState() => _WeatherWidgetDetailedState();
}

class _WeatherWidgetDetailedState extends State<WeatherWidgetDetailed> {

  List<Widget> weatherForecastCards = [];
  List<Widget> loadForeCastCards(){
    weatherForecastCards = [];
    for(int i=1; i<5; i++){
      weatherForecastCards.add(ForecastWeatherWidget(date: TopVariable.dashboardProvider.weatherForecastModels[i].dtTxt!,
      description: TopVariable.dashboardProvider.weatherForecastModels[i].description!,
        tempMin: TopVariable.dashboardProvider.weatherForecastModels[i].tempMin!,
        tempMax: TopVariable.dashboardProvider.weatherForecastModels[i].tempMax!,));
    }
    return weatherForecastCards;
  }
  String updatedAt = DateFormat('hh:mm a').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding:const EdgeInsets.all(0),
      insetPadding:const EdgeInsets.all(15),
      backgroundColor:const Color.fromRGBO(250, 250, 250, 1),
      content: /*Stack(
        children: [*/
          Container(
            //alignment: Alignment.center,
              height: screenHeight!/2 ,
              width: screenWidth,
              padding:const EdgeInsets.only(top: 5, left: 10, right: 5),
              child: ListView(
                   /* crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,*/
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: Align(
                                heightFactor: 0.5,
                                alignment: Alignment.topRight,
                                child: IconButton(onPressed: (){
                                  Navigator.pop(context);
                                }, icon:const Icon(Icons.close), alignment: Alignment.topRight, padding: EdgeInsets.zero,),
                              )
                          )
                        ],
                      ),
                     // SizedBox(height: 10,),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                         const Icon(Icons.location_on, color: Colors.black,),
                         const SizedBox(width: 7,),
                          Text(widget.loc, style:const TextStyle(color: Colors.black, fontSize: 20),),
                        ],
                      ),
                      Container(
                        padding:const EdgeInsets.only(left: 7,top: 5, bottom: 5),
                        child:const Text('1 Inverter', textAlign: TextAlign.start,),
                      ),
                      SingleChildScrollView(
                        // scrollDirection: Axis.horizontal,
                        child: Row(
                          children:const [
                            InverterCardWidget(),/*InverterCardWidget(),*/
                          ],
                        ),
                      ),
                    const  SizedBox(height: 10,),
                      Container(
                        alignment: Alignment.center,
                        height: 0.2,
                        width: screenWidth!-50,
                        color: Colors.grey,
                      ),
                      Container(
                        padding:const EdgeInsets.symmetric(vertical: 10),
                        child: Text('TODAY', style: TextStyle(color: appTheme.primaryColor, fontSize: 12),),
                      ),
                      Consumer<DashboardProvider>(builder:
                      (context, dashboardConsumer, child) {
                        child = Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(Assets.sun, width: 30,),
                                     const SizedBox(width: 10,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${TopVariable.dashboardProvider.weatherForecastModels[0].temp} °C', style:const TextStyle(fontSize: 18, color: Colors.black),),
                                          Text(TopVariable.dashboardProvider.weatherForecastModels[0].description!, style:const TextStyle(fontSize: 10, color: Colors.black),textAlign: TextAlign.start,)
                                        ],
                                      ),
                                     const SizedBox(width: 10,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(CupertinoIcons.up_arrow,size: 10, color: appTheme.primaryColor),
                                              Text('${TopVariable.dashboardProvider.weatherForecastModels[0].tempMax} °C', style: TextStyle(fontSize: 10, color: appTheme.primaryColor),)
                                            ],
                                          ),
                                         const SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Text(' ${TopVariable.dashboardProvider.weatherForecastModels[0].humidity}', style:const TextStyle(fontSize: 10, color: Colors.black),),
                                            const  SizedBox(width: 2,),
                                            const  Icon(CupertinoIcons.percent,size: 10, color: Colors.black),
                                            const  SizedBox(width: 3,),
                                              SvgPicture.asset(Assets.humidity, height: 12,)
                                            ],
                                          ),
                                        ],
                                      ),
                                    const  SizedBox(width: 10,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                            const  Icon(CupertinoIcons.down_arrow,size: 10, color: Colors.blue),
                                              Text('${TopVariable.dashboardProvider.weatherForecastModels[0].tempMin} °C',
                                                style:const TextStyle(fontSize: 10, color: Colors.blue), overflow: TextOverflow.visible,)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            ),
                            Container(
                                alignment:Alignment.topRight,
                                //kjkl
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      /*IconButton(
                                        onPressed: (){
                                        setState(() {
                                          updatedAt = DateFormat('hh:mm a').format(DateTime.now());
                                          TopVariable.dashboardProvider.fetchWeatherForecastData(widget.lat, widget.lng);
                                        });
                                      }, icon: Icon(CupertinoIcons.arrow_2_circlepath, size: 17,),
                                      padding: EdgeInsets.zero, constraints: BoxConstraints(), iconSize: 17,),*/
                                     const SizedBox(height: 8,),
                                      Text('Updated: $updatedAt', style:const TextStyle(fontSize: 10, color: Colors.grey),)
                                    ],
                                  ),
                                )
                            ),
                          ],
                        );
                        return child;
                      }),

                     const SizedBox(height: 10,),
                      Container(
                        padding:const EdgeInsets.only(top: 10),
                        child: Text('FORECAST', style: TextStyle(color: appTheme.primaryColor, fontSize: 12),),
                      ),
                      Consumer<DashboardProvider>(builder:
                          (context, dashboardConsumer, child) {
                        child = Row(children: loadForeCastCards(),);
                        return child;
                      }),
                    ],
                  ),

          ),
         /* Positioned(
            top: 0, right: 10,
            child: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.close), alignment: Alignment.centerRight, padding: EdgeInsets.zero,),)
        ],
      )*/
    );
  }

}

showDetailedWeatherWidget(String location, String lat, String lng) async {
  return showDialog<void>(
    context: appNavigationKey.currentContext!,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return WeatherWidgetDetailed(loc: location,lat: lat, lng: lng,);
    },
  );
}
