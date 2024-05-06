import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/providers/dashboard_provider.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        decoration: BoxDecoration(color: appTheme.primaryColor),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hi ${UserPreferences.user.firstName!}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Consumer<DashboardProvider>(builder: (context, value, child) {
                if (value.weatherData != null) {
                  var temp = (double.parse(
                              value.weatherData!['main']['temp'].toString()) -
                          275.15)
                      .toStringAsFixed(0);
                  var icon =
                      value.weatherData!['weather'][0]['icon'].toString();
                  return Row(
                    children: [
                      Image.network(
                        value.weatherData == null
                            ? 'http://openweathermap.org/img/wn/03d@2x.png'
                            : 'http://openweathermap.org/img/wn/$icon@2x.png',
                        width: 60,
                      ),
                      value.weatherData != null
                          ? Text(temp + "°C",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(.8),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))
                          : const Text(""),
                    ],
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
