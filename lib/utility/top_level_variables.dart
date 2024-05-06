import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/network/interceptor/logging_interceptor.dart';
import 'package:solaramps/providers/dashboard_provider.dart';
import 'package:solaramps/providers/home_screen_provider.dart';
import 'package:solaramps/providers/tickets_provider.dart';
import 'package:solaramps/utility/constants.dart';
import '../network/api_service.dart';
import '../providers/general_provider.dart';
import 'package:dio/dio.dart';
import '../providers/advanced_profile_provider.dart';

final GlobalKey<NavigatorState> appNavigationKey = GlobalKey<NavigatorState>();
double? screenWidth =
    MediaQuery.of(appNavigationKey.currentContext!).size.width;
double? screenHeight =
    MediaQuery.of(appNavigationKey.currentContext!).size.height;
ThemeData appTheme = Theme.of(appNavigationKey.currentContext!);

class TopVariable extends ChangeNotifier {
  static Dio getDioInstance() {
    Dio dio = Dio();
    dio.options = BaseOptions(
      receiveTimeout: 7000,
      connectTimeout: 70000,
      // connectTimeout: 7000,
    );
    dio.interceptors.add(Logging());
    return dio;
  }

  static final ApiService apiService =
      ApiService(getDioInstance(), Constants.config['baseUrl']);
      
  static switchScreenAndRemoveAll(String screenName) {
    Navigator.of(appNavigationKey.currentContext!)
        .pushNamedAndRemoveUntil(screenName, (Route<dynamic> route) => false);
  }

  static switchScreen(String screenName) {
    Navigator.of(appNavigationKey.currentContext!).pushNamed(screenName);
  }

  static DashboardProvider dashboardProvider = Provider.of<DashboardProvider>(
      appNavigationKey.currentContext!,
      listen: false);
  static AdvancedProfileProvider advancedProfileProvider =
      Provider.of<AdvancedProfileProvider>(appNavigationKey.currentContext!,
          listen: false);
  static TicketsProvider ticketsProvider = Provider.of<TicketsProvider>(
      appNavigationKey.currentContext!,
      listen: false);

  static GeneralProvider generalProvider = Provider.of<GeneralProvider>(
      appNavigationKey.currentContext!,
      listen: false);

  static HomeScreenProvider homeScreenProvider =
      Provider.of<HomeScreenProvider>(appNavigationKey.currentContext!,
          listen: false);
}
