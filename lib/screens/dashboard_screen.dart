// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/dataModel/user_model.dart';
import 'package:solaramps/gen/assets.gen.dart';
import 'package:solaramps/providers/dashboard_provider.dart';
import 'package:solaramps/providers/general_provider.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import 'package:solaramps/widget/bottom_bar.dart';
import 'package:solaramps/widget/full_screen_graph.dart';
import 'package:solaramps/widget/multi_select_drop_down.dart';
import 'package:solaramps/widget/production_graph_syncfusion.dart';

import '../dataModel/weather_model.dart';
// import '../domain/user.dart';
import '../utility/constants.dart';
import '../widget/dashboard_big_widgets.dart';
import '../widget/dashboard_small_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

Color backgroundColor = Colors.transparent;

class _DashboardScreenState extends State<DashboardScreen> {
  UserModel user = UserPreferences.user;
  String graphType = 'cumulative', graphPeriod = 'daily';

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        onTap: () {
          var route = ModalRoute.of(context);
          if (route != null) {
            if (route.settings.name != '/user_profile') {
              TopVariable.switchScreen(Constants.userProfileScreenPath);
            }
          }
        },
        child: Consumer(
          builder: (context, GeneralProvider value, child) {
            return ClipOval(
              child: value.profilePicture != null
                  ? Image.file(
                      File(value.profilePicture!),
                      width: 55,
                      fit: BoxFit.cover,
                      height: 55,
                    )
                  : SvgPicture.asset(
                      Assets.profilePic,
                      width: 60,
                    ),
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNaviBar(),
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      body: SafeArea(
        child: OrientationBuilder(builder: (context, orientation) {
          return Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: screenWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // const SizedBox(height: 10),
                    UserPreferences.tenantLogoPath!.contains("svg")
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
                          ),
                    Text(
                      'Power Monitoring Dashboard',
                      style: TextStyle(
                          fontSize:
                              appTheme.primaryTextTheme.subtitle1!.fontSize!,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ListView(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      elevation: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: Text(
                              'SELECT INVERTERS(S)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.primaryColor,
                                  fontSize:
                                      appTheme.textTheme.subtitle2!.fontSize),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10, top: 5),
                            child: Consumer<DashboardProvider>(
                                builder: (context, dashboardConsumer, child) {
                              child = DropDownMultiSelectCustom(
                                onChanged: (List<String> x) async {
                                  setState(() {
                                    selectedInverters = x;
                                  });
                                  await TopVariable.dashboardProvider
                                      .onInverterSelection(x);
                                },
                                options: dashboardConsumer.invertersList,
                                selectedValues: selectedInverters,
                                whenEmpty: 'Search Inverters',
                              );
                              return child;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(height: 10,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Consumer<DashboardProvider>(
                        builder: (context, dashboardConsumer, child) {
                      child = Row(
                        children: dashboardConsumer.weatherCards,
                      );
                      return child;
                    }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 5),
                    scrollDirection: Axis.horizontal,
                    child: Consumer<DashboardProvider>(
                        builder: (context, dashboardConsumer, child) {
                      child = Row(
                        children: dashboardConsumer.dashboardSmallWidgets,
                      );
                      return child;
                    }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 5),
                    scrollDirection: Axis.horizontal,
                    child: Consumer<DashboardProvider>(
                        builder: (context, dashboardConsumer, child) {
                      child = Row(
                        children: dashboardConsumer.dashboardBigWidgets,
                      );
                      return child;
                    }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      height: 0.5,
                      width: screenWidth,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'Production Analysis Graphs',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: appTheme.textTheme.subtitle1!.fontSize! - 1,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              height: 30.0,
                              width: screenWidth! / 2 - 20,
                              child: DropdownButtonFormField<String>(
                                icon: const Icon(Icons.arrow_drop_down),
                                dropdownColor:
                                    const Color.fromRGBO(255, 255, 255, 1),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(230, 86, 39, 1),
                                        width: 5.0),
                                  ),
                                  filled: false,
                                  labelText: 'Time Period',
                                  labelStyle: TextStyle(
                                      color: Color.fromRGBO(230, 86, 39, 1),
                                      fontSize: 12),
                                ),
                                onChanged: (value) {
                                  TopVariable.dashboardProvider
                                      .onGraphTimeChanged(value!);
                                  setState(() {
                                    graphPeriod = value;
                                  });
                                },
                                hint: const Text('Daily'),
                                items: <String>[
                                  'Daily',
                                  'Monthly',
                                  'Yearly'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(value)
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              height: 30.0,
                              width: screenWidth! / 2 - 20,
                              child: DropdownButtonFormField<String>(
                                icon: const Icon(Icons.arrow_drop_down),
                                dropdownColor:
                                    const Color.fromRGBO(255, 255, 255, 1),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(230, 86, 39, 1),
                                        width: 5.0),
                                  ),
                                  filled: false,
                                  labelText: 'Graph Type',
                                  labelStyle: TextStyle(
                                      color: Color.fromRGBO(230, 86, 39, 1),
                                      fontSize: 12),
                                ),
                                onChanged: (value) {
                                  TopVariable.dashboardProvider
                                      .onGraphTypeChanged(value!);
                                  setState(() {
                                    graphType = value;
                                  });
                                },
                                hint: const Text('Cumulative'),
                                items: <String>[
                                  'Cumulative',
                                  'Comparative'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(value)
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    width: screenWidth,
                    height: 30,
                    child: Stack(
                      children: [
                        Positioned(
                            left: 15,
                            child: Text(
                              '${graphPeriod.toUpperCase()} - ${graphType.toUpperCase()}',
                              style: TextStyle(
                                  color: appTheme.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            )),
                        //  Positioned(child: Text('selceted'), left: 10,),
                        Positioned(
                            child: GestureDetector(
                              child: Row(
                                children: [
                                  Consumer<DashboardProvider>(builder:
                                      (context, dashboardConsumer, child) {
                                    child = Text(DateFormat('EEE dd-MM-yyyy')
                                        .format(dashboardConsumer.selectedDate)
                                        .toString());
                                    return child;
                                  }),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    'assets/date_edit.png',
                                    height: 12,
                                  )
                                ],
                              ),
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: TopVariable
                                      .dashboardProvider.selectedDate,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  TopVariable.dashboardProvider
                                      .onDateSelected(picked);
                                  setState(() {
                                    selectedDate = picked;
                                  });
                                }
                              },
                            ),
                            right: 25)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenWidth,
                    height: 230,
                    child: Consumer<DashboardProvider>(
                        builder: (context, dashboardConsumer, child) {
                      /*child = ProductionGraph(width: screenWidth!, height: 230,
                                 graphData:
                                 dashboardConsumer.allGraphSeries.toString(), xAxisData: dashboardConsumer.graphXAxis.toString(),
                                 graphType: dashboardConsumer.graphType,);*/
                      child = ProductionGraphSyncfusion(
                        xAxisData: dashboardConsumer.syncfusionXAxis,
                        powerDataSeries: dashboardConsumer.syncfusionPowerData,
                        // powerDataSeries: dashboardConsumer.syncfusionPowerData
                        //     as List<SyncfusionPowerDataSeriesModel>,
                        dailyGraph: dashboardConsumer.dailyGraph,
                      );
                      if (kDebugMode) {
                        print(dashboardConsumer.syncfusionPowerData.toString());
                      }
                      return child;
                    }),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.topRight,
                    child: Ink.image(
                      image: const AssetImage('assets/expand_button.png'),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.topRight,
                      fit: BoxFit.fill,
                      width: 40,
                      height: 40,
                      child: InkWell(onTap: () {
                        // TopVariable.switchScreen(Constants.fullScreenGraphScreenPath);
                        Navigator.push(
                          context,
                          /*MaterialPageRoute(
                                 builder: (context) => FullScreenGraph(graphDate: TopVariable.dashboardProvider.selectedDate,),
                               )*/
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    FullScreenGraph(
                              graphDate:
                                  TopVariable.dashboardProvider.selectedDate,
                              graphType: graphType,
                              graphPeriod: graphPeriod,
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ))
            ],
          );
        }),
      ),
    );
  }

  List<String> selectedInverters = [];

  @override
  void initState() {
    /*WidgetsBinding.instance?.addPostFrameCallback((_) {
      TopVariable.dashboardProvider.getCustomerInverterList();
    });*/
    TopVariable.dashboardProvider.getCustomerInverterList();
    // TopVariable.generalProvider
    //     .updateProfilePicture(UserPreferences.getString("userImage"));
    return super.initState();
  }

  @override
  void dispose() {
    TopVariable.dashboardProvider.invertersList = [];
    TopVariable.dashboardProvider.inverterSubscriptionId = '';
    TopVariable.dashboardProvider.inverterSubscriptionTemplate = '';
    TopVariable.dashboardProvider.inverterValue = '';
    TopVariable.dashboardProvider.inverterLat = 0.0;
    TopVariable.dashboardProvider.inverterLong = 0.0;
    TopVariable.dashboardProvider.allInverterModels = [];
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
      const DashboardBigWidgets(
        title: 'CO\u2082 REDUCTION',
        imagePath: 'assets/ic_co2_reduction.svg',
        value: '0',
        background: Color.fromRGBO(84, 95, 122, 1),
        valueColor: Colors.white,
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
    TopVariable.dashboardProvider.selectedIds.value = [];
    TopVariable.dashboardProvider.selectedDate =
        DateTime.now().subtract(const Duration(days: 1));
    return super.dispose();
  }
}
