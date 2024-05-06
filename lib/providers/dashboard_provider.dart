// ignore_for_file: unnecessary_string_escapes

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:solaramps/dataModel/weather_model.dart';
import 'package:solaramps/helper_/base_client.dart';
import 'package:solaramps/model_/weather_sites_model.dart';
import 'package:solaramps/shared/const/no_internet_screen.dart';
import 'package:solaramps/utility/internet_connectivity.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import 'package:http/http.dart' as http;
import 'package:solaramps/widget/dashboard_big_widgets.dart';
import 'package:solaramps/widget/dashboard_small_widget.dart';
import 'package:solaramps/widget/subscription_tile_widget.dart';
import 'package:solaramps/widget/weather_widget.dart';
import '../utility/shared_preference.dart';
import '../widget/production_graph_syncfusion.dart';

class DashboardProvider extends ChangeNotifier {
  RxBool isLoadingForJustObs = false.obs;
  List<dynamic>? customerInvertersData;
  List<dynamic>? customerSubscriptions;
  Map<String, dynamic>? subscription;
  List<dynamic>? subscriptionMappings;
  List<String> invertersList = [];
  Map<String, dynamic>? mappedResponse;
  Map<String, dynamic>? mappedResponseYield;
  Map<String, dynamic>? mappedResponseTreePlanted;
  // Inverters
  String premiseNo = '';
  String variantName = '';
  String variantAlias = '';
  String subName = '';
  String activeSince = '';
  String inverterSubscriptionId = '';
  String inverterSubscriptionTemplate = '';
  String inverterValue = '';
  double inverterLat = 0.0;
  double inverterLong = 0.0;
  List<InverterModel> allInverterModels = [];
  // Inverter End
  List<Widget> weatherCards = [];
  String currentPowerValueToday = '0.0';
  List<WeatherModel> weatherForecastModels = [
    WeatherModel(),
    WeatherModel(),
    WeatherModel(),
    WeatherModel(),
    WeatherModel(),
  ];
  List<Widget> dashboardSmallWidgets = const [
    DashboardSmallWidget(
        title: 'DAILY YEILD',
        unit: 'kWh',
        value: '0',
        imagePath: 'assets/ic_graph_points.png'),
    DashboardSmallWidget(
        title: 'PEAK VALUE TODAY',
        unit: 'Watts',
        value: '0',
        imagePath: 'assets/ic_peak.png'),
    DashboardSmallWidget(
        title: 'MONTH TO DATE YEILD',
        unit: 'kWh',
        value: '0',
        imagePath: 'assets/ic_graph_points.png'),
    DashboardSmallWidget(
        title: 'YEAR TO DATE YEILD',
        unit: 'kWh',
        value: '0',
        imagePath: 'assets/ic_graph_points.png'),
    DashboardSmallWidget(
        title: 'TOTAL YEILD',
        unit: 'kWh',
        value: '0',
        imagePath: 'assets/ic_peak.png'),
    DashboardSmallWidget(
        title: 'SYSTEM SIZE',
        unit: 'kV',
        value: '0',
        imagePath: 'assets/ic_solar_size.png')
  ];
  List<Widget> dashboardBigWidgets = [
    DashboardBigWidgets(
      title: 'CO\u2082 REDUCTION',
      imagePath: 'assets/ic_co2_reduction.svg',
      value: '0',
      background: const Color.fromRGBO(84, 95, 122, 1),
      valueColor: appTheme.colorScheme.secondary,
      descriptionColor: Colors.white,
    ),
    const DashboardBigWidgets(
      title: 'TREES PLANTED FACTOR',
      imagePath: 'assets/ic_tree.svg',
      value: '0',
      background: Color.fromRGBO(44, 201, 130, 0.25),
      valueColor: Color.fromRGBO(0, 186, 102, 1),
      descriptionColor: Color.fromRGBO(46, 56, 80, 1),
    ),
  ];
  bool inverterListReselected = false;

  checkInverter(int index, bool selected) {
    SubscriptionTile item = customerSubscriptionsTilesList[index];
    (item).selected = selected;
    if (selected) {
      selectedIds.add(item.subscriptionId);
    } else {
      selectedIds.remove(item.subscriptionId);
    }

    notifyListeners();
  }

  List weatherModelList = [];
  getInverterData() async {
    if (selectedIds.isNotEmpty) {
      if (kDebugMode) {
        print('Selected IDS :::::: $selectedIds.value');
      }
      loadUYieldWidgets(selectedIds);
      loadTreePlantedWidgets(selectedIds);
      loadGraphData(selectedIds);
      if (selectedIds.isNotEmpty) {
        await TopVariable.dashboardProvider
            .getWeatherOfSites(selectedIds.first);
      }

      notifyListeners();
    } else {
      mappedResponseYield = null;
      mappedResponseTreePlanted = null;
      mappedResponse = Map.from({
        "sytemSize": 0,
        "currentValue": 0.0,
        "peakValue": 0.0,
        "dailyYield": 0,
        "monthlyYield": 0.0,
        "annualYield": 0,
        "grossYield": 0,
        "treesPlanted": 0,
        "co2Reduction": 0
      });
    }
  }

  List<SubscriptionTile> customerSubscriptionsTilesList = [
    // SubscriptionTile(
    //   subscriptionId: '1003',
    //   subscriptionStatus: 'ACTIVE',
    // ),
    // SubscriptionTile(
    //   subscriptionId: '1004',
    //   subscriptionStatus: 'ACTIVE',
    // ),
    // SubscriptionTile(
    //   subscriptionId: '1005',
    //   subscriptionStatus: 'ACTIVE',
    // ),
    // SubscriptionTile(
    //   subscriptionId: '1006',
    //   subscriptionStatus: 'INACTIVE',
    // ),
  ];
  List<SubscriptionTile> customerSubscriptionsTilesListUserProfile = [];
  List<dynamic>? subscriptionsAPIData;

  List<String> graphData = [
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
    // """0.0""",
  ];

  GraphTime graphTime = GraphTime.daily;
  GraphType graphTypeDropdown = GraphType.cumulative;

  StringBuffer graphXAxis = StringBuffer(
      '["12:00","12:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30"]');
  List<String> syncfusionXAxis = [
    // "12:00",
    // "12:30",
    // "01:00",
    // "01:30",
    // "02:00",
    // "02:30",
    // "03:00",
    // "03:30",
    // "04:00",
    // "04:30",
    // "05:00",
    // "05:30",
    // "06:00",
    // "06:30",
    // "07:00",
    // "07:30",
    // "08:00",
    // "08:30",
    // "09:00",
    // "09:30",
    // "10:00",
    // "10:30",
    // "11:00",
    // "11:30",
    // "12:00",
    // "12:30",
    // "01:00",
    // "01:30",
    // "02:00",
    // "02:30",
    // "03:00",
    // "03:30",
    // "04:00",
    // "04:30",
    // "05:00",
    // "05:30",
    // "06:00",
    // "06:30",
    // "07:00",
    // "07:30",
    // "08:00",
    // "08:30",
    // "09:00",
    // "09:30",
    // "10:00",
    // "10:30",
    // "11:00",
    // "11:30"
  ];
  bool dailyGraph = true;
  List<SyncfusionPowerDataSeriesModel> syncfusionPowerData = [
    SyncfusionPowerDataSeriesModel(
      [],
      'Cumulative',
    )
  ];
  StringBuffer allGraphSeries = StringBuffer(
      '[{data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }]');
  String graphType = '\"spline\"';
  // String graphType = '\"spline\"';
  final String dataSeriesAttributes = ''',''';
  RxList<String> selectedIds = [''].obs;
  RxList<String> selectedIdsForGraph = [''].obs;

  DateTime selectedDate = DateTime.now().subtract(const Duration(days: 1));
  String? companyLogoPath = UserPreferences.tenantLogoPath;
  Widget companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
      ? SvgPicture.network(
          UserPreferences.tenantLogoPath != null
              ? UserPreferences.tenantLogoPath!
              : '',
          width: 100,
          height: screenHeight! / 5,
          fit: BoxFit.cover,
        )
      : Image.network(
          UserPreferences.tenantLogoPath!,
          height: 100,
          fit: BoxFit.cover,
        );

  String inverterSubscriptionStatus = '';
  String inverterSubscriptionPremiseNo = '';
  String inverterSubscriptionActivationDate = '';

  searchSubscriptions(String searchText) {
    customerSubscriptionsTilesListUserProfile.clear();
    subscriptionsAPIData?.forEach((subscription) {
      if (subscription['variantName']
          .toString()
          .contains(searchText.toString())) {
        customerSubscriptionsTilesListUserProfile.add(SubscriptionTile(
          premiseNo: subscription['premiseNo'].toString(),
          subscriptionId: subscription['subId'].toString(),
          subscriptionStatus: subscription["status"].toString(),
          garden: subscription["variantName"].toString(),
          activationDate: subscription["activeSince"].toString(),
        ));
      }
    });
    notifyListeners();
  }

  // new
  getCustomerSubscriptions() async {
    CheckConnectivity.isConnected().then((value) {
      companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
          ? SvgPicture.network(
              UserPreferences.tenantLogoPath != null
                  ? UserPreferences.tenantLogoPath!
                  : '',
              width: screenWidth! / 4,
              height: screenWidth! / 4,
            )
          : Image.network(
              UserPreferences.tenantLogoPath!,
              height: screenWidth! / 5,
            );
    });
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    allInverterModels = [];
    invertersList = [];
    customerSubscriptionsTilesList = [];
    customerSubscriptionsTilesListUserProfile = [];
    subscriptionsAPIData = [];

    TopVariable.apiService.getCustomerSubscriptionsList().then((value) {
      // checking if value is not null then will call this
      if (value['message']
              .contains('No subscriptions exists for this userId = ') ==
          true) {
        return;
      }
      customerInvertersData = value['data'] as List<dynamic>;
      if (customerInvertersData!.isNotEmpty) {
        subscriptionsAPIData = customerInvertersData;
        customerSubscriptions = customerInvertersData;
        for (int i = 0; i < customerSubscriptions!.length; i++) {
          final inverterModel = InverterModel();
          premiseNo = customerSubscriptions![i]['premiseNo'].toString();
          variantName = customerSubscriptions![i]['variantName'].toString();
          activeSince = customerSubscriptions![i]['activeSince'].toString();
          inverterSubscriptionId =
              customerSubscriptions![i]['subId'].toString();
          inverterModel.subscriptionId = inverterSubscriptionId;
          subName = customerSubscriptions![i]['subName'].toString();
          inverterSubscriptionStatus =
              customerSubscriptions![i]['status'].toString();

          // String subscriptionTemplate =
          //     customerSubscriptions![i]['subscriptionTemplate'].toString();
          // inverterSubscriptionTemplate =
          //     customerSubscriptions![i]['subscriptionTemplate'];
          // subscriptionMappings =
          //     customerSubscriptions![i]['customerSubscriptionMappings'];
          // try {
          //   for (Map<String, dynamic> subscriptionMapping
          //       in subscriptionMappings!) {
          //     if (subscriptionMapping['rateCode'] == 'INVRT') {
          //       inverterValue = subscriptionMapping['value'];
          //     } else if (subscriptionMapping['rateCode'] == 'LAT') {
          //       inverterModel.lat = subscriptionMapping['value'];
          //     } else if (subscriptionMapping['rateCode'] == 'LON') {
          //       inverterModel.lng = subscriptionMapping['value'];
          //     } else if (subscriptionMapping['rateCode'] == 'SSDT') {
          //       inverterSubscriptionActivationDate =
          //           subscriptionMapping['value'].toString();
          //       inverterSubscriptionPremiseNo =
          //           subscriptionMapping['subscriptionRateMatrixId'].toString();
          //     }
          //   }
          // } catch (e) {
          //   if (kDebugMode) {
          //     print(e);
          //   }
          // }

          invertersList.add(
              "$inverterSubscriptionId | $inverterValue | $inverterSubscriptionTemplate");
          allInverterModels.add(inverterModel);
          customerSubscriptionsTilesListUserProfile.add(SubscriptionTile(
            subscriptionId: inverterSubscriptionId,
            subscriptionStatus: inverterSubscriptionStatus,
            garden: variantName,
            premiseNo: premiseNo,
            activationDate: activeSince,
          ));
          customerSubscriptionsTilesList.add(SubscriptionTile(
              subscriptionId: inverterSubscriptionId,
              subscriptionTemplete: 'template IC',
              subscriptionStatus: inverterSubscriptionStatus,
              garden: variantName,
              premiseNo: premiseNo,
              activationDate: activeSince,
              selected: selectedIds.contains(inverterSubscriptionId),
              inverterValue: inverterValue));
        }
        notifyListeners();
        //   String invertersData = value.toString();
        if (kDebugMode) {
          print(invertersList.toString());
        }
      }
    });
  }

  // new
  getCustomerInverterAllowedSelection() async {
    CheckConnectivity.isConnected().then((value) {
      companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
          ? SvgPicture.network(
              UserPreferences.tenantLogoPath != null
                  ? UserPreferences.tenantLogoPath!
                  : '',
              width: screenWidth! / 4,
              height: screenWidth! / 4,
            )
          : Image.network(
              UserPreferences.tenantLogoPath!,
              height: screenWidth! / 5,
            );
    });
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }

    var compkey = UserPreferences.compKey;
    if (kDebugMode) {
      print('Value :::: Inside ::: ***** DB Provicder  $compkey');
    }
    TopVariable.apiService
        .getCustomerInverterAllowedSelection(compkey!)
        .then((value) {
      if (kDebugMode) {
        print('Value :::: Inside ::: ***** jjjkkklllll}');
        print('Value :::: Inside ::: ***** $value}');
        print('Value :::: Inside ::: ***** ${value['text']}');
      }
      UserPreferences.setAllowedSiteSelectionVal = value['text'];
      notifyListeners();
    });
  }

  // new
  getCustomerInverterSelectionExceedMsg(String count) async {
    CheckConnectivity.isConnected().then((value) {
      companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
          ? SvgPicture.network(
              UserPreferences.tenantLogoPath != null
                  ? UserPreferences.tenantLogoPath!
                  : '',
              width: screenWidth! / 4,
              height: screenWidth! / 4,
            )
          : Image.network(
              UserPreferences.tenantLogoPath!,
              height: screenWidth! / 5,
            );
    });
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }

    TopVariable.apiService
        .getCustomerInverterSelectionExceedMsg(count.toString())
        .then((value) {
      if (kDebugMode) {
        print('Value :::: Inside ::: ***** $value');
      }
    });
  }

  // new
  // => v2
  getCustomerInverterList() async {
    CheckConnectivity.isConnected().then((value) {
      companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
          ? SvgPicture.network(
              UserPreferences.tenantLogoPath != null
                  ? UserPreferences.tenantLogoPath!
                  : '',
              width: screenWidth! / 4,
              height: screenWidth! / 4,
            )
          : Image.network(
              UserPreferences.tenantLogoPath!,
              height: screenWidth! / 5,
            );
    });
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    allInverterModels = [];
    invertersList = [];
    customerSubscriptionsTilesList = [];
    customerSubscriptionsTilesListUserProfile = [];
    subscriptionsAPIData = [];
    customerInvertersData = [];
    notifyListeners();

    variantName = '';
    premiseNo = '';
    activeSince = '';
    inverterSubscriptionId = '';
    subName = '';
    inverterSubscriptionStatus = '';
    variantAlias = '';

    TopVariable.apiService.getCustomerInverterList().then((value) {
      customerInvertersData = value as List<dynamic>;
      if (customerInvertersData!.isNotEmpty) {
        subscriptionsAPIData = customerInvertersData;
        customerSubscriptions = customerInvertersData;
        for (int i = 0; i < customerSubscriptions!.length; i++) {
          variantName = customerSubscriptions![i]['variantName'].toString();
          variantAlias = customerSubscriptions![i]['variantAlias'].toString();
          inverterSubscriptionId = customerSubscriptions![i]['_id'].toString();
          if (kDebugMode) {
            print('variantName ::::::: ===== >>>> $variantName');
          }
          customerSubscriptionsTilesList.add(SubscriptionTile(
              subscriptionId: inverterSubscriptionId,
              subscriptionTemplete: '',
              subscriptionStatus: '',
              garden: variantName,
              variantAlias: variantAlias,
              premiseNo: '',
              activationDate: '',
              selected: selectedIds.contains(inverterSubscriptionId),
              inverterValue: inverterValue));
        }

        notifyListeners();
      }
    });
  }

  // v1
  // ignore: prefer_typing_uninitialized_variables
  Rx<WeatherSitesModel> weatherModel = WeatherSitesModel().obs;

  int selectedIndex = 0;
  RxBool isShowNoWeatherWidget = false.obs;
  RxString valueOFSelectedID = ''.obs;
  getWeatherOfSites(String selectedID) async {
    CheckConnectivity.isConnected().then((value) {
      companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
          ? SvgPicture.network(
              UserPreferences.tenantLogoPath != null
                  ? UserPreferences.tenantLogoPath!
                  : '',
              width: screenWidth! / 4,
              height: screenWidth! / 4,
            )
          : Image.network(
              UserPreferences.tenantLogoPath!,
              height: screenWidth! / 5,
            );
    });
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }

    notifyListeners();
    if (selectedIds.isNotEmpty) {
      // var id = selectedIds[index];
      TopVariable.apiService.getWeatherOfSites(selectedID).then((value) async {
        if (value.isEmpty == false) {
          weatherModel.value = WeatherSitesModel.fromJson(value);
          if (kDebugMode) {
            print('DDDD::::::::+++++++ >>>> ${weatherModel.value}');
          }
          isShowNoWeatherWidget.value = false;
          notifyListeners();
        } else {
          isShowNoWeatherWidget.value = true;
        }
      });
    } else {
      LocationData? _locationData;
      _locationData = await location.getLocation();
      await TopVariable.dashboardProvider.fetchWeatherData(
          _locationData.latitude!.toString(),
          _locationData.longitude!.toString(),
          'true');
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  dynamic weatherForeCastModel;
  RxBool isLoadingForeCast = false.obs;
  getWeatherForeCastOfSites(String selectedID, String noOfDays) async {
    CheckConnectivity.isConnected().then((value) {
      companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
          ? SvgPicture.network(
              UserPreferences.tenantLogoPath != null
                  ? UserPreferences.tenantLogoPath!
                  : '',
              width: screenWidth! / 4,
              height: screenWidth! / 4,
            )
          : Image.network(
              UserPreferences.tenantLogoPath!,
              height: screenWidth! / 5,
            );
    });
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    isLoadingForeCast.value = true;
    notifyListeners();

    var compkey = UserPreferences.compKey;
    var list = [selectedID, noOfDays, compkey];
    if (kDebugMode) {
      print('Value :::: Inside ::: ***** DB Provicder  $compkey');
      print('Value :::: Inside ::: ***** DB List  $list');
    }

    TopVariable.apiService.getWeatherFoerCastOfSites(list).then((value) async {
      isLoadingForeCast.value = false;
      notifyListeners();
      if (value.isEmpty == false) {
        if (kDebugMode) {
          print('DDDD::::::::11111+++++++ >>>> $value');
        }
        weatherForeCastModel = value;
        if (kDebugMode) {
          print('DDDD::::::::+++++++ >>>> ${weatherForeCastModel.length}');
          print('DDDD::::::::+++++++ >>>> ${weatherForeCastModel[0]['time']}');
          print(
              'DDDD::::::::+++++++ >>>> ${weatherForeCastModel[0]['temperature']}');
          print(
              'DDDD::::::::+++++++ >>>> ${weatherForeCastModel[0]['forecast']}');
          print(
              'DDDD::::::::+++++++ >>>> ${weatherForeCastModel[0]['tempDegree']}');
        }
        notifyListeners();
      } else {}
    });
  }

  String getNameOfSiteFromID(String id) {
    String name = '';
    for (int i = 0; i < customerSubscriptionsTilesList.length; i++) {
      if (customerSubscriptionsTilesList[i].subscriptionId == id) {
        name = customerSubscriptionsTilesList[i].garden;
      }
    }
    return name;
  }
  // v0
  // var weatherModel;
  // int selectedIndex = 0;
  // List<WeatherSitesModel> weahterModelList = [];
  // getWeatherOfSites(int index) async {
  //   CheckConnectivity.isConnected().then((value) {
  //     companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
  //         ? SvgPicture.network(
  //             UserPreferences.tenantLogoPath != null
  //                 ? UserPreferences.tenantLogoPath!
  //                 : '',
  //             width: screenWidth! / 4,
  //             height: screenWidth! / 4,
  //           )
  //         : Image.network(
  //             UserPreferences.tenantLogoPath!,
  //             height: screenWidth! / 5,
  //           );
  //   });
  //   bool _isInternetConnected = await BaseClientClass.isInternetConnected();
  //   if (!_isInternetConnected) {
  //     await Get.to(() => const NoInternetScreen());
  //     return;
  //   }

  //   if (selectedIds.value.isNotEmpty) {
  //     var id = selectedIds.value[index];
  //     TopVariable.apiService.getWeatherOfSites(id).then((value) async {
  //       weatherModel = value;
  //       if (kDebugMode) {
  //         print('Value     ::::#:::::: $value');
  //         print('weatherModel :::::#::::: $weatherModel');
  //         print('Condition ::::::#:::: ${(weatherModel == null)}');
  //         print('Condition ::::::#:::: ${(weatherModel)}');
  //         print(
  //             'Condition ::::1#:::::: ${(weatherModel == null && selectedIds.value.length < 2)}');
  //       }

  //       notifyListeners();
  //     });
  //   } else {
  //     LocationData? _locationData;
  //     _locationData = await location.getLocation();
  //     await TopVariable.dashboardProvider.fetchWeatherData(
  //         _locationData.latitude!.toString(),
  //         _locationData.longitude!.toString(),
  //         'true');
  //   }
  // }

  // // => v1
  // getCustomerInverterList() async {
  //   CheckConnectivity.isConnected().then((value) {
  //     companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
  //         ? SvgPicture.network(
  //             UserPreferences.tenantLogoPath != null
  //                 ? UserPreferences.tenantLogoPath!
  //                 : '',
  //             width: screenWidth! / 4,
  //             height: screenWidth! / 4,
  //           )
  //         : Image.network(
  //             UserPreferences.tenantLogoPath!,
  //             height: screenWidth! / 5,
  //           );
  //   });
  //   bool _isInternetConnected = await BaseClientClass.isInternetConnected();
  //   if (!_isInternetConnected) {
  //     await Get.to(() => const NoInternetScreen());
  //     return;
  //   }
  //   allInverterModels = [];
  //   invertersList = [];
  //   customerSubscriptionsTilesList = [];
  //   customerSubscriptionsTilesListUserProfile = [];
  //   subscriptionsAPIData = [];
  //   TopVariable.apiService.getCustomerInverterList().then((value) {
  //     // checking if value is not null then will call this
  //     if (value['message']
  //             .contains('No subscriptions exists for this userId = ') ==
  //         true) {
  //       return;
  //     }
  //     customerInvertersData = value['data'] as List<dynamic>;
  //     if (customerInvertersData!.isNotEmpty) {
  //       subscriptionsAPIData = customerInvertersData;
  //       customerSubscriptions = customerInvertersData;
  //       for (int i = 0; i < customerSubscriptions!.length; i++) {
  //         final inverterModel = InverterModel();
  //         premiseNo = customerSubscriptions![i]['premiseNo'].toString();
  //         variantName = customerSubscriptions![i]['variantName'].toString();
  //         activeSince = customerSubscriptions![i]['activeSince'].toString();
  //         inverterSubscriptionId =
  //             customerSubscriptions![i]['subId'].toString();
  //         inverterModel.subscriptionId = inverterSubscriptionId;
  //         subName = customerSubscriptions![i]['subName'].toString();
  //         inverterSubscriptionStatus =
  //             customerSubscriptions![i]['status'].toString();
  //         // String subscriptionTemplate =
  //         //     customerSubscriptions![i]['subscriptionTemplate'].toString();
  //         // inverterSubscriptionTemplate =
  //         //     customerSubscriptions![i]['subscriptionTemplate'];
  //         // subscriptionMappings =
  //         //     customerSubscriptions![i]['customerSubscriptionMappings'];
  //         // try {
  //         //   for (Map<String, dynamic> subscriptionMapping
  //         //       in subscriptionMappings!) {
  //         //     if (subscriptionMapping['rateCode'] == 'INVRT') {
  //         //       inverterValue = subscriptionMapping['value'];
  //         //     } else if (subscriptionMapping['rateCode'] == 'LAT') {
  //         //       inverterModel.lat = subscriptionMapping['value'];
  //         //     } else if (subscriptionMapping['rateCode'] == 'LON') {
  //         //       inverterModel.lng = subscriptionMapping['value'];
  //         //     } else if (subscriptionMapping['rateCode'] == 'SSDT') {
  //         //       inverterSubscriptionActivationDate =
  //         //           subscriptionMapping['value'].toString();
  //         //       inverterSubscriptionPremiseNo =
  //         //           subscriptionMapping['subscriptionRateMatrixId'].toString();
  //         //     }
  //         //   }
  //         // } catch (e) {
  //         //   if (kDebugMode) {
  //         //     print(e);
  //         //   }
  //         // }
  //         invertersList.add(
  //             "$inverterSubscriptionId | $inverterValue | $inverterSubscriptionTemplate");
  //         allInverterModels.add(inverterModel);
  //         customerSubscriptionsTilesListUserProfile.add(SubscriptionTile(
  //           subscriptionId: inverterSubscriptionId,
  //           subscriptionStatus: inverterSubscriptionStatus,
  //           garden: variantName,
  //           premiseNo: premiseNo,
  //           activationDate: activeSince,
  //         ));
  //         customerSubscriptionsTilesList.add(SubscriptionTile(
  //             subscriptionId: inverterSubscriptionId,
  //             subscriptionTemplete: 'template IC',
  //             subscriptionStatus: inverterSubscriptionStatus,
  //             garden: variantName,
  //             premiseNo: premiseNo,
  //             activationDate: activeSince,
  //             selected: selectedIds.value.contains(inverterSubscriptionId),
  //             inverterValue: inverterValue));
  //       }
  //       notifyListeners();
  //       //   String invertersData = value.toString();
  //       if (kDebugMode) {
  //         print(invertersList.toString());
  //       }
  //     }
  //   });
  // }

  // new
  // => v0
  // void getCustomerInverterList() async {
  //   CheckConnectivity.isConnected().then((value) {
  //     companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
  //         ? SvgPicture.network(
  //             UserPreferences.tenantLogoPath != null
  //                 ? UserPreferences.tenantLogoPath!
  //                 : '',
  //             width: screenWidth! / 4,
  //             height: screenWidth! / 4,
  //           )
  //         : Image.network(
  //             UserPreferences.tenantLogoPath!,
  //             height: screenWidth! / 5,
  //           );
  //   });
  //   bool _isInternetConnected = await BaseClientClass.isInternetConnected();
  //   if (!_isInternetConnected) {
  //     await Get.to(() => const NoInternetScreen());
  //     return;
  //   }
  //   allInverterModels = [];
  //   invertersList = [];
  //   customerSubscriptionsTilesList = [];
  //   TopVariable.apiService.getCustomerInverterList().then((value) {
  //     // checking if value is not null then will call this
  //     if (kDebugMode) {
  //       print('Value ::ACGCIList:: inside bracket => ${value['message']}');
  //     }
  //     if (value['message']
  //             .contains('No subscriptions exists for this userId = ') ==
  //         true) {
  //       return;
  //     }
  //     customerInvertersData = value as List<dynamic>;
  //     if (customerInvertersData!.isNotEmpty) {
  //       if (kDebugMode) {
  //         print('length:::::: of customerInvertersData');
  //         print(customerInvertersData!.length);
  //       }
  //       customerSubscriptions =
  //           customerInvertersData?[0]['customerSubscriptions'];
  //       for (int i = 0; i < customerSubscriptions!.length; i++) {
  //         // subscription = customerSubscriptions![i];
  //         final inverterModel = InverterModel();
  //         inverterSubscriptionId = customerSubscriptions![i]['id'].toString();
  //         inverterModel.subscriptionId = inverterSubscriptionId;
  //         inverterSubscriptionStatus =
  //             customerSubscriptions![i]['subscriptionStatus'].toString();
  //         String subscriptionTemplate =
  //             customerSubscriptions![i]['subscriptionTemplate'].toString();
  //         inverterSubscriptionTemplate =
  //             customerSubscriptions![i]['subscriptionTemplate'];
  //         subscriptionMappings =
  //             customerSubscriptions![i]['customerSubscriptionMappings'];
  //         try {
  //           for (Map<String, dynamic> subscriptionMapping
  //               in subscriptionMappings!) {
  //             if (subscriptionMapping['rateCode'] == 'INVRT') {
  //               inverterValue = subscriptionMapping['value'];
  //             } else if (subscriptionMapping['rateCode'] == 'LAT') {
  //               inverterModel.lat = subscriptionMapping['value'];
  //             } else if (subscriptionMapping['rateCode'] == 'LON') {
  //               inverterModel.lng = subscriptionMapping['value'];
  //             } else if (subscriptionMapping['rateCode'] == 'SSDT') {
  //               inverterSubscriptionActivationDate =
  //                   subscriptionMapping['value'].toString();
  //               inverterSubscriptionPremiseNo =
  //                   subscriptionMapping['subscriptionRateMatrixId'].toString();
  //             }
  //           }
  //         } catch (e) {
  //           if (kDebugMode) {
  //             print(e);
  //           }
  //         }
  //         invertersList.add(
  //             "$inverterSubscriptionId | $inverterValue | $inverterSubscriptionTemplate");
  //         allInverterModels.add(inverterModel);
  //         customerSubscriptionsTilesList.add(SubscriptionTile(
  //             subscriptionId: inverterSubscriptionId,
  //             subscriptionTemplete: subscriptionTemplate,
  //             subscriptionStatus: inverterSubscriptionStatus,
  //             garden: inverterSubscriptionTemplate,
  //             premiseNo: inverterSubscriptionPremiseNo,
  //             activationDate: inverterSubscriptionActivationDate,
  //             selected: selectedIds.value.contains(inverterSubscriptionId),
  //             inverterValue: inverterValue));
  //       }
  //       notifyListeners();
  //       //   String invertersData = value.toString();
  //       if (kDebugMode) {
  //         print(invertersList.toString());
  //       }
  //     }
  //   });
  // }

  Map<String, dynamic>? weatherData;
  Location location = Location();
  fetchWeatherData(String lat, String lng, String path) async {
    if (kDebugMode) {
      print('Gettting Weather Data :::::::: 1');
    }
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    if (await location.serviceEnabled() == false) {
      if (kDebugMode) {
        print('Requesting for Location ::::: 2');
      }
      await location.requestService();
    }
    if (kDebugMode) {
      print('Gettting Location Enable :::::::: 3');
    }
    http
        .get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=807c24a314025675a69818a77fc1469a'))
        .then((value) {
      if (kDebugMode) {
        print('APi Calling :::::::: 4');
      }
      if (inverterListReselected) {
        weatherCards = [];
        inverterListReselected = false;
      }
      if (kDebugMode) {
        print("Weather data is...\t${value.body.toString()}");
      }
      weatherData = json.decode(value.body);
      if (weatherData != null) {
        weatherCards.add(WeatherWidget(
          city: weatherData?['name'],
          country: weatherData?['sys']['country'],
          temp: weatherData?['main']['temp'],
          lat: lat,
          lng: lng,
          weatherIcon: weatherData?['weather'][0]['icon'],
        ));
      }
      notifyListeners();
      if (path == 'true') {
        getCustomerInverterList();
      }
    });
  }

  Future<void> fetchWeatherForecastData(String lat, String lng) async {
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    // CustomProgressDialog.showProDialog();
    // http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=807c24a314025675a69818a77fc1469a')).then((value){
    http
        .get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lng&exclude=hourly,minutely&appid=807c24a314025675a69818a77fc1469a'))
        .then((value) {
      weatherForecastModels = [];
      if (kDebugMode) {
        print(
            'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lng&exclude=hourly,minutely&appid=807c24a314025675a69818a77fc1469a');
      }
      if (kDebugMode) {
        print("Weather Forecast data is...\t${value.body.toString()}");
      }
      Map<String, dynamic> weatherData = json.decode(value.body);
      List<dynamic> allForecasts = weatherData['daily'];
      for (int i = 0; i < 5; i++) {
        Map<String, dynamic> weatherForecastOfADay = allForecasts[i];
        WeatherModel weatherModel = WeatherModel(
          temp: double.parse(
                  (weatherForecastOfADay['temp']['day'] - 273.15).toString())
              .toStringAsFixed(2),
          tempMin: double.parse(
                  (weatherForecastOfADay['temp']['min'] - 273.15).toString())
              .toStringAsFixed(2),
          tempMax: double.parse(
                  (weatherForecastOfADay['temp']['max'] - 273.15).toString())
              .toStringAsFixed(2),
          humidity: weatherForecastOfADay['humidity'].toString(),
          description: weatherForecastOfADay['weather'][0]['description'],
          dtTxt: DateFormat('EEE dd').format(
            DateTime.fromMillisecondsSinceEpoch(
                weatherForecastOfADay['dt'] * 1000),
          ),
        );
        // print(weatherModel.toString());
        weatherForecastModels.add(weatherModel);
      }
      //weatherCards.add(WeatherWidget(city:weatherData['name'],country: weatherData['sys']['country'], temp: weatherData['main']['temp'],));
      notifyListeners();
      //CustomProgressDialog.hideProDialog();
    });
  }

  onInverterSelection(List<String> selectedInvertersList) async {
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    if (selectedInvertersList.isEmpty) {
      resetAppData();
    } else {
      inverterListReselected = true;
      for (String inverter in selectedInvertersList) {
        final splitted = inverter.split(' | ');
        selectedIds.add(splitted[0]);
        for (final inverter in allInverterModels) {
          if (inverter.subscriptionId == splitted[0]) {
            fetchWeatherData(inverter.lat, inverter.lng, 'true');
          }
        }
      }
      // await loadWidgets(selectedIds.value);
      await loadGraphData(selectedIds);
    }
  }

  onDateSelected(DateTime selectedDateFromPicker) async {
    selectedDate = selectedDateFromPicker;
    // notifyListeners();
    if (selectedIds.isNotEmpty) {
      // await loadWidgets(selectedIds.value);
      await loadGraphData(selectedIds);
    } else {
      ScaffoldMessenger.of(appNavigationKey.currentContext!).showSnackBar(
          const SnackBar(
              content: Text('Please select an inverter first\n\n\n')));
    }
  }

  loadUYieldWidgets(List<String> selectedIds) async {
    final Map<String, dynamic> requestBody = {
      "variantIds": selectedIds,
    };
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    TopVariable.apiService
        .getDashboardYieldWidgets(requestBody)
        .then((response) {
      if (kDebugMode) {
        print('getDashboardYieldWidgets: $requestBody');
        print('response: $response');
      }
      mappedResponseYield = response as Map<String, dynamic>;

      currentPowerValueToday =
          mappedResponseYield!['data']['currentValue'].toString();
      notifyListeners();
    });
  }

  loadTreePlantedWidgets(List<String> selectedIds) async {
    final Map<String, dynamic> requestBody = {
      "variantIds": selectedIds,
    };
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    TopVariable.apiService
        .getDashboardTreeFactorWidgets(requestBody)
        .then((response) {
      if (kDebugMode) {
        print('getDashboardTreeFactorWidgets: $requestBody');
        print('getDashboardTreeFactorWidgets Response: $response');
      }
      mappedResponseTreePlanted = response as Map<String, dynamic>;

      notifyListeners();
    });
  }
  // loadWidgets(List<String> selectedIds.value) async {
  //   final Map<String, dynamic> requestBody = {
  //     "subscriptionIds": selectedIds.value,
  //     "time": null,
  //     "isComparison": false,
  //     "isSubscriptionComparison": true,
  //     "userName": "Dieepa2020",
  //     "userPass": "Solar~123+",
  //     "token": "Bearer " + UserPreferences.token!,
  //   };
  //   bool _isInternetConnected = await BaseClientClass.isInternetConnected();
  //   if (!_isInternetConnected) {
  //     await Get.to(() => const NoInternetScreen());
  //     return;
  //   }
  //   TopVariable.apiService.getDashboardWidgets(requestBody).then((response) {
  //     if (kDebugMode) {
  //       print('getDashboardWidgets: $requestBody');
  //     }
  //     mappedResponse = response as Map<String, dynamic>;
  //     currentPowerValueToday = mappedResponse!['currentValue'].toString();
  //     dashboardSmallWidgets = [
  //       DashboardSmallWidget(
  //           title: 'DAILY YEILD',
  //           unit: 'kWh',
  //           value: mappedResponse!['dailyYield'].toString(),
  //           imagePath: 'assets/ic_graph_points.png'),
  //       DashboardSmallWidget(
  //           title: 'PEAK VALUE TODAY',
  //           unit: 'Watts',
  //           value: mappedResponse!['peakValue'].toString(),
  //           imagePath: 'assets/ic_peak.png'),
  //       DashboardSmallWidget(
  //           title: 'MONTH TO DATE YEILD',
  //           unit: 'kWh',
  //           value: mappedResponse!['monthlyYield'].toString(),
  //           imagePath: 'assets/ic_graph_points.png'),
  //       DashboardSmallWidget(
  //           title: 'YEAR TO DATE YEILD',
  //           unit: 'kWh',
  //           value: mappedResponse!['annualYield'].toString(),
  //           imagePath: 'assets/ic_graph_points.png'),
  //       DashboardSmallWidget(
  //           title: 'TOTAL YEILD',
  //           unit: 'kWh',
  //           value: mappedResponse!['grossYield'].toString(),
  //           imagePath: 'assets/ic_peak.png'),
  //       DashboardSmallWidget(
  //           title: 'SYSTEM SIZE',
  //           unit: 'kV',
  //           value: mappedResponse!['sytemSize'].toString(),
  //           imagePath: 'assets/ic_solar_size.png')
  //     ];
  //     dashboardBigWidgets = [
  //       DashboardBigWidgets(
  //         title: 'CO\u2082 REDUCTION',
  //         imagePath: 'assets/ic_co2_reduction.svg',
  //         value: mappedResponse!['co2Reduction'].toString(),
  //         background: const Color.fromRGBO(84, 95, 122, 1),
  //         valueColor: appTheme.colorScheme.secondary,
  //         descriptionColor: Colors.white,
  //       ),
  //       DashboardBigWidgets(
  //         title: 'TREES PLANTED FACTOR',
  //         imagePath: 'assets/ic_tree.svg',
  //         value: mappedResponse!['treesPlanted'].toString(),
  //         background: const Color.fromRGBO(44, 201, 130, 0.25),
  //         valueColor: const Color.fromRGBO(0, 186, 102, 1),
  //         descriptionColor: const Color.fromRGBO(46, 56, 80, 1),
  //       ),
  //     ];
  //     notifyListeners();
  //   });
  // }

  onGraphTimeChanged(String graphTimeSelected) {
    switch (graphTimeSelected) {
      case 'Daily':
        graphTime = GraphTime.daily;
        selectedIdsForGraph.isNotEmpty
            ? loadGraphData(selectedIdsForGraph)
            : loadGraphData(selectedIds);
        break;
      case 'Monthly':
        graphTime = GraphTime.monthly;
        selectedIdsForGraph.isNotEmpty
            ? loadGraphData(selectedIdsForGraph)
            : loadGraphData(selectedIds);
        break;
      case 'Yearly':
        graphTime = GraphTime.yearly;
        selectedIdsForGraph.isNotEmpty
            ? loadGraphData(selectedIdsForGraph)
            : loadGraphData(selectedIds);
        break;
    }
  }

  onGraphTypeChanged(String graphTypeSelected) {
    switch (graphTypeSelected) {
      case 'Cumulative':
        graphTypeDropdown = GraphType.cumulative;
        selectedIdsForGraph.isNotEmpty
            ? loadGraphData(selectedIdsForGraph)
            : loadGraphData(selectedIds);
        break;
      case 'Comparative':
        graphTypeDropdown = GraphType.comparative;
        selectedIdsForGraph.isNotEmpty
            ? loadGraphData(selectedIdsForGraph)
            : loadGraphData(selectedIds);
        break;
    }
  }

  loadGraphData(List<String> slectedIDParamete) async {
    switch (graphTypeDropdown) {
      // Cumulative Graph
      case GraphType.cumulative:
        final Map<String, dynamic> queryParams = {
          "isSubscriptionComparison": true,
          "isComparison": false,
        };
        switch (graphTime) {
          ////////////////////
          /// Daily
          ////////////////////
          case GraphTime.daily:
            // final Map<String, dynamic> requestBody = {
            //   "subscriptionIds": selectedIds.value,
            //   "time": DateFormat('yyyy-MM-dd hh:mm:ss').format(selectedDate),
            //   "isComparison": false,
            //   "isSubscriptionComparison": true
            // };
            var currentDateTime = DateTime.now();
            if (kDebugMode) {
              print('Time :::::: $currentDateTime');
              print(
                  'Time :::daily::: ${currentDateTime.year}-${currentDateTime.month}}');
            }
            final Map<String, dynamic> requestBody = {
              "yearMonth":
                  '${currentDateTime.year}-${currentDateTime.month}', //"2023-06",
              "variantIds": slectedIDParamete
            };
            if (kDebugMode) {
              print('Daily graph Data ::: $requestBody');
            }
            bool _isInternetConnected =
                await BaseClientClass.isInternetConnected();
            if (!_isInternetConnected) {
              await Get.to(() => const NoInternetScreen());
              return;
            }
            TopVariable.apiService
                .getDailyGraphDataCommulative(queryParams, requestBody)
                .then((response) {
              Map<String, dynamic> mappedResponse =
                  response as Map<String, dynamic>;
              List<dynamic> graphDataList = [];
              graphDataList = mappedResponse['graphData']['-1'] == null ||
                      mappedResponse['graphData']['-1'] == Null
                  ? ['0', '0', '0']
                  : mappedResponse['graphData']['-1'] as List<dynamic>;
              // List<dynamic> graphDataList =
              //     mappedResponse['graphData']['-1'] as List<dynamic>;
              syncfusionPowerData = [];
              syncfusionXAxis = [];
              List<double> syncFusionSingleSeries = [];
              for (Map<String, dynamic> yeildDataObject in graphDataList) {
                syncFusionSingleSeries.add(yeildDataObject['yieldValue']);
              }
              syncfusionPowerData.add(SyncfusionPowerDataSeriesModel(
                syncFusionSingleSeries,
                'Cumulative',
              ));
              List<dynamic> allTimes = mappedResponse['xaxis'];
              int i = 0;
              for (String timeLabel in allTimes) {
                if (i < 24) {
                  syncfusionXAxis.add('$timeLabel am');
                } else {
                  syncfusionXAxis.add('$timeLabel pm');
                }
                i++;
              }
              dailyGraph = true;
              notifyListeners();
            });
            break;
          ////////////////////
          /// Monthly
          ////////////////////
          case GraphTime.monthly:
            var currentDateTime = DateTime.now();

            if (kDebugMode) {
              print('Time :::::: $currentDateTime');
              print('Time :::monthly:::  ${currentDateTime.year}}');
            }
            final Map<String, dynamic> requestBody = {
              "startYear": currentDateTime.year,
              "variantIds": slectedIDParamete
            };
            bool _isInternetConnected =
                await BaseClientClass.isInternetConnected();
            if (!_isInternetConnected) {
              await Get.to(() => const NoInternetScreen());
              return;
            }
            TopVariable.apiService
                .getMonthlyGraphDataCommulative(queryParams, requestBody)
                .then((response) {
              Map<String, dynamic> mappedResponse =
                  response as Map<String, dynamic>;
              List<dynamic> graphDataList =
                  mappedResponse['graphData']['-1'] as List<dynamic>;
              syncfusionPowerData = [];
              syncfusionXAxis = [];
              List<double> syncFusionSingleSeries = [];
              for (Map<String, dynamic> yeildDataObject in graphDataList) {
                syncFusionSingleSeries.add(yeildDataObject['yieldValue']);
              }
              syncfusionPowerData.add(SyncfusionPowerDataSeriesModel(
                syncFusionSingleSeries,
                'Cumulative',
              ));
              List<dynamic> allTimes = mappedResponse['xaxis'];
              // ignore: unused_local_variable
              int i = 0;
              for (String timeLabel in allTimes) {
                syncfusionXAxis.add(timeLabel);
                /*if(i<24){
                    syncfusionXAxis.add('$timeLabel am');
                  } else{
                    syncfusionXAxis.add('$timeLabel pm');
                  }
                  i++;*/
              }
              dailyGraph = false;
              notifyListeners();
            });
            break;
          // ////////////////////
          // /// Yearly
          // ////////////////////
          case GraphTime.yearly:
            var currentDateTime = DateTime.now();
            if (kDebugMode) {
              print('Time :::::: $currentDateTime');
              print('Time :::yearly:::  ${currentDateTime.year}}');
            }
            final Map<String, dynamic> requestBody = {
              "startYear": currentDateTime.year,
              "endYear": currentDateTime.year,
              "variantIds": slectedIDParamete
            };
            bool _isInternetConnected =
                await BaseClientClass.isInternetConnected();
            if (!_isInternetConnected) {
              await Get.to(() => const NoInternetScreen());
              return;
            }
            TopVariable.apiService
                .getYearlyGraphDataCommulative(queryParams, requestBody)
                .then((response) {
              Map<String, dynamic> mappedResponse =
                  response as Map<String, dynamic>;
              List<dynamic> graphDataList =
                  mappedResponse['graphData']['-1'] as List<dynamic>;
              syncfusionPowerData = [];
              syncfusionXAxis = [];
              List<double> syncFusionSingleSeries = [];
              for (Map<String, dynamic> yeildDataObject in graphDataList) {
                syncFusionSingleSeries.add(yeildDataObject['yieldValue']);
              }
              syncfusionPowerData.add(SyncfusionPowerDataSeriesModel(
                syncFusionSingleSeries,
                'Cumulative',
              ));
              List<dynamic> allTimes = mappedResponse['xaxis'];
              // ignore: unused_local_variable
              int i = 0;
              for (String timeLabel in allTimes) {
                syncfusionXAxis.add(timeLabel);
                /*if(i<24){
                    syncfusionXAxis.add('$timeLabel am');
                  } else{
                    syncfusionXAxis.add('$timeLabel pm');
                  }
                  i++;*/
              }
              dailyGraph = false;
              notifyListeners();
            });

            break;
        }
        break;
      // Comparative Graph
      case GraphType.comparative:
        final Map<String, dynamic> queryParams = {
          "isSubscriptionComparison": true,
          "isComparison": true,
        };
        switch (graphTime) {
          ////////////////////
          /// Daily
          ////////////////////
          case GraphTime.daily:
            var currentDateTime = DateTime.now();
            if (kDebugMode) {
              print('Time :::::: $currentDateTime');
              print(
                  'Time :::daily::: ${currentDateTime.year}-${currentDateTime.month}}');
            }
            final Map<String, dynamic> requestBody = {
              "yearMonth":
                  '${currentDateTime.year}-${currentDateTime.month}', //"2023-06",
              "variantIds": slectedIDParamete
            };
            if (kDebugMode) {
              print('Daily graph Data ::: $requestBody');
            }

            bool _isInternetConnected =
                await BaseClientClass.isInternetConnected();
            if (!_isInternetConnected) {
              await Get.to(() => const NoInternetScreen());
              return;
            }
            TopVariable.apiService
                .getDailyGraphDataComparative(queryParams, requestBody)
                .then((response) {
              Map<String, dynamic> mappedResponse =
                  response as Map<String, dynamic>;
              Map<String, dynamic> graphDataInvertersObject =
                  mappedResponse['graphData'] as Map<String, dynamic>;
              syncfusionPowerData = [];
              syncfusionXAxis = [];
              graphDataInvertersObject
                  .forEach((inverterSubscriptionId, graphDataList) {
                List<double> syncFusionSingleSeries = [];
                for (Map<String, dynamic> yeildDataObject in graphDataList) {
                  syncFusionSingleSeries.add(yeildDataObject['yieldValue']);
                }
                syncfusionPowerData.add(SyncfusionPowerDataSeriesModel(
                  syncFusionSingleSeries,
                  inverterSubscriptionId,
                ));
              });
              List<dynamic> allTimes = mappedResponse['xaxis'];
              int i = 0;
              for (String timeLabel in allTimes) {
                // syncfusionXAxis.add(timeLabel);
                if (i < 24) {
                  syncfusionXAxis.add('$timeLabel am');
                } else {
                  syncfusionXAxis.add('$timeLabel pm');
                }
                i++;
              }
              dailyGraph = true;
              notifyListeners();
            });
            break;
          ////////////////////
          /// Monthly
          ////////////////////
          case GraphTime.monthly:
            var currentDateTime = DateTime.now();

            if (kDebugMode) {
              print('Time :::::: $currentDateTime');
              print('Time :::monthly:::  ${currentDateTime.year}}');
            }
            final Map<String, dynamic> requestBody = {
              "startYear": currentDateTime.year,
              "variantIds": slectedIDParamete
            };
            bool _isInternetConnected =
                await BaseClientClass.isInternetConnected();
            if (!_isInternetConnected) {
              await Get.to(() => const NoInternetScreen());
              return;
            }
            TopVariable.apiService
                .getMonthlyGraphDataComparative(queryParams, requestBody)
                .then((response) {
              Map<String, dynamic> mappedResponse =
                  response as Map<String, dynamic>;
              Map<String, dynamic> graphDataInvertersObject =
                  mappedResponse['graphData'] as Map<String, dynamic>;
              syncfusionPowerData = [];
              syncfusionXAxis = [];
              graphDataInvertersObject
                  .forEach((inverterSubscriptionId, graphDataList) {
                List<double> syncFusionSingleSeries = [];
                for (Map<String, dynamic> yeildDataObject in graphDataList) {
                  syncFusionSingleSeries.add(yeildDataObject['yieldValue']);
                }
                syncfusionPowerData.add(SyncfusionPowerDataSeriesModel(
                  syncFusionSingleSeries,
                  inverterSubscriptionId,
                ));
              });
              List<dynamic> allTimes = mappedResponse['xaxis'];
              // ignore: unused_local_variable
              int i = 0;
              for (String timeLabel in allTimes) {
                syncfusionXAxis.add(timeLabel);
                /*if(i<24){
                  syncfusionXAxis.add('$timeLabel am');
                } else{
                  syncfusionXAxis.add('$timeLabel pm');
                }
                i++;*/
              }
              dailyGraph = false;
              notifyListeners();
            });

            break;
          ////////////////////
          /// Yearly
          ////////////////////
          case GraphTime.yearly:
            // final Map<String, dynamic> requestBody = {
            //   "subscriptionIds": selectedIds.value,
            //   "time": int.parse(DateFormat('yyyy').format(selectedDate)),
            //   "isComparison": false,
            //   "isSubscriptionComparison": true
            // };

            var currentDateTime = DateTime.now();
            if (kDebugMode) {
              print('Time :::::: $currentDateTime');
              print('Time :::yearly:::  ${currentDateTime.year}}');
            }
            final Map<String, dynamic> requestBody = {
              "startYear": currentDateTime.year,
              "endYear": currentDateTime.year,
              "variantIds": slectedIDParamete
            };
            bool _isInternetConnected =
                await BaseClientClass.isInternetConnected();
            if (!_isInternetConnected) {
              await Get.to(() => const NoInternetScreen());
              return;
            }
            TopVariable.apiService
                .getYearlyGraphDataComparative(queryParams, requestBody)
                .then((response) {
              Map<String, dynamic> mappedResponse =
                  response as Map<String, dynamic>;
              Map<String, dynamic> graphDataInvertersObject =
                  mappedResponse['graphData'] as Map<String, dynamic>;
              syncfusionPowerData = [];
              syncfusionXAxis = [];
              graphDataInvertersObject
                  .forEach((inverterSubscriptionId, graphDataList) {
                List<double> syncFusionSingleSeries = [];
                for (Map<String, dynamic> yeildDataObject in graphDataList) {
                  syncFusionSingleSeries.add(yeildDataObject['yieldValue']);
                }
                syncfusionPowerData.add(SyncfusionPowerDataSeriesModel(
                    syncFusionSingleSeries, inverterSubscriptionId));
              });
              List<dynamic> allTimes = mappedResponse['xaxis'];
              // ignore: unused_local_variable
              int i = 0;
              for (String timeLabel in allTimes) {
                syncfusionXAxis.add(timeLabel);
                /*if(i<24){
                  syncfusionXAxis.add('$timeLabel am');
                } else{
                  syncfusionXAxis.add('$timeLabel pm');
                }
                i++;*/
              }
              dailyGraph = false;
              notifyListeners();
            });

            break;
        }
        break;
    }
  }

  resetAppData() {
    // TopVariable.generalProvider.profilePicture = null;
    //TopVariable.dashboardProvider.invertersList = [];
    allInverterModels.clear();
    TopVariable.dashboardProvider.inverterSubscriptionId = '';
    TopVariable.dashboardProvider.inverterSubscriptionTemplate = '';
    TopVariable.dashboardProvider.inverterValue = '';
    TopVariable.dashboardProvider.inverterLat = 0.0;
    TopVariable.dashboardProvider.inverterLong = 0.0;
 

    //TopVariable.dashboardProvider.allInverterModels = [];
    TopVariable.dashboardProvider.weatherCards = [];
    TopVariable.dashboardProvider.weatherForecastModels = [
      WeatherModel(),
      WeatherModel(),
      WeatherModel(),
      WeatherModel(),
      WeatherModel(),
    ];
    TopVariable.dashboardProvider.dashboardSmallWidgets = [
      const DashboardSmallWidget(
          title: 'DAILY YEILD',
          unit: 'kWh',
          value: '0',
          imagePath: 'assets/ic_graph_points.png'),
      const DashboardSmallWidget(
          title: 'PEAK VALUE TODAY',
          unit: 'Watts',
          value: '0',
          imagePath: 'assets/ic_peak.png'),
      const DashboardSmallWidget(
          title: 'MONTH TO DATE YEILD',
          unit: 'kWh',
          value: '0',
          imagePath: 'assets/ic_graph_points.png'),
      const DashboardSmallWidget(
          title: 'YEAR TO DATE YEILD',
          unit: 'kWh',
          value: '0',
          imagePath: 'assets/ic_graph_points.png'),
      const DashboardSmallWidget(
          title: 'TOTAL YEILD',
          unit: 'kWh',
          value: '0',
          imagePath: 'assets/ic_peak.png'),
      const DashboardSmallWidget(
          title: 'SYSTEM SIZE',
          unit: 'kV',
          value: '0',
          imagePath: 'assets/ic_solar_size.png')
    ];
    TopVariable.dashboardProvider.dashboardBigWidgets = [
      DashboardBigWidgets(
        title: 'CO\u2082 REDUCTION',
        imagePath: 'assets/ic_co2_reduction.svg',
        value: '0',
        background: const Color.fromRGBO(84, 95, 122, 1),
        valueColor: appTheme.colorScheme.secondary,
        descriptionColor: Colors.white,
      ),
      const DashboardBigWidgets(
        title: 'TREES PLANTED FACTOR',
        imagePath: 'assets/ic_tree.svg',
        value: '0',
        background: Color.fromRGBO(44, 201, 130, 0.25),
        valueColor: Color.fromRGBO(0, 186, 102, 1),
        descriptionColor: Color.fromRGBO(46, 56, 80, 1),
      ),
    ];
    TopVariable.dashboardProvider.inverterListReselected = false;

    TopVariable.dashboardProvider.graphData = [
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
      // """0.0""",
    ];

    TopVariable.dashboardProvider.graphTime = GraphTime.daily;
    TopVariable.dashboardProvider.graphTypeDropdown = GraphType.cumulative;

    TopVariable.dashboardProvider.graphXAxis = StringBuffer(
        '["12:00","12:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30"]');
    TopVariable.dashboardProvider.syncfusionXAxis = [
      // "12:00",
      // "12:30",
      // "01:00",
      // "01:30",
      // "02:00",
      // "02:30",
      // "03:00",
      // "03:30",
      // "04:00",
      // "04:30",
      // "05:00",
      // "05:30",
      // "06:00",
      // "06:30",
      // "07:00",
      // "07:30",
      // "08:00",
      // "08:30",
      // "09:00",
      // "09:30",
      // "10:00",
      // "10:30",
      // "11:00",
      // "11:30",
      // "12:00",
      // "12:30",
      // "01:00",
      // "01:30",
      // "02:00",
      // "02:30",
      // "03:00",
      // "03:30",
      // "04:00",
      // "04:30",
      // "05:00",
      // "05:30",
      // "06:00",
      // "06:30",
      // "07:00",
      // "07:30",
      // "08:00",
      // "08:30",
      // "09:00",
      // "09:30",
      // "10:00",
      // "10:30",
      // "11:00",
      // "11:30"
    ];
    TopVariable.dashboardProvider.dailyGraph = true;
    TopVariable.dashboardProvider.syncfusionPowerData = [
      SyncfusionPowerDataSeriesModel([
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0,
        // 0
      ], 'Cumulative')
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      TopVariable.dashboardProvider.selectedIds.value = [];
      TopVariable.dashboardProvider.selectedDate =
          DateTime.now().subtract(const Duration(days: 1));
      notifyListeners();
    });
  }
}

class InverterModel {
  String subscriptionId;
  String lat;
  String lng;
  InverterModel({this.subscriptionId = '', this.lat = '', this.lng = ''});
}

enum GraphTime { daily, monthly, yearly }

enum GraphType { cumulative, comparative }


// before graph update
// // ignore_for_file: unnecessary_string_escapes

// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:location/location.dart';
// import 'package:solaramps/dataModel/weather_model.dart';
// import 'package:solaramps/helper_/base_client.dart';
// import 'package:solaramps/model_/weather_sites_model.dart';
// import 'package:solaramps/shared/const/no_internet_screen.dart';
// import 'package:solaramps/utility/internet_connectivity.dart';
// import 'package:solaramps/utility/top_level_variables.dart';
// import 'package:http/http.dart' as http;
// import 'package:solaramps/widget/dashboard_big_widgets.dart';
// import 'package:solaramps/widget/dashboard_small_widget.dart';
// import 'package:solaramps/widget/subscription_tile_widget.dart';
// import 'package:solaramps/widget/weather_widget.dart';
// import '../utility/shared_preference.dart';
// import '../widget/production_graph_syncfusion.dart';

// class DashboardProvider extends ChangeNotifier {
//   List<dynamic>? customerInvertersData;
//   List<dynamic>? customerSubscriptions;
//   Map<String, dynamic>? subscription;
//   List<dynamic>? subscriptionMappings;
//   List<String> invertersList = [];
//   Map<String, dynamic>? mappedResponse;
//   Map<String, dynamic>? mappedResponseYield;
//   Map<String, dynamic>? mappedResponseTreePlanted;
//   // Inverters
//   String premiseNo = '';
//   String variantName = '';
//   String variantAlias = '';
//   String subName = '';
//   String activeSince = '';
//   String inverterSubscriptionId = '';
//   String inverterSubscriptionTemplate = '';
//   String inverterValue = '';
//   double inverterLat = 0.0;
//   double inverterLong = 0.0;
//   List<InverterModel> allInverterModels = [];
//   // Inverter End
//   List<Widget> weatherCards = [];
//   String currentPowerValueToday = '0.0';
//   List<WeatherModel> weatherForecastModels = [
//     WeatherModel(),
//     WeatherModel(),
//     WeatherModel(),
//     WeatherModel(),
//     WeatherModel(),
//   ];
//   List<Widget> dashboardSmallWidgets = const [
//     DashboardSmallWidget(
//         title: 'DAILY YEILD',
//         unit: 'kWh',
//         value: '0',
//         imagePath: 'assets/ic_graph_points.png'),
//     DashboardSmallWidget(
//         title: 'PEAK VALUE TODAY',
//         unit: 'Watts',
//         value: '0',
//         imagePath: 'assets/ic_peak.png'),
//     DashboardSmallWidget(
//         title: 'MONTH TO DATE YEILD',
//         unit: 'kWh',
//         value: '0',
//         imagePath: 'assets/ic_graph_points.png'),
//     DashboardSmallWidget(
//         title: 'YEAR TO DATE YEILD',
//         unit: 'kWh',
//         value: '0',
//         imagePath: 'assets/ic_graph_points.png'),
//     DashboardSmallWidget(
//         title: 'TOTAL YEILD',
//         unit: 'kWh',
//         value: '0',
//         imagePath: 'assets/ic_peak.png'),
//     DashboardSmallWidget(
//         title: 'SYSTEM SIZE',
//         unit: 'kV',
//         value: '0',
//         imagePath: 'assets/ic_solar_size.png')
//   ];
//   List<Widget> dashboardBigWidgets = [
//     DashboardBigWidgets(
//       title: 'CO\u2082 REDUCTION',
//       imagePath: 'assets/ic_co2_reduction.svg',
//       value: '0',
//       background: const Color.fromRGBO(84, 95, 122, 1),
//       valueColor: appTheme.colorScheme.secondary,
//       descriptionColor: Colors.white,
//     ),
//     const DashboardBigWidgets(
//       title: 'TREES PLANTED FACTOR',
//       imagePath: 'assets/ic_tree.svg',
//       value: '0',
//       background: Color.fromRGBO(44, 201, 130, 0.25),
//       valueColor: Color.fromRGBO(0, 186, 102, 1),
//       descriptionColor: Color.fromRGBO(46, 56, 80, 1),
//     ),
//   ];
//   bool inverterListReselected = false;

//   checkInverter(int index, bool selected) {
//     SubscriptionTile item = customerSubscriptionsTilesList[index];
//     (item).selected = selected;
//     if (selected) {
//       selectedIds.add(item.subscriptionId);
//     } else {
//       selectedIds.remove(item.subscriptionId);
//     }

//     notifyListeners();
//   }

//   List weatherModelList = [];
//   getInverterData() async {
//     if (selectedIds.isNotEmpty) {
//       if (kDebugMode) {
//         print('Selected IDS :::::: $selectedIds.value');
//       }
//       loadUYieldWidgets(selectedIds);
//       loadTreePlantedWidgets(selectedIds);
//       loadGraphData();
//       if (selectedIds.isNotEmpty) {
//         await TopVariable.dashboardProvider
//             .getWeatherOfSites(selectedIds.first);
//       }

//       notifyListeners();
//     } else {
//       mappedResponseYield = null;
//       mappedResponseTreePlanted = null;
//       mappedResponse = Map.from({
//         "sytemSize": 0,
//         "currentValue": 0.0,
//         "peakValue": 0.0,
//         "dailyYield": 0,
//         "monthlyYield": 0.0,
//         "annualYield": 0,
//         "grossYield": 0,
//         "treesPlanted": 0,
//         "co2Reduction": 0
//       });
//     }
//   }

//   List<SubscriptionTile> customerSubscriptionsTilesList = [
//     // SubscriptionTile(
//     //   subscriptionId: '1003',
//     //   subscriptionStatus: 'ACTIVE',
//     // ),
//     // SubscriptionTile(
//     //   subscriptionId: '1004',
//     //   subscriptionStatus: 'ACTIVE',
//     // ),
//     // SubscriptionTile(
//     //   subscriptionId: '1005',
//     //   subscriptionStatus: 'ACTIVE',
//     // ),
//     // SubscriptionTile(
//     //   subscriptionId: '1006',
//     //   subscriptionStatus: 'INACTIVE',
//     // ),
//   ];
//   List<SubscriptionTile> customerSubscriptionsTilesListUserProfile = [];
//   List<dynamic>? subscriptionsAPIData;

//   List<String> graphData = [
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//     // """0.0""",
//   ];

//   GraphTime graphTime = GraphTime.daily;
//   GraphType graphTypeDropdown = GraphType.cumulative;

//   StringBuffer graphXAxis = StringBuffer(
//       '["12:00","12:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30"]');
//   List<String> syncfusionXAxis = [
//     // "12:00",
//     // "12:30",
//     // "01:00",
//     // "01:30",
//     // "02:00",
//     // "02:30",
//     // "03:00",
//     // "03:30",
//     // "04:00",
//     // "04:30",
//     // "05:00",
//     // "05:30",
//     // "06:00",
//     // "06:30",
//     // "07:00",
//     // "07:30",
//     // "08:00",
//     // "08:30",
//     // "09:00",
//     // "09:30",
//     // "10:00",
//     // "10:30",
//     // "11:00",
//     // "11:30",
//     // "12:00",
//     // "12:30",
//     // "01:00",
//     // "01:30",
//     // "02:00",
//     // "02:30",
//     // "03:00",
//     // "03:30",
//     // "04:00",
//     // "04:30",
//     // "05:00",
//     // "05:30",
//     // "06:00",
//     // "06:30",
//     // "07:00",
//     // "07:30",
//     // "08:00",
//     // "08:30",
//     // "09:00",
//     // "09:30",
//     // "10:00",
//     // "10:30",
//     // "11:00",
//     // "11:30"
//   ];
//   bool dailyGraph = true;
//   List<SyncfusionPowerDataSeriesModel> syncfusionPowerData = [
//     SyncfusionPowerDataSeriesModel([], 'Cumulative',)
//   ];
//   StringBuffer allGraphSeries = StringBuffer(
//       '[{data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }]');
//   String graphType = '\"spline\"';
//   // String graphType = '\"spline\"';
//   final String dataSeriesAttributes = ''',''';
//   RxList<String> selectedIds = [''].obs;
//   RxList<String> selectedIdsForGraph = [''].obs;

//   DateTime selectedDate = DateTime.now().subtract(const Duration(days: 1));
//   String? companyLogoPath = UserPreferences.tenantLogoPath;
//   Widget companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
//       ? SvgPicture.network(
//           UserPreferences.tenantLogoPath != null
//               ? UserPreferences.tenantLogoPath!
//               : '',
//           width: 100,
//           height: screenHeight! / 5,
//           fit: BoxFit.cover,
//         )
//       : Image.network(
//           UserPreferences.tenantLogoPath!,
//           height: 100,
//           fit: BoxFit.cover,
//         );

//   String inverterSubscriptionStatus = '';
//   String inverterSubscriptionPremiseNo = '';
//   String inverterSubscriptionActivationDate = '';

//   searchSubscriptions(String searchText) {
//     customerSubscriptionsTilesListUserProfile.clear();
//     subscriptionsAPIData?.forEach((subscription) {
//       if (subscription['variantName']
//           .toString()
//           .contains(searchText.toString())) {
//         customerSubscriptionsTilesListUserProfile.add(SubscriptionTile(
//           premiseNo: subscription['premiseNo'].toString(),
//           subscriptionId: subscription['subId'].toString(),
//           subscriptionStatus: subscription["status"].toString(),
//           garden: subscription["variantName"].toString(),
//           activationDate: subscription["activeSince"].toString(),
//         ));
//       }
//     });
//     notifyListeners();
//   }

//   // new
//   getCustomerSubscriptions() async {
//     CheckConnectivity.isConnected().then((value) {
//       companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
//           ? SvgPicture.network(
//               UserPreferences.tenantLogoPath != null
//                   ? UserPreferences.tenantLogoPath!
//                   : '',
//               width: screenWidth! / 4,
//               height: screenWidth! / 4,
//             )
//           : Image.network(
//               UserPreferences.tenantLogoPath!,
//               height: screenWidth! / 5,
//             );
//     });
//     bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//     if (!_isInternetConnected) {
//       await Get.to(() => const NoInternetScreen());
//       return;
//     }
//     allInverterModels = [];
//     invertersList = [];
//     customerSubscriptionsTilesList = [];
//     customerSubscriptionsTilesListUserProfile = [];
//     subscriptionsAPIData = [];

//     TopVariable.apiService.getCustomerSubscriptionsList().then((value) {
//       // checking if value is not null then will call this
//       if (value['message']
//               .contains('No subscriptions exists for this userId = ') ==
//           true) {
//         return;
//       }
//       customerInvertersData = value['data'] as List<dynamic>;
//       if (customerInvertersData!.isNotEmpty) {
//         subscriptionsAPIData = customerInvertersData;
//         customerSubscriptions = customerInvertersData;
//         for (int i = 0; i < customerSubscriptions!.length; i++) {
//           final inverterModel = InverterModel();
//           premiseNo = customerSubscriptions![i]['premiseNo'].toString();
//           variantName = customerSubscriptions![i]['variantName'].toString();
//           activeSince = customerSubscriptions![i]['activeSince'].toString();
//           inverterSubscriptionId =
//               customerSubscriptions![i]['subId'].toString();
//           inverterModel.subscriptionId = inverterSubscriptionId;
//           subName = customerSubscriptions![i]['subName'].toString();
//           inverterSubscriptionStatus =
//               customerSubscriptions![i]['status'].toString();

//           // String subscriptionTemplate =
//           //     customerSubscriptions![i]['subscriptionTemplate'].toString();
//           // inverterSubscriptionTemplate =
//           //     customerSubscriptions![i]['subscriptionTemplate'];
//           // subscriptionMappings =
//           //     customerSubscriptions![i]['customerSubscriptionMappings'];
//           // try {
//           //   for (Map<String, dynamic> subscriptionMapping
//           //       in subscriptionMappings!) {
//           //     if (subscriptionMapping['rateCode'] == 'INVRT') {
//           //       inverterValue = subscriptionMapping['value'];
//           //     } else if (subscriptionMapping['rateCode'] == 'LAT') {
//           //       inverterModel.lat = subscriptionMapping['value'];
//           //     } else if (subscriptionMapping['rateCode'] == 'LON') {
//           //       inverterModel.lng = subscriptionMapping['value'];
//           //     } else if (subscriptionMapping['rateCode'] == 'SSDT') {
//           //       inverterSubscriptionActivationDate =
//           //           subscriptionMapping['value'].toString();
//           //       inverterSubscriptionPremiseNo =
//           //           subscriptionMapping['subscriptionRateMatrixId'].toString();
//           //     }
//           //   }
//           // } catch (e) {
//           //   if (kDebugMode) {
//           //     print(e);
//           //   }
//           // }

//           invertersList.add(
//               "$inverterSubscriptionId | $inverterValue | $inverterSubscriptionTemplate");
//           allInverterModels.add(inverterModel);
//           customerSubscriptionsTilesListUserProfile.add(SubscriptionTile(
//             subscriptionId: inverterSubscriptionId,
//             subscriptionStatus: inverterSubscriptionStatus,
//             garden: variantName,
//             premiseNo: premiseNo,
//             activationDate: activeSince,
//           ));
//           customerSubscriptionsTilesList.add(SubscriptionTile(
//               subscriptionId: inverterSubscriptionId,
//               subscriptionTemplete: 'template IC',
//               subscriptionStatus: inverterSubscriptionStatus,
//               garden: variantName,
//               premiseNo: premiseNo,
//               activationDate: activeSince,
//               selected: selectedIds.contains(inverterSubscriptionId),
//               inverterValue: inverterValue));
//         }
//         notifyListeners();
//         //   String invertersData = value.toString();
//         if (kDebugMode) {
//           print(invertersList.toString());
//         }
//       }
//     });
//   }

//   // new
//   getCustomerInverterAllowedSelection() async {
//     CheckConnectivity.isConnected().then((value) {
//       companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
//           ? SvgPicture.network(
//               UserPreferences.tenantLogoPath != null
//                   ? UserPreferences.tenantLogoPath!
//                   : '',
//               width: screenWidth! / 4,
//               height: screenWidth! / 4,
//             )
//           : Image.network(
//               UserPreferences.tenantLogoPath!,
//               height: screenWidth! / 5,
//             );
//     });
//     bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//     if (!_isInternetConnected) {
//       await Get.to(() => const NoInternetScreen());
//       return;
//     }

//     var compkey = UserPreferences.compKey;
//     if (kDebugMode) {
//       print('Value :::: Inside ::: ***** DB Provicder  $compkey');
//     }
//     TopVariable.apiService
//         .getCustomerInverterAllowedSelection(compkey!)
//         .then((value) {
//       if (kDebugMode) {
//         print('Value :::: Inside ::: ***** jjjkkklllll}');
//         print('Value :::: Inside ::: ***** $value}');
//         print('Value :::: Inside ::: ***** ${value['text']}');
//       }
//       UserPreferences.setAllowedSiteSelectionVal = value['text'];
//       notifyListeners();
//     });
//   }

//   // new
//   getCustomerInverterSelectionExceedMsg(String count) async {
//     CheckConnectivity.isConnected().then((value) {
//       companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
//           ? SvgPicture.network(
//               UserPreferences.tenantLogoPath != null
//                   ? UserPreferences.tenantLogoPath!
//                   : '',
//               width: screenWidth! / 4,
//               height: screenWidth! / 4,
//             )
//           : Image.network(
//               UserPreferences.tenantLogoPath!,
//               height: screenWidth! / 5,
//             );
//     });
//     bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//     if (!_isInternetConnected) {
//       await Get.to(() => const NoInternetScreen());
//       return;
//     }

//     TopVariable.apiService
//         .getCustomerInverterSelectionExceedMsg(count.toString())
//         .then((value) {
//       if (kDebugMode) {
//         print('Value :::: Inside ::: ***** $value');
//       }
//     });
//   }

//   // new
//   // => v2
//   getCustomerInverterList() async {
//     CheckConnectivity.isConnected().then((value) {
//       companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
//           ? SvgPicture.network(
//               UserPreferences.tenantLogoPath != null
//                   ? UserPreferences.tenantLogoPath!
//                   : '',
//               width: screenWidth! / 4,
//               height: screenWidth! / 4,
//             )
//           : Image.network(
//               UserPreferences.tenantLogoPath!,
//               height: screenWidth! / 5,
//             );
//     });
//     bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//     if (!_isInternetConnected) {
//       await Get.to(() => const NoInternetScreen());
//       return;
//     }
//     allInverterModels = [];
//     invertersList = [];
//     customerSubscriptionsTilesList = [];
//     customerSubscriptionsTilesListUserProfile = [];
//     subscriptionsAPIData = [];
//     customerInvertersData = [];
//     notifyListeners();

//     variantName = '';
//     premiseNo = '';
//     activeSince = '';
//     inverterSubscriptionId = '';
//     subName = '';
//     inverterSubscriptionStatus = '';
//     variantAlias = '';

//     TopVariable.apiService.getCustomerInverterList().then((value) {
//       customerInvertersData = value as List<dynamic>;
//       if (customerInvertersData!.isNotEmpty) {
//         subscriptionsAPIData = customerInvertersData;
//         customerSubscriptions = customerInvertersData;
//         for (int i = 0; i < customerSubscriptions!.length; i++) {
//           variantName = customerSubscriptions![i]['variantName'].toString();
//           variantAlias = customerSubscriptions![i]['variantAlias'].toString();
//           inverterSubscriptionId = customerSubscriptions![i]['_id'].toString();
//           if (kDebugMode) {
//             print('variantName ::::::: ===== >>>> $variantName');
//           }
//           customerSubscriptionsTilesList.add(SubscriptionTile(
//               subscriptionId: inverterSubscriptionId,
//               subscriptionTemplete: '',
//               subscriptionStatus: '',
//               garden: variantName,
//               variantAlias: variantAlias,
//               premiseNo: '',
//               activationDate: '',
//               selected: selectedIds.contains(inverterSubscriptionId),
//               inverterValue: inverterValue));
//         }

//         notifyListeners();
//       }
//     });
//   }

//   // v1
//   // ignore: prefer_typing_uninitialized_variables
//   Rx<WeatherSitesModel> weatherModel = WeatherSitesModel().obs;

//   int selectedIndex = 0;
//   RxBool isShowNoWeatherWidget = false.obs;
//   RxString valueOFSelectedID = ''.obs;
//   getWeatherOfSites(String selectedID) async {
//     CheckConnectivity.isConnected().then((value) {
//       companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
//           ? SvgPicture.network(
//               UserPreferences.tenantLogoPath != null
//                   ? UserPreferences.tenantLogoPath!
//                   : '',
//               width: screenWidth! / 4,
//               height: screenWidth! / 4,
//             )
//           : Image.network(
//               UserPreferences.tenantLogoPath!,
//               height: screenWidth! / 5,
//             );
//     });
//     bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//     if (!_isInternetConnected) {
//       await Get.to(() => const NoInternetScreen());
//       return;
//     }

//     notifyListeners();
//     if (selectedIds.isNotEmpty) {
//       // var id = selectedIds[index];
//       TopVariable.apiService.getWeatherOfSites(selectedID).then((value) async {
//         if (value.isEmpty == false) {
//           weatherModel.value = WeatherSitesModel.fromJson(value);
//           if (kDebugMode) {
//             print('DDDD::::::::+++++++ >>>> ${weatherModel.value}');
//           }
//           isShowNoWeatherWidget.value = false;
//           notifyListeners();
//         } else {
//           isShowNoWeatherWidget.value = true;
//         }
//       });
//     } else {
//       LocationData? _locationData;
//       _locationData = await location.getLocation();
//       await TopVariable.dashboardProvider.fetchWeatherData(
//           _locationData.latitude!.toString(),
//           _locationData.longitude!.toString(),
//           'true');
//     }
//   }

//   // ignore: prefer_typing_uninitialized_variables
//   dynamic weatherForeCastModel;
//   RxBool isLoadingForeCast = false.obs;
//   getWeatherForeCastOfSites(String selectedID, String noOfDays) async {
//     CheckConnectivity.isConnected().then((value) {
//       companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
//           ? SvgPicture.network(
//               UserPreferences.tenantLogoPath != null
//                   ? UserPreferences.tenantLogoPath!
//                   : '',
//               width: screenWidth! / 4,
//               height: screenWidth! / 4,
//             )
//           : Image.network(
//               UserPreferences.tenantLogoPath!,
//               height: screenWidth! / 5,
//             );
//     });
//     bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//     if (!_isInternetConnected) {
//       await Get.to(() => const NoInternetScreen());
//       return;
//     }
//     isLoadingForeCast.value = true;
//     notifyListeners();

//     var compkey = UserPreferences.compKey;
//     var list = [selectedID, noOfDays, compkey];
//     if (kDebugMode) {
//       print('Value :::: Inside ::: ***** DB Provicder  $compkey');
//       print('Value :::: Inside ::: ***** DB List  $list');
//     }

//     TopVariable.apiService.getWeatherFoerCastOfSites(list).then((value) async {
//       isLoadingForeCast.value = false;
//       notifyListeners();
//       if (value.isEmpty == false) {
//         if (kDebugMode) {
//           print('DDDD::::::::11111+++++++ >>>> $value');
//         }
//         weatherForeCastModel = value;
//         if (kDebugMode) {
//           print('DDDD::::::::+++++++ >>>> ${weatherForeCastModel.length}');
//           print('DDDD::::::::+++++++ >>>> ${weatherForeCastModel[0]['time']}');
//           print(
//               'DDDD::::::::+++++++ >>>> ${weatherForeCastModel[0]['temperature']}');
//           print(
//               'DDDD::::::::+++++++ >>>> ${weatherForeCastModel[0]['forecast']}');
//           print(
//               'DDDD::::::::+++++++ >>>> ${weatherForeCastModel[0]['tempDegree']}');
//         }
//         notifyListeners();
//       } else {}
//     });
//   }

//   String getNameOfSiteFromID(String id) {
//     String name = '';
//     for (int i = 0; i < customerSubscriptionsTilesList.length; i++) {
//       if (customerSubscriptionsTilesList[i].subscriptionId == id) {
//         name = customerSubscriptionsTilesList[i].garden;
//       }
//     }
//     return name;
//   }
//   // v0
//   // var weatherModel;
//   // int selectedIndex = 0;
//   // List<WeatherSitesModel> weahterModelList = [];
//   // getWeatherOfSites(int index) async {
//   //   CheckConnectivity.isConnected().then((value) {
//   //     companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
//   //         ? SvgPicture.network(
//   //             UserPreferences.tenantLogoPath != null
//   //                 ? UserPreferences.tenantLogoPath!
//   //                 : '',
//   //             width: screenWidth! / 4,
//   //             height: screenWidth! / 4,
//   //           )
//   //         : Image.network(
//   //             UserPreferences.tenantLogoPath!,
//   //             height: screenWidth! / 5,
//   //           );
//   //   });
//   //   bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//   //   if (!_isInternetConnected) {
//   //     await Get.to(() => const NoInternetScreen());
//   //     return;
//   //   }

//   //   if (selectedIds.value.isNotEmpty) {
//   //     var id = selectedIds.value[index];
//   //     TopVariable.apiService.getWeatherOfSites(id).then((value) async {
//   //       weatherModel = value;
//   //       if (kDebugMode) {
//   //         print('Value     ::::#:::::: $value');
//   //         print('weatherModel :::::#::::: $weatherModel');
//   //         print('Condition ::::::#:::: ${(weatherModel == null)}');
//   //         print('Condition ::::::#:::: ${(weatherModel)}');
//   //         print(
//   //             'Condition ::::1#:::::: ${(weatherModel == null && selectedIds.value.length < 2)}');
//   //       }

//   //       notifyListeners();
//   //     });
//   //   } else {
//   //     LocationData? _locationData;
//   //     _locationData = await location.getLocation();
//   //     await TopVariable.dashboardProvider.fetchWeatherData(
//   //         _locationData.latitude!.toString(),
//   //         _locationData.longitude!.toString(),
//   //         'true');
//   //   }
//   // }

//   // // => v1
//   // getCustomerInverterList() async {
//   //   CheckConnectivity.isConnected().then((value) {
//   //     companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
//   //         ? SvgPicture.network(
//   //             UserPreferences.tenantLogoPath != null
//   //                 ? UserPreferences.tenantLogoPath!
//   //                 : '',
//   //             width: screenWidth! / 4,
//   //             height: screenWidth! / 4,
//   //           )
//   //         : Image.network(
//   //             UserPreferences.tenantLogoPath!,
//   //             height: screenWidth! / 5,
//   //           );
//   //   });
//   //   bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//   //   if (!_isInternetConnected) {
//   //     await Get.to(() => const NoInternetScreen());
//   //     return;
//   //   }
//   //   allInverterModels = [];
//   //   invertersList = [];
//   //   customerSubscriptionsTilesList = [];
//   //   customerSubscriptionsTilesListUserProfile = [];
//   //   subscriptionsAPIData = [];
//   //   TopVariable.apiService.getCustomerInverterList().then((value) {
//   //     // checking if value is not null then will call this
//   //     if (value['message']
//   //             .contains('No subscriptions exists for this userId = ') ==
//   //         true) {
//   //       return;
//   //     }
//   //     customerInvertersData = value['data'] as List<dynamic>;
//   //     if (customerInvertersData!.isNotEmpty) {
//   //       subscriptionsAPIData = customerInvertersData;
//   //       customerSubscriptions = customerInvertersData;
//   //       for (int i = 0; i < customerSubscriptions!.length; i++) {
//   //         final inverterModel = InverterModel();
//   //         premiseNo = customerSubscriptions![i]['premiseNo'].toString();
//   //         variantName = customerSubscriptions![i]['variantName'].toString();
//   //         activeSince = customerSubscriptions![i]['activeSince'].toString();
//   //         inverterSubscriptionId =
//   //             customerSubscriptions![i]['subId'].toString();
//   //         inverterModel.subscriptionId = inverterSubscriptionId;
//   //         subName = customerSubscriptions![i]['subName'].toString();
//   //         inverterSubscriptionStatus =
//   //             customerSubscriptions![i]['status'].toString();
//   //         // String subscriptionTemplate =
//   //         //     customerSubscriptions![i]['subscriptionTemplate'].toString();
//   //         // inverterSubscriptionTemplate =
//   //         //     customerSubscriptions![i]['subscriptionTemplate'];
//   //         // subscriptionMappings =
//   //         //     customerSubscriptions![i]['customerSubscriptionMappings'];
//   //         // try {
//   //         //   for (Map<String, dynamic> subscriptionMapping
//   //         //       in subscriptionMappings!) {
//   //         //     if (subscriptionMapping['rateCode'] == 'INVRT') {
//   //         //       inverterValue = subscriptionMapping['value'];
//   //         //     } else if (subscriptionMapping['rateCode'] == 'LAT') {
//   //         //       inverterModel.lat = subscriptionMapping['value'];
//   //         //     } else if (subscriptionMapping['rateCode'] == 'LON') {
//   //         //       inverterModel.lng = subscriptionMapping['value'];
//   //         //     } else if (subscriptionMapping['rateCode'] == 'SSDT') {
//   //         //       inverterSubscriptionActivationDate =
//   //         //           subscriptionMapping['value'].toString();
//   //         //       inverterSubscriptionPremiseNo =
//   //         //           subscriptionMapping['subscriptionRateMatrixId'].toString();
//   //         //     }
//   //         //   }
//   //         // } catch (e) {
//   //         //   if (kDebugMode) {
//   //         //     print(e);
//   //         //   }
//   //         // }
//   //         invertersList.add(
//   //             "$inverterSubscriptionId | $inverterValue | $inverterSubscriptionTemplate");
//   //         allInverterModels.add(inverterModel);
//   //         customerSubscriptionsTilesListUserProfile.add(SubscriptionTile(
//   //           subscriptionId: inverterSubscriptionId,
//   //           subscriptionStatus: inverterSubscriptionStatus,
//   //           garden: variantName,
//   //           premiseNo: premiseNo,
//   //           activationDate: activeSince,
//   //         ));
//   //         customerSubscriptionsTilesList.add(SubscriptionTile(
//   //             subscriptionId: inverterSubscriptionId,
//   //             subscriptionTemplete: 'template IC',
//   //             subscriptionStatus: inverterSubscriptionStatus,
//   //             garden: variantName,
//   //             premiseNo: premiseNo,
//   //             activationDate: activeSince,
//   //             selected: selectedIds.value.contains(inverterSubscriptionId),
//   //             inverterValue: inverterValue));
//   //       }
//   //       notifyListeners();
//   //       //   String invertersData = value.toString();
//   //       if (kDebugMode) {
//   //         print(invertersList.toString());
//   //       }
//   //     }
//   //   });
//   // }

//   // new
//   // => v0
//   // void getCustomerInverterList() async {
//   //   CheckConnectivity.isConnected().then((value) {
//   //     companyLogo = UserPreferences.tenantLogoPath!.contains("svg")
//   //         ? SvgPicture.network(
//   //             UserPreferences.tenantLogoPath != null
//   //                 ? UserPreferences.tenantLogoPath!
//   //                 : '',
//   //             width: screenWidth! / 4,
//   //             height: screenWidth! / 4,
//   //           )
//   //         : Image.network(
//   //             UserPreferences.tenantLogoPath!,
//   //             height: screenWidth! / 5,
//   //           );
//   //   });
//   //   bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//   //   if (!_isInternetConnected) {
//   //     await Get.to(() => const NoInternetScreen());
//   //     return;
//   //   }
//   //   allInverterModels = [];
//   //   invertersList = [];
//   //   customerSubscriptionsTilesList = [];
//   //   TopVariable.apiService.getCustomerInverterList().then((value) {
//   //     // checking if value is not null then will call this
//   //     if (kDebugMode) {
//   //       print('Value ::ACGCIList:: inside bracket => ${value['message']}');
//   //     }
//   //     if (value['message']
//   //             .contains('No subscriptions exists for this userId = ') ==
//   //         true) {
//   //       return;
//   //     }
//   //     customerInvertersData = value as List<dynamic>;
//   //     if (customerInvertersData!.isNotEmpty) {
//   //       if (kDebugMode) {
//   //         print('length:::::: of customerInvertersData');
//   //         print(customerInvertersData!.length);
//   //       }
//   //       customerSubscriptions =
//   //           customerInvertersData?[0]['customerSubscriptions'];
//   //       for (int i = 0; i < customerSubscriptions!.length; i++) {
//   //         // subscription = customerSubscriptions![i];
//   //         final inverterModel = InverterModel();
//   //         inverterSubscriptionId = customerSubscriptions![i]['id'].toString();
//   //         inverterModel.subscriptionId = inverterSubscriptionId;
//   //         inverterSubscriptionStatus =
//   //             customerSubscriptions![i]['subscriptionStatus'].toString();
//   //         String subscriptionTemplate =
//   //             customerSubscriptions![i]['subscriptionTemplate'].toString();
//   //         inverterSubscriptionTemplate =
//   //             customerSubscriptions![i]['subscriptionTemplate'];
//   //         subscriptionMappings =
//   //             customerSubscriptions![i]['customerSubscriptionMappings'];
//   //         try {
//   //           for (Map<String, dynamic> subscriptionMapping
//   //               in subscriptionMappings!) {
//   //             if (subscriptionMapping['rateCode'] == 'INVRT') {
//   //               inverterValue = subscriptionMapping['value'];
//   //             } else if (subscriptionMapping['rateCode'] == 'LAT') {
//   //               inverterModel.lat = subscriptionMapping['value'];
//   //             } else if (subscriptionMapping['rateCode'] == 'LON') {
//   //               inverterModel.lng = subscriptionMapping['value'];
//   //             } else if (subscriptionMapping['rateCode'] == 'SSDT') {
//   //               inverterSubscriptionActivationDate =
//   //                   subscriptionMapping['value'].toString();
//   //               inverterSubscriptionPremiseNo =
//   //                   subscriptionMapping['subscriptionRateMatrixId'].toString();
//   //             }
//   //           }
//   //         } catch (e) {
//   //           if (kDebugMode) {
//   //             print(e);
//   //           }
//   //         }
//   //         invertersList.add(
//   //             "$inverterSubscriptionId | $inverterValue | $inverterSubscriptionTemplate");
//   //         allInverterModels.add(inverterModel);
//   //         customerSubscriptionsTilesList.add(SubscriptionTile(
//   //             subscriptionId: inverterSubscriptionId,
//   //             subscriptionTemplete: subscriptionTemplate,
//   //             subscriptionStatus: inverterSubscriptionStatus,
//   //             garden: inverterSubscriptionTemplate,
//   //             premiseNo: inverterSubscriptionPremiseNo,
//   //             activationDate: inverterSubscriptionActivationDate,
//   //             selected: selectedIds.value.contains(inverterSubscriptionId),
//   //             inverterValue: inverterValue));
//   //       }
//   //       notifyListeners();
//   //       //   String invertersData = value.toString();
//   //       if (kDebugMode) {
//   //         print(invertersList.toString());
//   //       }
//   //     }
//   //   });
//   // }

//   Map<String, dynamic>? weatherData;
//   Location location = Location();
//   fetchWeatherData(String lat, String lng, String path) async {
//     bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//     if (!_isInternetConnected) {
//       await Get.to(() => const NoInternetScreen());
//       return;
//     }
//     if (await location.serviceEnabled() == false) {
//       if (kDebugMode) {
//         print('Requesting for Location :::::');
//       }
//       await location.requestService();
//     }
//     http
//         .get(Uri.parse(
//             'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=807c24a314025675a69818a77fc1469a'))
//         .then((value) {
//       if (inverterListReselected) {
//         weatherCards = [];
//         inverterListReselected = false;
//       }
//       if (kDebugMode) {
//         print("Weather data is...\t${value.body.toString()}");
//       }
//       weatherData = json.decode(value.body);
//       if (weatherData != null) {
//         weatherCards.add(WeatherWidget(
//           city: weatherData?['name'],
//           country: weatherData?['sys']['country'],
//           temp: weatherData?['main']['temp'],
//           lat: lat,
//           lng: lng,
//           weatherIcon: weatherData?['weather'][0]['icon'],
//         ));
//       }
//       // http
//       //     .get(Uri.parse(
//       //         'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=807c24a314025675a69818a77fc1469a'))
//       //     .then((value) {
//       //   if (inverterListReselected) {
//       //     weatherCards = [];
//       //     inverterListReselected = false;
//       //   }
//       //   if (kDebugMode) {
//       //     print("Weather data is...\t${value.body.toString()}");
//       //   }
//       //   weatherData = json.decode(value.body);
//       //   if (weatherData != null) {
//       //     weatherCards.add(WeatherWidget(
//       //       city: weatherData?['name'],
//       //       country: weatherData?['sys']['country'],
//       //       temp: weatherData?['main']['temp'],
//       //       lat: lat,
//       //       lng: lng,
//       //       weatherIcon: weatherData?['weather'][0]['icon'],
//       //     ));
//       //   }
//       notifyListeners();
//       if (path == 'true') {
//         getCustomerInverterList();
//       }
//     });
//   }

//   Future<void> fetchWeatherForecastData(String lat, String lng) async {
//     bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//     if (!_isInternetConnected) {
//       await Get.to(() => const NoInternetScreen());
//       return;
//     }
//     // CustomProgressDialog.showProDialog();
//     // http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=807c24a314025675a69818a77fc1469a')).then((value){
//     http
//         .get(Uri.parse(
//             'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lng&exclude=hourly,minutely&appid=807c24a314025675a69818a77fc1469a'))
//         .then((value) {
//       weatherForecastModels = [];
//       if (kDebugMode) {
//         print(
//             'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lng&exclude=hourly,minutely&appid=807c24a314025675a69818a77fc1469a');
//       }
//       if (kDebugMode) {
//         print("Weather Forecast data is...\t${value.body.toString()}");
//       }
//       Map<String, dynamic> weatherData = json.decode(value.body);
//       List<dynamic> allForecasts = weatherData['daily'];
//       for (int i = 0; i < 5; i++) {
//         Map<String, dynamic> weatherForecastOfADay = allForecasts[i];
//         WeatherModel weatherModel = WeatherModel(
//           temp: double.parse(
//                   (weatherForecastOfADay['temp']['day'] - 273.15).toString())
//               .toStringAsFixed(2),
//           tempMin: double.parse(
//                   (weatherForecastOfADay['temp']['min'] - 273.15).toString())
//               .toStringAsFixed(2),
//           tempMax: double.parse(
//                   (weatherForecastOfADay['temp']['max'] - 273.15).toString())
//               .toStringAsFixed(2),
//           humidity: weatherForecastOfADay['humidity'].toString(),
//           description: weatherForecastOfADay['weather'][0]['description'],
//           dtTxt: DateFormat('EEE dd').format(
//             DateTime.fromMillisecondsSinceEpoch(
//                 weatherForecastOfADay['dt'] * 1000),
//           ),
//         );
//         // print(weatherModel.toString());
//         weatherForecastModels.add(weatherModel);
//       }
//       //weatherCards.add(WeatherWidget(city:weatherData['name'],country: weatherData['sys']['country'], temp: weatherData['main']['temp'],));
//       notifyListeners();
//       //CustomProgressDialog.hideProDialog();
//     });
//   }

//   onInverterSelection(List<String> selectedInvertersList) async {
//     bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//     if (!_isInternetConnected) {
//       await Get.to(() => const NoInternetScreen());
//       return;
//     }
//     if (selectedInvertersList.isEmpty) {
//       resetAppData();
//     } else {
//       inverterListReselected = true;
//       for (String inverter in selectedInvertersList) {
//         final splitted = inverter.split(' | ');
//         selectedIds.add(splitted[0]);
//         for (final inverter in allInverterModels) {
//           if (inverter.subscriptionId == splitted[0]) {
//             fetchWeatherData(inverter.lat, inverter.lng, 'true');
//           }
//         }
//       }
//       // await loadWidgets(selectedIds.value);
//       await loadGraphData();
//     }
//   }

//   onDateSelected(DateTime selectedDateFromPicker) async {
//     selectedDate = selectedDateFromPicker;
//     // notifyListeners();
//     if (selectedIds.isNotEmpty) {
//       // await loadWidgets(selectedIds.value);
//       await loadGraphData();
//     } else {
//       ScaffoldMessenger.of(appNavigationKey.currentContext!).showSnackBar(
//           const SnackBar(
//               content: Text('Please select an inverter first\n\n\n')));
//     }
//   }

//   loadUYieldWidgets(List<String> selectedIds) async {
//     final Map<String, dynamic> requestBody = {
//       "variantIds": selectedIds,
//     };
//     bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//     if (!_isInternetConnected) {
//       await Get.to(() => const NoInternetScreen());
//       return;
//     }
//     TopVariable.apiService
//         .getDashboardYieldWidgets(requestBody)
//         .then((response) {
//       if (kDebugMode) {
//         print('getDashboardYieldWidgets: $requestBody');
//         print('response: $response');
//       }
//       mappedResponseYield = response as Map<String, dynamic>;

//       currentPowerValueToday =
//           mappedResponseYield!['data']['currentValue'].toString();
//       notifyListeners();
//     });
//   }

//   loadTreePlantedWidgets(List<String> selectedIds) async {
//     final Map<String, dynamic> requestBody = {
//       "variantIds": selectedIds,
//     };
//     bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//     if (!_isInternetConnected) {
//       await Get.to(() => const NoInternetScreen());
//       return;
//     }
//     TopVariable.apiService
//         .getDashboardTreeFactorWidgets(requestBody)
//         .then((response) {
//       if (kDebugMode) {
//         print('getDashboardTreeFactorWidgets: $requestBody');
//         print('getDashboardTreeFactorWidgets Response: $response');
//       }
//       mappedResponseTreePlanted = response as Map<String, dynamic>;

//       notifyListeners();
//     });
//   }
//   // loadWidgets(List<String> selectedIds.value) async {
//   //   final Map<String, dynamic> requestBody = {
//   //     "subscriptionIds": selectedIds.value,
//   //     "time": null,
//   //     "isComparison": false,
//   //     "isSubscriptionComparison": true,
//   //     "userName": "Dieepa2020",
//   //     "userPass": "Solar~123+",
//   //     "token": "Bearer " + UserPreferences.token!,
//   //   };
//   //   bool _isInternetConnected = await BaseClientClass.isInternetConnected();
//   //   if (!_isInternetConnected) {
//   //     await Get.to(() => const NoInternetScreen());
//   //     return;
//   //   }
//   //   TopVariable.apiService.getDashboardWidgets(requestBody).then((response) {
//   //     if (kDebugMode) {
//   //       print('getDashboardWidgets: $requestBody');
//   //     }
//   //     mappedResponse = response as Map<String, dynamic>;
//   //     currentPowerValueToday = mappedResponse!['currentValue'].toString();
//   //     dashboardSmallWidgets = [
//   //       DashboardSmallWidget(
//   //           title: 'DAILY YEILD',
//   //           unit: 'kWh',
//   //           value: mappedResponse!['dailyYield'].toString(),
//   //           imagePath: 'assets/ic_graph_points.png'),
//   //       DashboardSmallWidget(
//   //           title: 'PEAK VALUE TODAY',
//   //           unit: 'Watts',
//   //           value: mappedResponse!['peakValue'].toString(),
//   //           imagePath: 'assets/ic_peak.png'),
//   //       DashboardSmallWidget(
//   //           title: 'MONTH TO DATE YEILD',
//   //           unit: 'kWh',
//   //           value: mappedResponse!['monthlyYield'].toString(),
//   //           imagePath: 'assets/ic_graph_points.png'),
//   //       DashboardSmallWidget(
//   //           title: 'YEAR TO DATE YEILD',
//   //           unit: 'kWh',
//   //           value: mappedResponse!['annualYield'].toString(),
//   //           imagePath: 'assets/ic_graph_points.png'),
//   //       DashboardSmallWidget(
//   //           title: 'TOTAL YEILD',
//   //           unit: 'kWh',
//   //           value: mappedResponse!['grossYield'].toString(),
//   //           imagePath: 'assets/ic_peak.png'),
//   //       DashboardSmallWidget(
//   //           title: 'SYSTEM SIZE',
//   //           unit: 'kV',
//   //           value: mappedResponse!['sytemSize'].toString(),
//   //           imagePath: 'assets/ic_solar_size.png')
//   //     ];
//   //     dashboardBigWidgets = [
//   //       DashboardBigWidgets(
//   //         title: 'CO\u2082 REDUCTION',
//   //         imagePath: 'assets/ic_co2_reduction.svg',
//   //         value: mappedResponse!['co2Reduction'].toString(),
//   //         background: const Color.fromRGBO(84, 95, 122, 1),
//   //         valueColor: appTheme.colorScheme.secondary,
//   //         descriptionColor: Colors.white,
//   //       ),
//   //       DashboardBigWidgets(
//   //         title: 'TREES PLANTED FACTOR',
//   //         imagePath: 'assets/ic_tree.svg',
//   //         value: mappedResponse!['treesPlanted'].toString(),
//   //         background: const Color.fromRGBO(44, 201, 130, 0.25),
//   //         valueColor: const Color.fromRGBO(0, 186, 102, 1),
//   //         descriptionColor: const Color.fromRGBO(46, 56, 80, 1),
//   //       ),
//   //     ];
//   //     notifyListeners();
//   //   });
//   // }

//   onGraphTimeChanged(String graphTimeSelected) {
//     switch (graphTimeSelected) {
//       case 'Daily':
//         graphTime = GraphTime.daily;
//         loadGraphData();
//         break;
//       case 'Monthly':
//         graphTime = GraphTime.monthly;
//         loadGraphData();
//         break;
//       case 'Yearly':
//         graphTime = GraphTime.yearly;
//         loadGraphData();
//         break;
//     }
//   }

//   onGraphTypeChanged(String graphTypeSelected) {
//     switch (graphTypeSelected) {
//       case 'Cumulative':
//         graphTypeDropdown = GraphType.cumulative;
//         loadGraphData();
//         break;
//       case 'Comparative':
//         graphTypeDropdown = GraphType.comparative;
//         loadGraphData();
//         break;
//     }
//   }

//   loadGraphData() async {
//     switch (graphTypeDropdown) {
//       // Cumulative Graph
//       case GraphType.cumulative:
//         final Map<String, dynamic> queryParams = {
//           "isSubscriptionComparison": true,
//           "isComparison": false,
//         };
//         switch (graphTime) {
//           ////////////////////
//           /// Daily
//           ////////////////////
//           case GraphTime.daily:
//             // final Map<String, dynamic> requestBody = {
//             //   "subscriptionIds": selectedIds.value,
//             //   "time": DateFormat('yyyy-MM-dd hh:mm:ss').format(selectedDate),
//             //   "isComparison": false,
//             //   "isSubscriptionComparison": true
//             // };
//             var currentDateTime = DateTime.now();
//             if (kDebugMode) {
//               print('Time :::::: $currentDateTime');
//               print(
//                   'Time :::daily::: ${currentDateTime.year}-${currentDateTime.month}}');
//             }
//             final Map<String, dynamic> requestBody = {
//               "yearMonth":
//                   '${currentDateTime.year}-${currentDateTime.month}', //"2023-06",
//               "variantIds": selectedIds
//             };
//             if (kDebugMode) {
//               print('Daily graph Data ::: $requestBody');
//             }
//             bool _isInternetConnected =
//                 await BaseClientClass.isInternetConnected();
//             if (!_isInternetConnected) {
//               await Get.to(() => const NoInternetScreen());
//               return;
//             }
//             TopVariable.apiService
//                 .getDailyGraphDataCommulative(queryParams, requestBody)
//                 .then((response) {
//               Map<String, dynamic> mappedResponse =
//                   response as Map<String, dynamic>;
//               List<dynamic> graphDataList = [];
//               graphDataList = mappedResponse['graphData']['-1'] == null ||
//                       mappedResponse['graphData']['-1'] == Null
//                   ? ['0', '0', '0']
//                   : mappedResponse['graphData']['-1'] as List<dynamic>;
//               // List<dynamic> graphDataList =
//               //     mappedResponse['graphData']['-1'] as List<dynamic>;
//               syncfusionPowerData = [];
//               syncfusionXAxis = [];
//               List<double> syncFusionSingleSeries = [];
//               for (Map<String, dynamic> yeildDataObject in graphDataList) {
//                 syncFusionSingleSeries.add(yeildDataObject['yieldValue']);
//               }
//               syncfusionPowerData.add(SyncfusionPowerDataSeriesModel(
//                   syncFusionSingleSeries, 'Cumulative', ));
//               List<dynamic> allTimes = mappedResponse['xaxis'];
//               int i = 0;
//               for (String timeLabel in allTimes) {
//                 if (i < 24) {
//                   syncfusionXAxis.add('$timeLabel am');
//                 } else {
//                   syncfusionXAxis.add('$timeLabel pm');
//                 }
//                 i++;
//               }
//               dailyGraph = true;
//               notifyListeners();
//             });
//             break;
//           ////////////////////
//           /// Monthly
//           ////////////////////
//           case GraphTime.monthly:
//             var currentDateTime = DateTime.now();

//             if (kDebugMode) {
//               print('Time :::::: $currentDateTime');
//               print('Time :::monthly:::  ${currentDateTime.year}}');
//             }
//             final Map<String, dynamic> requestBody = {
//               "startYear": currentDateTime.year,
//               "variantIds": selectedIds
//             };
//             bool _isInternetConnected =
//                 await BaseClientClass.isInternetConnected();
//             if (!_isInternetConnected) {
//               await Get.to(() => const NoInternetScreen());
//               return;
//             }
//             TopVariable.apiService
//                 .getMonthlyGraphDataCommulative(queryParams, requestBody)
//                 .then((response) {
//               Map<String, dynamic> mappedResponse =
//                   response as Map<String, dynamic>;
//               List<dynamic> graphDataList =
//                   mappedResponse['graphData']['-1'] as List<dynamic>;
//               syncfusionPowerData = [];
//               syncfusionXAxis = [];
//               List<double> syncFusionSingleSeries = [];
//               for (Map<String, dynamic> yeildDataObject in graphDataList) {
//                 syncFusionSingleSeries.add(yeildDataObject['yieldValue']);
//               }
//               syncfusionPowerData.add(SyncfusionPowerDataSeriesModel(
//                   syncFusionSingleSeries, 'Cumulative',));
//               List<dynamic> allTimes = mappedResponse['xaxis'];
//               // ignore: unused_local_variable
//               int i = 0;
//               for (String timeLabel in allTimes) {
//                 syncfusionXAxis.add(timeLabel);
//                 /*if(i<24){
//                     syncfusionXAxis.add('$timeLabel am');
//                   } else{
//                     syncfusionXAxis.add('$timeLabel pm');
//                   }
//                   i++;*/
//               }
//               dailyGraph = false;
//               notifyListeners();
//             });
//             break;
//           // ////////////////////
//           // /// Yearly
//           // ////////////////////
//           case GraphTime.yearly:
//             var currentDateTime = DateTime.now();
//             if (kDebugMode) {
//               print('Time :::::: $currentDateTime');
//               print('Time :::yearly:::  ${currentDateTime.year}}');
//             }
//             final Map<String, dynamic> requestBody = {
//               "startYear": currentDateTime.year,
//               "endYear": currentDateTime.year,
//               "variantIds": selectedIds
//             };
//             bool _isInternetConnected =
//                 await BaseClientClass.isInternetConnected();
//             if (!_isInternetConnected) {
//               await Get.to(() => const NoInternetScreen());
//               return;
//             }
//             TopVariable.apiService
//                 .getYearlyGraphDataCommulative(queryParams, requestBody)
//                 .then((response) {
//               Map<String, dynamic> mappedResponse =
//                   response as Map<String, dynamic>;
//               List<dynamic> graphDataList =
//                   mappedResponse['graphData']['-1'] as List<dynamic>;
//               syncfusionPowerData = [];
//               syncfusionXAxis = [];
//               List<double> syncFusionSingleSeries = [];
//               for (Map<String, dynamic> yeildDataObject in graphDataList) {
//                 syncFusionSingleSeries.add(yeildDataObject['yieldValue']);
//               }
//               syncfusionPowerData.add(SyncfusionPowerDataSeriesModel(
//                   syncFusionSingleSeries, 'Cumulative',));
//               List<dynamic> allTimes = mappedResponse['xaxis'];
//               // ignore: unused_local_variable
//               int i = 0;
//               for (String timeLabel in allTimes) {
//                 syncfusionXAxis.add(timeLabel);
//                 /*if(i<24){
//                     syncfusionXAxis.add('$timeLabel am');
//                   } else{
//                     syncfusionXAxis.add('$timeLabel pm');
//                   }
//                   i++;*/
//               }
//               dailyGraph = false;
//               notifyListeners();
//             });

//             break;
//         }
//         break;
//       // Comparative Graph
//       case GraphType.comparative:
//         final Map<String, dynamic> queryParams = {
//           "isSubscriptionComparison": true,
//           "isComparison": true,
//         };
//         switch (graphTime) {
//           ////////////////////
//           /// Daily
//           ////////////////////
//           case GraphTime.daily:
//             var currentDateTime = DateTime.now();
//             if (kDebugMode) {
//               print('Time :::::: $currentDateTime');
//               print(
//                   'Time :::daily::: ${currentDateTime.year}-${currentDateTime.month}}');
//             }
//             final Map<String, dynamic> requestBody = {
//               "yearMonth":
//                   '${currentDateTime.year}-${currentDateTime.month}', //"2023-06",
//               "variantIds": selectedIds
//             };
//             if (kDebugMode) {
//               print('Daily graph Data ::: $requestBody');
//             }

//             bool _isInternetConnected =
//                 await BaseClientClass.isInternetConnected();
//             if (!_isInternetConnected) {
//               await Get.to(() => const NoInternetScreen());
//               return;
//             }
//             TopVariable.apiService
//                 .getDailyGraphDataComparative(queryParams, requestBody)
//                 .then((response) {
//               Map<String, dynamic> mappedResponse =
//                   response as Map<String, dynamic>;
//               Map<String, dynamic> graphDataInvertersObject =
//                   mappedResponse['graphData'] as Map<String, dynamic>;
//               syncfusionPowerData = [];
//               syncfusionXAxis = [];
//               graphDataInvertersObject
//                   .forEach((inverterSubscriptionId, graphDataList) {
//                 List<double> syncFusionSingleSeries = [];
//                 for (Map<String, dynamic> yeildDataObject in graphDataList) {
//                   syncFusionSingleSeries.add(yeildDataObject['yieldValue']);
//                 }
//                 syncfusionPowerData.add(SyncfusionPowerDataSeriesModel(
//                     syncFusionSingleSeries, inverterSubscriptionId,));
//               });
//               List<dynamic> allTimes = mappedResponse['xaxis'];
//               int i = 0;
//               for (String timeLabel in allTimes) {
//                 // syncfusionXAxis.add(timeLabel);
//                 if (i < 24) {
//                   syncfusionXAxis.add('$timeLabel am');
//                 } else {
//                   syncfusionXAxis.add('$timeLabel pm');
//                 }
//                 i++;
//               }
//               dailyGraph = true;
//               notifyListeners();
//             });
//             break;
//           ////////////////////
//           /// Monthly
//           ////////////////////
//           case GraphTime.monthly:
//             var currentDateTime = DateTime.now();

//             if (kDebugMode) {
//               print('Time :::::: $currentDateTime');
//               print('Time :::monthly:::  ${currentDateTime.year}}');
//             }
//             final Map<String, dynamic> requestBody = {
//               "startYear": currentDateTime.year,
//               "variantIds": selectedIds
//             };
//             bool _isInternetConnected =
//                 await BaseClientClass.isInternetConnected();
//             if (!_isInternetConnected) {
//               await Get.to(() => const NoInternetScreen());
//               return;
//             }
//             TopVariable.apiService
//                 .getMonthlyGraphDataComparative(queryParams, requestBody)
//                 .then((response) {
//               Map<String, dynamic> mappedResponse =
//                   response as Map<String, dynamic>;
//               Map<String, dynamic> graphDataInvertersObject =
//                   mappedResponse['graphData'] as Map<String, dynamic>;
//               syncfusionPowerData = [];
//               syncfusionXAxis = [];
//               graphDataInvertersObject
//                   .forEach((inverterSubscriptionId, graphDataList) {
//                 List<double> syncFusionSingleSeries = [];
//                 for (Map<String, dynamic> yeildDataObject in graphDataList) {
//                   syncFusionSingleSeries.add(yeildDataObject['yieldValue']);
//                 }
//                 syncfusionPowerData.add(SyncfusionPowerDataSeriesModel(
//                     syncFusionSingleSeries, inverterSubscriptionId,));
//               });
//               List<dynamic> allTimes = mappedResponse['xaxis'];
//               // ignore: unused_local_variable
//               int i = 0;
//               for (String timeLabel in allTimes) {
//                 syncfusionXAxis.add(timeLabel);
//                 /*if(i<24){
//                   syncfusionXAxis.add('$timeLabel am');
//                 } else{
//                   syncfusionXAxis.add('$timeLabel pm');
//                 }
//                 i++;*/
//               }
//               dailyGraph = false;
//               notifyListeners();
//             });

//             break;
//           ////////////////////
//           /// Yearly
//           ////////////////////
//           case GraphTime.yearly:
//             // final Map<String, dynamic> requestBody = {
//             //   "subscriptionIds": selectedIds.value,
//             //   "time": int.parse(DateFormat('yyyy').format(selectedDate)),
//             //   "isComparison": false,
//             //   "isSubscriptionComparison": true
//             // };

//             var currentDateTime = DateTime.now();
//             if (kDebugMode) {
//               print('Time :::::: $currentDateTime');
//               print('Time :::yearly:::  ${currentDateTime.year}}');
//             }
//             final Map<String, dynamic> requestBody = {
//               "startYear": currentDateTime.year,
//               "endYear": currentDateTime.year,
//               "variantIds": selectedIds
//             };
//             bool _isInternetConnected =
//                 await BaseClientClass.isInternetConnected();
//             if (!_isInternetConnected) {
//               await Get.to(() => const NoInternetScreen());
//               return;
//             }
//             TopVariable.apiService
//                 .getYearlyGraphDataComparative(queryParams, requestBody)
//                 .then((response) {
//               Map<String, dynamic> mappedResponse =
//                   response as Map<String, dynamic>;
//               Map<String, dynamic> graphDataInvertersObject =
//                   mappedResponse['graphData'] as Map<String, dynamic>;
//               syncfusionPowerData = [];
//               syncfusionXAxis = [];
//               graphDataInvertersObject
//                   .forEach((inverterSubscriptionId, graphDataList) {
//                 List<double> syncFusionSingleSeries = [];
//                 for (Map<String, dynamic> yeildDataObject in graphDataList) {
//                   syncFusionSingleSeries.add(yeildDataObject['yieldValue']);
//                 }
//                 syncfusionPowerData.add(SyncfusionPowerDataSeriesModel(
//                     syncFusionSingleSeries, inverterSubscriptionId));
//               });
//               List<dynamic> allTimes = mappedResponse['xaxis'];
//               // ignore: unused_local_variable
//               int i = 0;
//               for (String timeLabel in allTimes) {
//                 syncfusionXAxis.add(timeLabel);
//                 /*if(i<24){
//                   syncfusionXAxis.add('$timeLabel am');
//                 } else{
//                   syncfusionXAxis.add('$timeLabel pm');
//                 }
//                 i++;*/
//               }
//               dailyGraph = false;
//               notifyListeners();
//             });

//             break;
//         }
//         break;
//     }
//   }

//   resetAppData() {
//     // TopVariable.generalProvider.profilePicture = null;
//     //TopVariable.dashboardProvider.invertersList = [];
//     allInverterModels.clear();
//     TopVariable.dashboardProvider.inverterSubscriptionId = '';
//     TopVariable.dashboardProvider.inverterSubscriptionTemplate = '';
//     TopVariable.dashboardProvider.inverterValue = '';
//     TopVariable.dashboardProvider.inverterLat = 0.0;
//     TopVariable.dashboardProvider.inverterLong = 0.0;
//     //TopVariable.dashboardProvider.allInverterModels = [];
//     TopVariable.dashboardProvider.weatherCards = [];
//     TopVariable.dashboardProvider.weatherForecastModels = [
//       WeatherModel(),
//       WeatherModel(),
//       WeatherModel(),
//       WeatherModel(),
//       WeatherModel(),
//     ];
//     TopVariable.dashboardProvider.dashboardSmallWidgets = [
//       const DashboardSmallWidget(
//           title: 'DAILY YEILD',
//           unit: 'kWh',
//           value: '0',
//           imagePath: 'assets/ic_graph_points.png'),
//       const DashboardSmallWidget(
//           title: 'PEAK VALUE TODAY',
//           unit: 'Watts',
//           value: '0',
//           imagePath: 'assets/ic_peak.png'),
//       const DashboardSmallWidget(
//           title: 'MONTH TO DATE YEILD',
//           unit: 'kWh',
//           value: '0',
//           imagePath: 'assets/ic_graph_points.png'),
//       const DashboardSmallWidget(
//           title: 'YEAR TO DATE YEILD',
//           unit: 'kWh',
//           value: '0',
//           imagePath: 'assets/ic_graph_points.png'),
//       const DashboardSmallWidget(
//           title: 'TOTAL YEILD',
//           unit: 'kWh',
//           value: '0',
//           imagePath: 'assets/ic_peak.png'),
//       const DashboardSmallWidget(
//           title: 'SYSTEM SIZE',
//           unit: 'kV',
//           value: '0',
//           imagePath: 'assets/ic_solar_size.png')
//     ];
//     TopVariable.dashboardProvider.dashboardBigWidgets = [
//       DashboardBigWidgets(
//         title: 'CO\u2082 REDUCTION',
//         imagePath: 'assets/ic_co2_reduction.svg',
//         value: '0',
//         background: const Color.fromRGBO(84, 95, 122, 1),
//         valueColor: appTheme.colorScheme.secondary,
//         descriptionColor: Colors.white,
//       ),
//       const DashboardBigWidgets(
//         title: 'TREES PLANTED FACTOR',
//         imagePath: 'assets/ic_tree.svg',
//         value: '0',
//         background: Color.fromRGBO(44, 201, 130, 0.25),
//         valueColor: Color.fromRGBO(0, 186, 102, 1),
//         descriptionColor: Color.fromRGBO(46, 56, 80, 1),
//       ),
//     ];
//     TopVariable.dashboardProvider.inverterListReselected = false;

//     TopVariable.dashboardProvider.graphData = [
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//       // """0.0""",
//     ];

//     TopVariable.dashboardProvider.graphTime = GraphTime.daily;
//     TopVariable.dashboardProvider.graphTypeDropdown = GraphType.cumulative;

//     TopVariable.dashboardProvider.graphXAxis = StringBuffer(
//         '["12:00","12:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30"]');
//     TopVariable.dashboardProvider.syncfusionXAxis = [
//       // "12:00",
//       // "12:30",
//       // "01:00",
//       // "01:30",
//       // "02:00",
//       // "02:30",
//       // "03:00",
//       // "03:30",
//       // "04:00",
//       // "04:30",
//       // "05:00",
//       // "05:30",
//       // "06:00",
//       // "06:30",
//       // "07:00",
//       // "07:30",
//       // "08:00",
//       // "08:30",
//       // "09:00",
//       // "09:30",
//       // "10:00",
//       // "10:30",
//       // "11:00",
//       // "11:30",
//       // "12:00",
//       // "12:30",
//       // "01:00",
//       // "01:30",
//       // "02:00",
//       // "02:30",
//       // "03:00",
//       // "03:30",
//       // "04:00",
//       // "04:30",
//       // "05:00",
//       // "05:30",
//       // "06:00",
//       // "06:30",
//       // "07:00",
//       // "07:30",
//       // "08:00",
//       // "08:30",
//       // "09:00",
//       // "09:30",
//       // "10:00",
//       // "10:30",
//       // "11:00",
//       // "11:30"
//     ];
//     TopVariable.dashboardProvider.dailyGraph = true;
//     TopVariable.dashboardProvider.syncfusionPowerData = [
//       SyncfusionPowerDataSeriesModel([
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0,
//         // 0
//       ], 'Cumulative')
//     ];
//     TopVariable.dashboardProvider.selectedIds.value = [];
//     TopVariable.dashboardProvider.selectedDate =
//         DateTime.now().subtract(const Duration(days: 1));
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       notifyListeners();
//     });
//   }
// }

// class InverterModel {
//   String subscriptionId;
//   String lat;
//   String lng;
//   InverterModel({this.subscriptionId = '', this.lat = '', this.lng = ''});
// }

// enum GraphTime { daily, monthly, yearly }

// enum GraphType { cumulative, comparative }
