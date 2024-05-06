// ignore_for_file: unnecessary_this

import 'package:card_swiper/card_swiper.dart';
import 'package:conversion_units/conversion_units.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/dataModel/user_model.dart';
import 'package:solaramps/model_/weather_sites_model.dart';
import 'package:solaramps/providers/dashboard_provider.dart';
import 'package:solaramps/screens/home/home.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import 'package:solaramps/widget/full_screen_graph.dart';
import 'package:solaramps/widget/production_graph_syncfusion.dart';

class NewDashboard extends StatefulWidget {
  const NewDashboard({Key? key}) : super(key: key);

  @override
  State<NewDashboard> createState() => _NewDashboardState();
}

class _NewDashboardState extends State<NewDashboard> {
  Location location = Location();
  bool _isExpended = false;

  bool? _serviceEnabled;
  int _selectedIndex = 0;
  PermissionStatus? _permissionGranted;
  var selectedvaloFForeCast = 'Today';
  // LocationData? _locationData;
  Widget space = Container(
    height: 10,
    color: Colors.grey.shade300,
  );
  EdgeInsets padding =
      const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLocation();
      _selectedIndex = 0;
      setState(() {
        TopVariable.dashboardProvider.selectedIds.clear();
      });
    });
    super.initState();
  }

  void fetchLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      TopVariable.dashboardProvider.weatherModel.value = WeatherSitesModel();
      TopVariable.dashboardProvider.selectedIds.clear();
    });
    setState(() {});
  }

  ScrollController scrollController = ScrollController();
  bool isScrollDown = true;
  Future<void> autoScroll(bool isScroll) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (isScroll) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    } else {
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    }
    setState(() {});
  }

  // Dashboard
  @override
  Widget build(BuildContext context) {
    UserModel user = UserPreferences.user;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200), // Set this height
          child: appbar(user),
        ),
        bottomNavigationBar: bottomBar(context),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColor.grenishColor,
          child: Icon(
            isScrollDown ? Icons.arrow_drop_down : Icons.arrow_drop_up,
            color: Colors.white,
          ),
          elevation: 12,
          mini: true,
          onPressed: () {
            if (isScrollDown) {
              autoScroll(isScrollDown);
              setState(() {
                isScrollDown = false;
              });
            } else {
              autoScroll(isScrollDown);
              setState(() {
                isScrollDown = true;
              });
            }
          },
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              // Inverter List
              inverterNavigate(),
              space,

              // Weather
              Obx(() {
                return TopVariable.dashboardProvider.selectedIds.isEmpty
                    ? weatherWidget()
                    : Column(
                        children: [
                          TopVariable.dashboardProvider.selectedIds.isNotEmpty
                              ? Container(
                                  height: Get.height * 0.06,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey.shade100,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: DropdownButton<String>(
                                      value: TopVariable.dashboardProvider
                                                  .valueOFSelectedID.value ==
                                              ''
                                          ? TopVariable.dashboardProvider
                                              .selectedIds.first
                                          : TopVariable.dashboardProvider
                                              .valueOFSelectedID.value,
                                      items: TopVariable
                                          .dashboardProvider.selectedIds
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) async {
                                        setState(() {
                                          TopVariable
                                              .dashboardProvider
                                              .valueOFSelectedID
                                              .value = value ?? "";
                                        });
                                        await TopVariable.dashboardProvider
                                            .getWeatherOfSites(
                                                value.toString());
                                        setState(() {
                                          TopVariable.dashboardProvider
                                              .selectedIdsForGraph
                                              .clear();
                                          TopVariable.dashboardProvider
                                              .selectedIdsForGraph
                                              .add(value.toString());
                                        });

                                        await TopVariable.dashboardProvider
                                            .loadGraphData(TopVariable
                                                .dashboardProvider
                                                .selectedIdsForGraph);

                                        setState(() {});
                                      },
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          TopVariable.dashboardProvider.isShowNoWeatherWidget
                                      .value ==
                                  true
                              ? Container(
                                  height: Get.height * 0.12,
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 4),
                                  child: Center(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text:
                                            'No Weather Update Available Related to ',
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  '\n ${TopVariable.dashboardProvider.getNameOfSiteFromID(TopVariable.dashboardProvider.valueOFSelectedID.value)}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () async {
                                    if (kDebugMode) {
                                      print('Testing :::::: ====>');
                                    }
                                    await TopVariable.dashboardProvider
                                        .getWeatherForeCastOfSites(
                                            TopVariable.dashboardProvider
                                                    .weatherModel.value.refId ??
                                                "",
                                            '1');
                                    setState(() {
                                      selectedvaloFForeCast = 'Today';
                                    });
                                    _weatherForeCast(
                                        TopVariable.dashboardProvider
                                            .getNameOfSiteFromID(TopVariable
                                                .dashboardProvider
                                                .valueOFSelectedID
                                                .value),
                                        TopVariable.dashboardProvider
                                                .weatherModel.value.state ??
                                            "");
                                  },
                                  child: Container(
                                    height: Get.height * 0.12,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 4),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: Get.width * 0.99,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/weather_icons/038-cloudy-3.svg',
                                                height: 25,
                                                fit: BoxFit.contain,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      TopVariable
                                                              .dashboardProvider
                                                              .weatherModel
                                                              .value
                                                              .temperature ??
                                                          "",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      TopVariable
                                                              .dashboardProvider
                                                              .weatherModel
                                                              .value
                                                              .wxPhraseLong ??
                                                          "",
                                                      style: const TextStyle(
                                                          fontSize: 10),
                                                      maxLines: 2,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.24,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      child: RichText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        text: TextSpan(
                                                          text: TopVariable
                                                                  .dashboardProvider
                                                                  .weatherModel
                                                                  .value
                                                                  .uvDescription ??
                                                              "",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.amber,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: ' ' +
                                                                  TopVariable
                                                                      .dashboardProvider
                                                                      .weatherModel
                                                                      .value
                                                                      .precipChance
                                                                      .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.17,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/weather_icons/025-humidity.svg',
                                                            height: 15,
                                                            fit: BoxFit.contain,
                                                          ),
                                                          const Text(
                                                            ' 0%',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              SizedBox(
                                                width: Get.width * 0.39,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: Get.width * 0.39,
                                                      child: Center(
                                                        child: Text(
                                                          TopVariable
                                                              .dashboardProvider
                                                              .getNameOfSiteFromID(
                                                                  TopVariable
                                                                      .dashboardProvider
                                                                      .valueOFSelectedID
                                                                      .value),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.39,
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(
                                                              Icons.location_on,
                                                              size: 12,
                                                            ),
                                                            Text(
                                                              TopVariable
                                                                      .dashboardProvider
                                                                      .weatherModel
                                                                      .value
                                                                      .state ??
                                                                  "",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                            left: 25,
                                            right: 25,
                                          ),
                                          child: SizedBox(
                                            height: 35,
                                            child: RichText(
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                text: 'There will be ',
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: TopVariable
                                                            .dashboardProvider
                                                            .weatherModel
                                                            .value
                                                            .narrative ??
                                                        "",
                                                    // text: TopVariable
                                                    //         .dashboardProvider
                                                    //         .weatherModel
                                                    //         .value['narrative'] ??
                                                    //     "",
                                                    style: const TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      );
              }),
              const SizedBox(
                height: 10,
              ),
              space,
              const SizedBox(
                height: 10,
              ),
              yield(),
              TopVariable.dashboardProvider.mappedResponseYield == null
                  ? const SizedBox()
                  : space,
              SizedBox(
                height:
                    TopVariable.dashboardProvider.mappedResponseYield == null
                        ? 0
                        : 10,
              ),
              trees(),
              const SizedBox(
                height: 10,
              ),
              space,
              graph()
            ],
          ),
        ),
      ),
    );
  }

//
  Widget bottomBar(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          // canvasColor: const Color.fromRGBO(2, 87, 122, 1),
          canvasColor: CustomColor.grenishColor,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: const TextStyle(color: Colors.white),
              ),
        ),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: CustomColor.grenishColor,
            currentIndex: 0,
            onTap: (val) {
              if (val == 0) {
                setState(() {
                  _selectedIndex = 0;
                });
                Get.off(() => const HomeScreenTabs());
              } else if (val == 1) {
                var route = ModalRoute.of(context);
                if (route != null) {
                  setState(() {
                    _selectedIndex = 1;
                    UserPreferences.setString('showSupporttab', 'true');
                  });
                  if (route.settings.name != '/customer_support') {
                    TopVariable.switchScreen("/customer_support");
                  }
                }
              } else if (val == 2) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Search'),
                    content: const Text('No data available for Search'),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();

                          Get.off(() => const NewDashboard());
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                      ),
                    ],
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Notifications'),
                    content: const Text('No new notification available.'),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Get.off(() => const NewDashboard());
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                      ),
                    ],
                  ),
                );
              }
              setState(() {
                _selectedIndex = val;
              });
              if (kDebugMode) {
                print('Value :::: $val');
                print('_selectedIndex :::: $_selectedIndex');
              }
            },
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    _selectedIndex != 0
                        ? 'assets/ic_home_white.svg'
                        : 'assets/ic_home.svg',
                    height: 16,
                    fit: BoxFit.fitHeight,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex != 1
                      ? 'assets/ic_customer_support_white.svg'
                      : 'assets/ic_customer_support.svg',
                  height: 18,
                  fit: BoxFit.fitHeight,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    _selectedIndex != 2
                        ? 'assets/ic_search_white.svg'
                        : 'assets/ic_search.svg',
                    height: 18,
                    fit: BoxFit.fitHeight,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex != 3
                      ? 'assets/ic_notification_white.svg'
                      : 'assets/ic_notification.svg',
                  height: 18,
                  fit: BoxFit.fitHeight,
                ),
                label: "",
              ),
            ]));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TopVariable.dashboardProvider.resetAppData();
    });
    super.dispose();
  }

  Widget appbar(UserModel user) {
    return Container(
      height: 70,
      // color: appTheme.primaryColor,
      color: CustomColor.grenishColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            width: Get.width * 0.01,
          ),
          SizedBox(
            width: Get.width * 0.5,
            child: Hero(
              tag: "userimage",
              child: Text(
                // user.userName ?? '',
                UserPreferences.getString('userName') ?? "--",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: user.userName.toString().length > 20 ? 16 : 18),
                maxLines: 2,
              ),
            ),
          ),
          const Spacer(),
          Text(
            DateFormat.yMMMEd().format(DateTime.now()),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          )
        ]),
      ),
    );
  }

  void _weatherForeCast(String siteName, String location) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setStateSB) {
              return SingleChildScrollView(
                child: Obx(() {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'ForeCast',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(233, 115, 65, 1)),
                              ),
                              const Spacer(),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    setStateSB(() {});
                                  },
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 20,
                                  ))
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: Get.width * 0.39,
                                child: Center(
                                  child: Text(
                                    siteName,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Color.fromRGBO(2, 87, 122, 1)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.39,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 12,
                                          color: Color.fromRGBO(2, 87, 122, 1)),
                                      Text(
                                        location,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Center(
                                    child: Text(
                                      'Period',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Color.fromRGBO(2, 87, 122, 1)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: Get.height * 0.038,
                                    width: Get.width * 0.3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: DropdownButton<String>(
                                        underline: const SizedBox(),
                                        value: selectedvaloFForeCast,
                                        alignment: Alignment.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        items: [
                                          'Today',
                                          'This Week',
                                          'This Month'
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (value) async {
                                          setStateSB(() {
                                            selectedvaloFForeCast = value ?? "";
                                          });
                                          if (selectedvaloFForeCast ==
                                              'Today') {
                                            setStateSB(() {
                                              TopVariable.dashboardProvider
                                                  .weatherForeCastModel = null;
                                            });
                                            await TopVariable.dashboardProvider
                                                .getWeatherForeCastOfSites(
                                                    TopVariable
                                                            .dashboardProvider
                                                            .weatherModel
                                                            .value
                                                            .refId ??
                                                        "",
                                                    '1');
                                          } else if (selectedvaloFForeCast ==
                                              'This Week') {
                                            setStateSB(() {
                                              TopVariable.dashboardProvider
                                                  .weatherForeCastModel = null;
                                            });
                                            await TopVariable.dashboardProvider
                                                .getWeatherForeCastOfSites(
                                                    TopVariable
                                                            .dashboardProvider
                                                            .weatherModel
                                                            .value
                                                            .refId ??
                                                        "",
                                                    '7');
                                          } else {
                                            setStateSB(() {
                                              TopVariable.dashboardProvider
                                                  .weatherForeCastModel = null;
                                            });
                                            await TopVariable.dashboardProvider
                                                .getWeatherForeCastOfSites(
                                                    TopVariable
                                                            .dashboardProvider
                                                            .weatherModel
                                                            .value
                                                            .refId ??
                                                        "",
                                                    '30');
                                          }
                                          setStateSB(() {});
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Time",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromRGBO(
                                    2,
                                    87,
                                    122,
                                    1,
                                  ),
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Forecast",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromRGBO(
                                    2,
                                    87,
                                    122,
                                    1,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text(
                                "Temperature",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromRGBO(
                                    2,
                                    87,
                                    122,
                                    1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                          Container(
                            height: TopVariable.dashboardProvider
                                        .isLoadingForeCast.value ||
                                    TopVariable.dashboardProvider
                                            .weatherForeCastModel ==
                                        null
                                ? Get.height * 0.2
                                : Get.height * 0.44,
                            margin: const EdgeInsets.only(top: 10),
                            child: TopVariable
                                    .dashboardProvider.isLoadingForeCast.value
                                ? Container(
                                    height: Get.height * 0.2,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : TopVariable.dashboardProvider
                                            .weatherForeCastModel ==
                                        null
                                    ? Container(
                                        height: Get.height * 0.2,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "No Data Found",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              color: Color.fromRGBO(
                                                2,
                                                87,
                                                122,
                                                1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: TopVariable.dashboardProvider
                                            .weatherForeCastModel.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: InkWell(
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: Get.width * 0.3,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              TopVariable
                                                                  .dashboardProvider
                                                                  .weatherForeCastModel[
                                                                      index]
                                                                      ['time']
                                                                  .toString()
                                                                  .split(
                                                                      ' ')[0],
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                          Text(
                                                              TopVariable
                                                                  .dashboardProvider
                                                                  .weatherForeCastModel[
                                                                      index]
                                                                      ['time']
                                                                  .toString()
                                                                  .split(
                                                                      ' ')[1],
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      width: Get.width * 0.3,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          TopVariable
                                                              .dashboardProvider
                                                              .weatherForeCastModel[
                                                                  index]
                                                                  ['forecast']
                                                              .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors.black,
                                                          )),
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      width: Get.width * 0.3,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          TopVariable
                                                                  .dashboardProvider
                                                                  .weatherForeCastModel[
                                                                      index][
                                                                      'temperature']
                                                                  .toString() +
                                                              ' ' +
                                                              TopVariable
                                                                  .dashboardProvider
                                                                  .weatherForeCastModel[
                                                                      index][
                                                                      'tempDegree']
                                                                  .toString(),
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors.black,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                }),
                                          );
                                        }),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          );
        }).whenComplete(() {
      if (kDebugMode) {
        print('Completion ::::::::: Of Bottom Sheet');
      }
    });
  }

  Widget inverterNavigate() {
    return InkWell(
      onTap: () async {
        setState(() {
          // TopVariable.dashboardProvider.customerSubscriptionsTilesList = [];
          // TopVariable.dashboardProvider.customerSubscriptionsTilesList.clear();
        });
        await TopVariable.dashboardProvider
            .getCustomerInverterAllowedSelection();
        await TopVariable.switchScreen("/all_inverters_screen");
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<DashboardProvider>(
          builder: (context, value, child) {
            child = Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.charging_station,
                      size: 35,
                      // color: appTheme.primaryColor,
                      color: CustomColor.grenishColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${TopVariable.dashboardProvider.selectedIds.length} ${TopVariable.dashboardProvider.selectedIds.length > 1 ? "Sites" : "Site"} selected",
                      style: const TextStyle(
                        // color: appTheme.primaryColor,
                        color: CustomColor.grenishColor,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFB6B6B6),
                )
              ],
            );
            return child;
          },
        ),
      ),
    );
  }

  Widget weatherWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Consumer<DashboardProvider>(builder: (context, value, child) {
          if (value.weatherData != null) {
            var normalTemp =
                double.parse(value.weatherData!['main']['temp'].toString()) -
                    275.15;

            var fahrenheit = Celsius.toFahrenheit(normalTemp);

            var icon = value.weatherData!['weather'][0]['icon'].toString();
            return Column(
              children: [
                Row(
                  children: [
                    Image.network(
                      value.weatherData == null
                          ? 'http://openweathermap.org/img/wn/03d@2x.png'
                          : 'http://openweathermap.org/img/wn/$icon@2x.png',
                      width: 80,
                    ),
                    value.weatherData != null
                        ? Text(fahrenheit.toStringAsFixed(0) + "°F",
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              // color: appTheme.primaryColor,
                              color: CustomColor.grenishColor,
                            ))
                        : const Text(""),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      // color: appTheme.primaryColor,
                      color: CustomColor.grenishColor,
                    ),
                    Text(
                      value.weatherData?['name'] +
                          ", " +
                          value.weatherData?["sys"]["country"],
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              TopVariable.ticketsProvider.fetchLocation();
            });
            return const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  // color: appTheme.primaryColor,
                  color: CustomColor.grenishColor,
                ),
              ),
            );
          }
        }),
        Consumer<DashboardProvider>(
          builder: (context, value, child) {
            Map<String, dynamic>? data = value.mappedResponse;
            child = Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data?['currentValue'].toString() ?? '0',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        // color: appTheme.primaryColor,
                        color: CustomColor.grenishColor,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "Watts",
                      style: TextStyle(
                        fontSize: 14,
                        // color: appTheme.primaryColor,
                        color: CustomColor.grenishColor,
                      ),
                    )
                  ],
                ),
                const Text("Current Value Today"),
                Text(
                  "${value.customerSubscriptionsTilesList.length} ${value.customerSubscriptionsTilesList.length > 1 ? 'Inverters' : 'Inverter'}",
                  // "$len ${len > 1 ? 'Inverters' : 'Inverter'}",
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            );
            return child;
          },
        )
      ],
    );
  }
  // Widget weatherWidget() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       Consumer<DashboardProvider>(builder: (context, value, child) {
  //         if (value.weatherData != null) {
  //           var temp =
  //               (double.parse(value.weatherData!['main']['temp'].toString()) -
  //                       275.15)
  //                   .toStringAsFixed(0);
  //           var icon = value.weatherData!['weather'][0]['icon'].toString();
  //           return Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Image.network(
  //                     value.weatherData == null
  //                         ? 'http://openweathermap.org/img/wn/03d@2x.png'
  //                         : 'http://openweathermap.org/img/wn/$icon@2x.png',
  //                     width: 80,
  //                   ),
  //                   value.weatherData != null
  //                       ? Text(temp + "°C",
  //                           style: const TextStyle(
  //                             fontSize: 30,
  //                             fontWeight: FontWeight.w500,
  //                             // color: appTheme.primaryColor,
  //                             color: CustomColor.grenishColor,
  //                           ))
  //                       : const Text(""),
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   const Icon(
  //                     Icons.location_on,
  //                     // color: appTheme.primaryColor,
  //                     color: CustomColor.grenishColor,
  //                   ),
  //                   Text(
  //                     value.weatherData?['name'] +
  //                         ", " +
  //                         value.weatherData?["sys"]["country"],
  //                     style: const TextStyle(fontSize: 16),
  //                   )
  //                 ],
  //               )
  //             ],
  //           );
  //         } else {
  //           return const Padding(
  //             padding: EdgeInsets.only(right: 10.0),
  //             child: SizedBox(
  //               width: 30,
  //               height: 30,
  //               child: CircularProgressIndicator(
  //                 // color: appTheme.primaryColor,
  //                 color: CustomColor.grenishColor,
  //               ),
  //             ),
  //           );
  //         }
  //       }),
  //       Consumer<DashboardProvider>(
  //         builder: (context, value, child) {
  //           Map<String, dynamic>? data = value.mappedResponse;
  //           child = Column(
  //             children: [
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   Text(
  //                     data?['currentValue'].toString() ?? '0',
  //                     style: const TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold,
  //                       // color: appTheme.primaryColor,
  //                       color: CustomColor.grenishColor,
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     width: 5,
  //                   ),
  //                   const Text(
  //                     "Watts",
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       // color: appTheme.primaryColor,
  //                       color: CustomColor.grenishColor,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               const Text("Current Value Today"),
  //               Text(
  //                 "${value.customerSubscriptionsTilesList.length} ${value.customerSubscriptionsTilesList.length > 1 ? 'Inverters' : 'Inverter'}",
  //                 // "$len ${len > 1 ? 'Inverters' : 'Inverter'}",
  //                 style: const TextStyle(color: Colors.grey),
  //               )
  //             ],
  //           );
  //           return child;
  //         },
  //       )
  //     ],
  //   );
  // }

  Widget trees() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Consumer<DashboardProvider>(
        builder: (context, value, child) {
          Map<String, dynamic>? data = value.mappedResponseTreePlanted;
          var list = [];
          if (data != null) {
            data.forEach(
                (key, val) => list.add(DashboardTreeFactorItems(key, val)));
          }
          child = value.mappedResponseTreePlanted == null
              ? const SizedBox()
              : SizedBox(
                  height: Get.height * 0.09,
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            list[index].key.toString().toUpperCase(),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.energy_savings_leaf,
                                color: CustomColor.grenishColor,
                              ),
                              Text(list[index].val ?? "",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColor.grenishColor,
                                  ))
                            ],
                          )
                        ],
                      );
                    },
                    itemCount: list.length > 6 ? 6 : list.length,
                    // pagination: const SwiperPagination(),
                    control:
                        const SwiperControl(color: CustomColor.grenishColor),
                    autoplay: false,
                  ),
                );
          return child;
        },
      ),
    );
  }

  Widget yield() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Consumer<DashboardProvider>(
        builder: (context, value, child) {
          Map<String, dynamic>? data = value.mappedResponseYield;

          child = Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpended = !_isExpended;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Yield",
                      style: TextStyle(
                        fontSize: 14,
                        // color: appTheme.primaryColor,
                        color: CustomColor.grenishColor,
                      ),
                    ),
                    Icon(
                      !_isExpended
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              !_isExpended
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: padding,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFDFEAF0),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    data?['data']['dailyYield'].toString() ??
                                        '0',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "kWh",
                                    style: TextStyle(
                                      fontSize: 14,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Text(
                              "Daily",
                              style: TextStyle(
                                fontSize: 14,
                                // color: appTheme.primaryColor,
                                color: CustomColor.grenishColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              padding: padding,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFDFEAF0),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Text(
                                    // data?['data']['dailyYield'].toString() ??
                                    '0',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "kWh",
                                    style: TextStyle(
                                      fontSize: 14,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 14,
                                // color: appTheme.primaryColor,
                                color: CustomColor.grenishColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              padding: padding,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFDFEAF0),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    data?["data"]["yearlyYield"].toString() ??
                                        '0',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "kWh",
                                    // "kV",
                                    style: TextStyle(
                                      fontSize: 14,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Text(
                              "Yearly", // System size
                              style: TextStyle(
                                fontSize: 14,
                                // color: appTheme.primaryColor,
                                color: CustomColor.grenishColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : Column(
                      children: [
                        // Container(
                        //   padding: padding,
                        //   color: const Color(0xFFDFEAF0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       const Text(
                        //         "System Size",
                        //         style: TextStyle(
                        //           fontSize: 14,
                        //           // color: appTheme.primaryColor,
                        //           color: CustomColor.grenishColor,
                        //         ),
                        //       ),
                        //       Row(
                        //         children: [
                        //           Text(
                        //             data?["sytemSize"].toString() ?? '0',
                        //             style: const TextStyle(
                        //               fontSize: 14,
                        //               // color: appTheme.primaryColor,
                        //               color: CustomColor.grenishColor,
                        //             ).copyWith(
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.w600),
                        //           ),
                        //           const Text(
                        //             " kV",
                        //             style: TextStyle(
                        //               fontSize: 14,
                        //               // color: appTheme.primaryColor,
                        //               color: CustomColor.grenishColor,
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        // Container(
                        //   padding: padding,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       const Text(
                        //         "Peak Value Today",
                        //         style: TextStyle(
                        //           fontSize: 14,
                        //           // color: appTheme.primaryColor,
                        //           color: CustomColor.grenishColor,
                        //         ),
                        //       ),
                        //       Row(
                        //         children: [
                        //           const Icon(
                        //             Icons.trending_up,
                        //             color: Colors.green,
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           Text(
                        //             data?['peakValue'].toString() ?? '0',
                        //             style: const TextStyle(
                        //               fontSize: 14,
                        //               // color: appTheme.primaryColor,
                        //               color: CustomColor.grenishColor,
                        //             ).copyWith(
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.w600,
                        //                 color: const Color(0xFF00BA66)),
                        //           ),
                        //           const Text(
                        //             " Watts",
                        //             style: TextStyle(
                        //               fontSize: 14,
                        //               // color: appTheme.primaryColor,
                        //               color: CustomColor.grenishColor,
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Container(
                          padding: padding,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Daily Yeild",
                                style: TextStyle(
                                  fontSize: 14,
                                  // color: appTheme.primaryColor,
                                  color: CustomColor.grenishColor,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: appTheme.primaryColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    data?["data"]["dailyYield"].toString() ??
                                        '0',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ).copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: appTheme.primaryColor),
                                  ),
                                  const Text(
                                    " kWh",
                                    style: TextStyle(
                                      fontSize: 14,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: padding,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Month to Date Yeild",
                                style: TextStyle(
                                  fontSize: 14,
                                  // color: appTheme.primaryColor,
                                  color: CustomColor.grenishColor,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: appTheme.primaryColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    data?["data"]['monthlyYield'].toString() ??
                                        '0',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ).copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: appTheme.primaryColor),
                                  ),
                                  const Text(
                                    " kWh",
                                    style: TextStyle(
                                      fontSize: 14,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: padding,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "year to Date Yeild",
                                style: TextStyle(
                                  fontSize: 14,
                                  // color: appTheme.primaryColor,
                                  color: CustomColor.grenishColor,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: appTheme.primaryColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    data?["data"]['yearlyYield'].toString() ??
                                        '0',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ).copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: appTheme.primaryColor),
                                  ),
                                  const Text(
                                    " kWh",
                                    style: TextStyle(
                                      fontSize: 14,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: padding,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Yeild",
                                style: TextStyle(
                                  fontSize: 14,
                                  // color: appTheme.primaryColor,
                                  color: CustomColor.grenishColor,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: appTheme.primaryColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "0.0",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ).copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: appTheme.primaryColor),
                                  ),
                                  const Text(
                                    " kWh",
                                    style: TextStyle(
                                      fontSize: 14,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ],
          );
          return child;
        },
      ),
    );
  }

  Widget graph() {
    String graphType = 'cumulative', graphPeriod = 'daily';
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.topRight,
          child: Ink.image(
            image: const AssetImage(
              'assets/expand_button.png',
            ),
            padding: EdgeInsets.zero,
            alignment: Alignment.topRight,
            fit: BoxFit.fill,
            width: 30,
            height: 30,
            child: InkWell(onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FullScreenGraph(
                    graphDate: TopVariable.dashboardProvider.selectedDate,
                    graphType: graphType,
                    graphPeriod: graphPeriod,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
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
        SizedBox(
          width: Get.width * 0.9,
          height: Get.height * 0.28,
          child: Consumer<DashboardProvider>(
              builder: (context, dashboardConsumer, child) {
            child = ProductionGraphSyncfusion(
              xAxisData: dashboardConsumer.syncfusionXAxis,
              powerDataSeries: dashboardConsumer.syncfusionPowerData,
              dailyGraph: dashboardConsumer.dailyGraph,
            );
            return child;
          }),
        ),
        SizedBox(
          width: Get.width * 0.9,
          height: Get.height * 0.05,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30.0,
                width: Get.width * 0.4,
                // height: 30.0,
                // width: screenWidth! / 2 - 20,
                child: DropdownButtonFormField<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  dropdownColor: const Color.fromRGBO(255, 255, 255, 1),
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
                          color: Color.fromRGBO(230, 86, 39, 1), width: 5.0),
                    ),
                    filled: false,
                    labelText: 'Time Period',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(230, 86, 39, 1), fontSize: 12),
                  ),
                  onChanged: (value) {
                    TopVariable.dashboardProvider
                        .onGraphTimeChanged(value ?? "");
                    setState(() {
                      graphPeriod = value ?? "";
                    });
                  },
                  hint: const Text('Daily'),
                  items: <String>['Daily', 'Monthly', 'Yearly']
                      .map<DropdownMenuItem<String>>((String value) {
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
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 30.0,
                width: Get.width * 0.4,
                // width: screenWidth / 2 - 20,
                child: DropdownButtonFormField<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  dropdownColor: const Color.fromRGBO(255, 255, 255, 1),
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
                          color: Color.fromRGBO(230, 86, 39, 1), width: 5.0),
                    ),
                    filled: false,
                    labelText: 'Graph Type',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(230, 86, 39, 1), fontSize: 12),
                  ),
                  onChanged: (value) {
                    TopVariable.dashboardProvider
                        .onGraphTypeChanged(value ?? '');
                    setState(() {
                      graphType = value ?? '';
                    });
                  },
                  hint: const Text('Cumulative'),
                  items: <String>['Cumulative', 'Comparative']
                      .map<DropdownMenuItem<String>>((String value) {
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
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class DashboardTreeFactorItems {
  dynamic key;
  dynamic val;

  DashboardTreeFactorItems(this.key, this.val);

  @override
  String toString() {
    return '{ ${this.key}, ${this.val} }';
  }
}

// before graph updation
// // ignore_for_file: unnecessary_this

// import 'package:card_swiper/card_swiper.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:location/location.dart';
// import 'package:provider/provider.dart';
// import 'package:solaramps/dataModel/user_model.dart';
// import 'package:solaramps/model_/weather_sites_model.dart';
// import 'package:solaramps/providers/dashboard_provider.dart';
// import 'package:solaramps/screens/home/home.dart';
// import 'package:solaramps/theme/color.dart';
// import 'package:solaramps/utility/shared_preference.dart';
// import 'package:solaramps/utility/top_level_variables.dart';
// import 'package:solaramps/widget/full_screen_graph.dart';
// import 'package:solaramps/widget/production_graph_syncfusion.dart';

// class NewDashboard extends StatefulWidget {
//   const NewDashboard({Key? key}) : super(key: key);

//   @override
//   State<NewDashboard> createState() => _NewDashboardState();
// }

// class _NewDashboardState extends State<NewDashboard> {
//   Location location = Location();
//   bool _isExpended = false;

//   bool? _serviceEnabled;
//   int _selectedIndex = 0;
//   PermissionStatus? _permissionGranted;
//   var selectedvaloFForeCast = 'Today';
//   // LocationData? _locationData;
//   Widget space = Container(
//     height: 1,
//     color: Colors.grey.shade300,
//   );
//   EdgeInsets padding =
//       const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5);

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       fetchLocation();
//       _selectedIndex = 0;
//       setState(() {
//         TopVariable.dashboardProvider.selectedIds.clear();
//       });
//     });
//     super.initState();
//   }

//   void fetchLocation() async {
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled!) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled!) {
//         return;
//       }
//     }

//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//     setState(() {
//       TopVariable.dashboardProvider.weatherModel.value = WeatherSitesModel();
//       TopVariable.dashboardProvider.selectedIds.clear();
//     });
//     setState(() {});
//   }

//   ScrollController scrollController = ScrollController();
//   bool isScrollDown = true;
//   Future<void> autoScroll(bool isScroll) async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     if (isScroll) {
//       scrollController.jumpTo(scrollController.position.maxScrollExtent);
//     } else {
//       scrollController.jumpTo(scrollController.position.minScrollExtent);
//     }
//     setState(() {});
//   }

//   // Dashboard
//   @override
//   Widget build(BuildContext context) {
//     UserModel user = UserPreferences.user;
//     return SafeArea(
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(200), // Set this height
//           child: appbar(user),
//         ),
//         bottomNavigationBar: bottomBar(context),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: CustomColor.grenishColor,
//           child: Icon(
//             isScrollDown ? Icons.arrow_drop_down : Icons.arrow_drop_up,
//             color: Colors.white,
//           ),
//           elevation: 12,
//           mini: true,
//           onPressed: () {
//             if (isScrollDown) {
//               autoScroll(isScrollDown);
//               setState(() {
//                 isScrollDown = false;
//               });
//             } else {
//               autoScroll(isScrollDown);
//               setState(() {
//                 isScrollDown = true;
//               });
//             }
//           },
//         ),
//         body: SingleChildScrollView(
//           controller: scrollController,
//           child: Column(
//             children: [
//               // Inverter List
//               inverterNavigate(),
//               space,

//               // Weather
//               Obx(() {
//                 return TopVariable.dashboardProvider.selectedIds.isEmpty
//                     ? weatherWidget()
//                     : Column(
//                         children: [
//                           TopVariable.dashboardProvider.selectedIds.isNotEmpty
//                               ? Container(
//                                   height: Get.height * 0.06,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     border: Border.all(
//                                       width: 1,
//                                       color: Colors.grey.shade100,
//                                     ),
//                                   ),
//                                   child: Align(
//                                     alignment: Alignment.centerRight,
//                                     child: DropdownButton<String>(
//                                       value: TopVariable.dashboardProvider
//                                                   .valueOFSelectedID.value ==
//                                               ''
//                                           ? TopVariable.dashboardProvider
//                                               .selectedIds.first
//                                           : TopVariable.dashboardProvider
//                                               .valueOFSelectedID.value,
//                                       items: TopVariable
//                                           .dashboardProvider.selectedIds
//                                           .map((String value) {
//                                         return DropdownMenuItem<String>(
//                                           value: value,
//                                           child: Text(value),
//                                         );
//                                       }).toList(),
//                                       onChanged: (value) async {
//                                         setState(() {
//                                           TopVariable
//                                               .dashboardProvider
//                                               .valueOFSelectedID
//                                               .value = value ?? "";
//                                         });
//                                         await TopVariable.dashboardProvider
//                                             .getWeatherOfSites(
//                                                 value.toString());

//                                         setState(() {});
//                                       },
//                                     ),
//                                   ),
//                                 )
//                               : const SizedBox(),
//                           TopVariable.dashboardProvider.isShowNoWeatherWidget
//                                       .value ==
//                                   true
//                               ? Container(
//                                   height: Get.height * 0.12,
//                                   padding:
//                                       const EdgeInsets.only(left: 10, right: 4),
//                                   child: Center(
//                                     child: RichText(
//                                       textAlign: TextAlign.center,
//                                       text: TextSpan(
//                                         text:
//                                             'No Weather Update Available Related to ',
//                                         style:
//                                             DefaultTextStyle.of(context).style,
//                                         children: <TextSpan>[
//                                           TextSpan(
//                                               text:
//                                                   '\n ${TopVariable.dashboardProvider.getNameOfSiteFromID(TopVariable.dashboardProvider.valueOFSelectedID.value)}',
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.bold)),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               : InkWell(
//                                   onTap: () async {
//                                     if (kDebugMode) {
//                                       print('Testing :::::: ====>');
//                                     }
//                                     await TopVariable.dashboardProvider
//                                         .getWeatherForeCastOfSites(
//                                             TopVariable.dashboardProvider
//                                                     .weatherModel.value.refId ??
//                                                 "",
//                                             '1');
//                                     setState(() {
//                                       selectedvaloFForeCast = 'Today';
//                                     });
//                                     _weatherForeCast(
//                                         TopVariable.dashboardProvider
//                                             .getNameOfSiteFromID(TopVariable
//                                                 .dashboardProvider
//                                                 .valueOFSelectedID
//                                                 .value),
//                                         TopVariable.dashboardProvider
//                                                 .weatherModel.value.state ??
//                                             "");
//                                   },
//                                   child: Container(
//                                     height: Get.height * 0.12,
//                                     padding: const EdgeInsets.only(
//                                         left: 10, right: 4),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(
//                                           width: Get.width * 0.99,
//                                           child: Row(
//                                             children: [
//                                               SvgPicture.asset(
//                                                 'assets/weather_icons/038-cloudy-3.svg',
//                                                 height: 25,
//                                                 fit: BoxFit.contain,
//                                               ),
//                                               const SizedBox(
//                                                 width: 5,
//                                               ),
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 80,
//                                                     child: Text(
//                                                       TopVariable
//                                                               .dashboardProvider
//                                                               .weatherModel
//                                                               .value
//                                                               .temperature ??
//                                                           "",
//                                                       style: const TextStyle(
//                                                         fontSize: 18,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 80,
//                                                     child: Text(
//                                                       TopVariable
//                                                               .dashboardProvider
//                                                               .weatherModel
//                                                               .value
//                                                               .wxPhraseLong ??
//                                                           "",
//                                                       style: const TextStyle(
//                                                           fontSize: 10),
//                                                       maxLines: 2,
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                               const SizedBox(
//                                                 width: 5,
//                                               ),
//                                               SizedBox(
//                                                 width: Get.width * 0.24,
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     SizedBox(
//                                                       child: RichText(
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         text: TextSpan(
//                                                           text: TopVariable
//                                                                   .dashboardProvider
//                                                                   .weatherModel
//                                                                   .value
//                                                                   .uvDescription ??
//                                                               "",
//                                                           style:
//                                                               const TextStyle(
//                                                             color: Colors.amber,
//                                                             fontSize: 14,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                           ),
//                                                           children: <TextSpan>[
//                                                             TextSpan(
//                                                               text: ' ' +
//                                                                   TopVariable
//                                                                       .dashboardProvider
//                                                                       .weatherModel
//                                                                       .value
//                                                                       .precipChance
//                                                                       .toString(),
//                                                               style:
//                                                                   const TextStyle(
//                                                                 color:
//                                                                     Colors.grey,
//                                                                 fontSize: 12,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       width: Get.width * 0.17,
//                                                       child: Row(
//                                                         children: [
//                                                           SvgPicture.asset(
//                                                             'assets/weather_icons/025-humidity.svg',
//                                                             height: 15,
//                                                             fit: BoxFit.contain,
//                                                           ),
//                                                           const Text(
//                                                             ' 0%',
//                                                             style: TextStyle(
//                                                               color:
//                                                                   Colors.grey,
//                                                               fontSize: 12,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                               const Spacer(),
//                                               SizedBox(
//                                                 width: Get.width * 0.39,
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   children: [
//                                                     SizedBox(
//                                                       width: Get.width * 0.39,
//                                                       child: Center(
//                                                         child: Text(
//                                                           TopVariable
//                                                               .dashboardProvider
//                                                               .getNameOfSiteFromID(
//                                                                   TopVariable
//                                                                       .dashboardProvider
//                                                                       .valueOFSelectedID
//                                                                       .value),
//                                                           style:
//                                                               const TextStyle(
//                                                             fontSize: 12,
//                                                             fontWeight:
//                                                                 FontWeight.w400,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       width: Get.width * 0.39,
//                                                       child: Center(
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             const Icon(
//                                                               Icons.location_on,
//                                                               size: 12,
//                                                             ),
//                                                             Text(
//                                                               TopVariable
//                                                                       .dashboardProvider
//                                                                       .weatherModel
//                                                                       .value
//                                                                       .state ??
//                                                                   "",
//                                                               maxLines: 1,
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                               style:
//                                                                   const TextStyle(
//                                                                 fontSize: 12,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w100,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                             top: 5,
//                                             left: 25,
//                                             right: 25,
//                                           ),
//                                           child: SizedBox(
//                                             height: 35,
//                                             child: RichText(
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                               text: TextSpan(
//                                                 text: 'There will be ',
//                                                 style: const TextStyle(
//                                                     color: Colors.grey,
//                                                     fontSize: 12),
//                                                 children: <TextSpan>[
//                                                   TextSpan(
//                                                     text: TopVariable
//                                                             .dashboardProvider
//                                                             .weatherModel
//                                                             .value
//                                                             .narrative ??
//                                                         "",
//                                                     // text: TopVariable
//                                                     //         .dashboardProvider
//                                                     //         .weatherModel
//                                                     //         .value['narrative'] ??
//                                                     //     "",
//                                                     style: const TextStyle(
//                                                       color: Colors.blue,
//                                                       fontSize: 13,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                         ],
//                       );
//               }),
//               const SizedBox(
//                 height: 10,
//               ),
//               space,
//               const SizedBox(
//                 height: 10,
//               ),
//               yield(),
//               TopVariable.dashboardProvider.mappedResponseYield == null
//                   ? const SizedBox()
//                   : space,
//               SizedBox(
//                 height:
//                     TopVariable.dashboardProvider.mappedResponseYield == null
//                         ? 0
//                         : 10,
//               ),
//               trees(),
//               const SizedBox(
//                 height: 10,
//               ),
//               space,
//               graph()
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// //
//   Widget bottomBar(BuildContext context) {
//     return Theme(
//         data: Theme.of(context).copyWith(
//           // canvasColor: const Color.fromRGBO(2, 87, 122, 1),
//           canvasColor: CustomColor.grenishColor,
//           textTheme: Theme.of(context).textTheme.copyWith(
//                 caption: const TextStyle(color: Colors.white),
//               ),
//         ),
//         child: BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: CustomColor.grenishColor,
//             currentIndex: 0,
//             onTap: (val) {
//               if (val == 0) {
//                 setState(() {
//                   _selectedIndex = 0;
//                 });
//                 Get.off(() => const HomeScreenTabs());
//               } else if (val == 1) {
//                 var route = ModalRoute.of(context);
//                 if (route != null) {
//                   setState(() {
//                     _selectedIndex = 1;
//                     UserPreferences.setString('showSupporttab', 'true');
//                   });
//                   if (route.settings.name != '/customer_support') {
//                     TopVariable.switchScreen("/customer_support");
//                   }
//                 }
//               } else if (val == 2) {
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Search'),
//                     content: const Text('No data available for Search'),
//                     actions: [
//                       TextButton(
//                         child: const Text('OK'),
//                         onPressed: () {
//                           Navigator.of(context).pop();

//                           Get.off(() => const NewDashboard());
//                           setState(() {
//                             _selectedIndex = 0;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               } else {
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Notifications'),
//                     content: const Text('No new notification available.'),
//                     actions: [
//                       TextButton(
//                         child: const Text('OK'),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           Get.off(() => const NewDashboard());
//                           setState(() {
//                             _selectedIndex = 0;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               setState(() {
//                 _selectedIndex = val;
//               });
//               if (kDebugMode) {
//                 print('Value :::: $val');
//                 print('_selectedIndex :::: $_selectedIndex');
//               }
//             },
//             items: [
//               BottomNavigationBarItem(
//                   icon: SvgPicture.asset(
//                     _selectedIndex != 0
//                         ? 'assets/ic_home_white.svg'
//                         : 'assets/ic_home.svg',
//                     height: 16,
//                     fit: BoxFit.fitHeight,
//                   ),
//                   label: ""),
//               BottomNavigationBarItem(
//                 icon: SvgPicture.asset(
//                   _selectedIndex != 1
//                       ? 'assets/ic_customer_support_white.svg'
//                       : 'assets/ic_customer_support.svg',
//                   height: 18,
//                   fit: BoxFit.fitHeight,
//                 ),
//                 label: "",
//               ),
//               BottomNavigationBarItem(
//                   icon: SvgPicture.asset(
//                     _selectedIndex != 2
//                         ? 'assets/ic_search_white.svg'
//                         : 'assets/ic_search.svg',
//                     height: 18,
//                     fit: BoxFit.fitHeight,
//                   ),
//                   label: ""),
//               BottomNavigationBarItem(
//                 icon: SvgPicture.asset(
//                   _selectedIndex != 3
//                       ? 'assets/ic_notification_white.svg'
//                       : 'assets/ic_notification.svg',
//                   height: 18,
//                   fit: BoxFit.fitHeight,
//                 ),
//                 label: "",
//               ),
//             ]));
//   }

//   @override
//   void dispose() {
//     TopVariable.dashboardProvider.resetAppData();
//     super.dispose();
//   }

//   Widget appbar(UserModel user) {
//     return Container(
//       height: 70,
//       // color: appTheme.primaryColor,
//       color: CustomColor.grenishColor,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//           SizedBox(
//             width: Get.width * 0.01,
//           ),
//           SizedBox(
//             width: Get.width * 0.5,
//             child: Hero(
//               tag: "userimage",
//               child: Text(
//                 // user.userName ?? '',
//                 UserPreferences.getString('userName') ?? "--",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: user.userName.toString().length > 20 ? 16 : 18),
//                 maxLines: 2,
//               ),
//             ),
//           ),
//           const Spacer(),
//           Text(
//             DateFormat.yMMMEd().format(DateTime.now()),
//             style: const TextStyle(color: Colors.white, fontSize: 14),
//           )
//         ]),
//       ),
//     );
//   }

//   void _weatherForeCast(String siteName, String location) {
//     showModalBottomSheet(
//         isDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           return StatefulBuilder(
//             builder: (context, setStateSB) {
//               return SingleChildScrollView(
//                 child: Obx(() {
//                   return Container(
//                     padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
//                     decoration: const BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10))),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Text(
//                                 'ForeCast',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Color.fromRGBO(233, 115, 65, 1)),
//                               ),
//                               const Spacer(),
//                               InkWell(
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                     setStateSB(() {});
//                                   },
//                                   child: const Icon(
//                                     Icons.cancel,
//                                     size: 20,
//                                   ))
//                             ],
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 width: Get.width * 0.39,
//                                 child: Center(
//                                   child: Text(
//                                     siteName,
//                                     style: const TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w800,
//                                         color: Color.fromRGBO(2, 87, 122, 1)),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: Get.width * 0.39,
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.location_on,
//                                           size: 12,
//                                           color: Color.fromRGBO(2, 87, 122, 1)),
//                                       Text(
//                                         location,
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w400,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   const Center(
//                                     child: Text(
//                                       'Period',
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w800,
//                                           color: Color.fromRGBO(2, 87, 122, 1)),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 5,
//                                   ),
//                                   Container(
//                                     height: Get.height * 0.038,
//                                     width: Get.width * 0.3,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(
//                                         width: 1,
//                                         color: Colors.grey.shade500,
//                                       ),
//                                     ),
//                                     child: Align(
//                                       alignment: Alignment.centerRight,
//                                       child: DropdownButton<String>(
//                                         underline: const SizedBox(),
//                                         value: selectedvaloFForeCast,
//                                         alignment: Alignment.center,
//                                         style: const TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w400,
//                                           color: Colors.black,
//                                         ),
//                                         items: [
//                                           'Today',
//                                           'This Week',
//                                           'This Month'
//                                         ].map((String value) {
//                                           return DropdownMenuItem<String>(
//                                             value: value,
//                                             child: Text(value),
//                                           );
//                                         }).toList(),
//                                         onChanged: (value) async {
//                                           setStateSB(() {
//                                             selectedvaloFForeCast = value ?? "";
//                                           });
//                                           if (selectedvaloFForeCast ==
//                                               'Today') {
//                                             setStateSB(() {
//                                               TopVariable.dashboardProvider
//                                                   .weatherForeCastModel = null;
//                                             });
//                                             await TopVariable.dashboardProvider
//                                                 .getWeatherForeCastOfSites(
//                                                     TopVariable
//                                                             .dashboardProvider
//                                                             .weatherModel
//                                                             .value
//                                                             .refId ??
//                                                         "",
//                                                     '1');
//                                           } else if (selectedvaloFForeCast ==
//                                               'This Week') {
//                                             setStateSB(() {
//                                               TopVariable.dashboardProvider
//                                                   .weatherForeCastModel = null;
//                                             });
//                                             await TopVariable.dashboardProvider
//                                                 .getWeatherForeCastOfSites(
//                                                     TopVariable
//                                                             .dashboardProvider
//                                                             .weatherModel
//                                                             .value
//                                                             .refId ??
//                                                         "",
//                                                     '7');
//                                           } else {
//                                             setStateSB(() {
//                                               TopVariable.dashboardProvider
//                                                   .weatherForeCastModel = null;
//                                             });
//                                             await TopVariable.dashboardProvider
//                                                 .getWeatherForeCastOfSites(
//                                                     TopVariable
//                                                             .dashboardProvider
//                                                             .weatherModel
//                                                             .value
//                                                             .refId ??
//                                                         "",
//                                                     '30');
//                                           }
//                                           setStateSB(() {});
//                                         },
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             children: const [
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Text(
//                                 "Time",
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w300,
//                                   color: Color.fromRGBO(
//                                     2,
//                                     87,
//                                     122,
//                                     1,
//                                   ),
//                                 ),
//                               ),
//                               Spacer(),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Text(
//                                 "Forecast",
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w300,
//                                   color: Color.fromRGBO(
//                                     2,
//                                     87,
//                                     122,
//                                     1,
//                                   ),
//                                 ),
//                               ),
//                               Spacer(),
//                               Text(
//                                 "Temperature",
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w300,
//                                   color: Color.fromRGBO(
//                                     2,
//                                     87,
//                                     122,
//                                     1,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               )
//                             ],
//                           ),
//                           Container(
//                             height: TopVariable.dashboardProvider
//                                         .isLoadingForeCast.value ||
//                                     TopVariable.dashboardProvider
//                                             .weatherForeCastModel ==
//                                         null
//                                 ? Get.height * 0.2
//                                 : Get.height * 0.44,
//                             margin: const EdgeInsets.only(top: 10),
//                             child: TopVariable
//                                     .dashboardProvider.isLoadingForeCast.value
//                                 ? Container(
//                                     height: Get.height * 0.2,
//                                     width: double.infinity,
//                                     decoration: const BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(10),
//                                         topRight: Radius.circular(10),
//                                       ),
//                                     ),
//                                     child: const Center(
//                                       child: CircularProgressIndicator(),
//                                     ),
//                                   )
//                                 : TopVariable.dashboardProvider
//                                             .weatherForeCastModel ==
//                                         null
//                                     ? Container(
//                                         height: Get.height * 0.2,
//                                         width: double.infinity,
//                                         decoration: const BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(10),
//                                             topRight: Radius.circular(10),
//                                           ),
//                                         ),
//                                         child: const Center(
//                                           child: Text(
//                                             "No Data Found",
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.w300,
//                                               color: Color.fromRGBO(
//                                                 2,
//                                                 87,
//                                                 122,
//                                                 1,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     : ListView.builder(
//                                         itemCount: TopVariable.dashboardProvider
//                                             .weatherForeCastModel.length,
//                                         shrinkWrap: true,
//                                         itemBuilder:
//                                             (BuildContext context, index) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 5, bottom: 5),
//                                             child: InkWell(
//                                                 child: Row(
//                                                   children: [
//                                                     SizedBox(
//                                                       width: Get.width * 0.3,
//                                                       child: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .start,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(
//                                                               TopVariable
//                                                                   .dashboardProvider
//                                                                   .weatherForeCastModel[
//                                                                       index]
//                                                                       ['time']
//                                                                   .toString()
//                                                                   .split(
//                                                                       ' ')[0],
//                                                               maxLines: 1,
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                               style:
//                                                                   const TextStyle(
//                                                                 fontSize: 10,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w300,
//                                                                 color: Colors
//                                                                     .black,
//                                                               )),
//                                                           Text(
//                                                               TopVariable
//                                                                   .dashboardProvider
//                                                                   .weatherForeCastModel[
//                                                                       index]
//                                                                       ['time']
//                                                                   .toString()
//                                                                   .split(
//                                                                       ' ')[1],
//                                                               maxLines: 1,
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                               style:
//                                                                   const TextStyle(
//                                                                 fontSize: 10,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w300,
//                                                                 color: Colors
//                                                                     .black,
//                                                               )),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     const Spacer(),
//                                                     Container(
//                                                       width: Get.width * 0.3,
//                                                       alignment:
//                                                           Alignment.center,
//                                                       child: Text(
//                                                           TopVariable
//                                                               .dashboardProvider
//                                                               .weatherForeCastModel[
//                                                                   index]
//                                                                   ['forecast']
//                                                               .toString(),
//                                                           maxLines: 1,
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           textAlign:
//                                                               TextAlign.start,
//                                                           style:
//                                                               const TextStyle(
//                                                             fontSize: 10,
//                                                             fontWeight:
//                                                                 FontWeight.w300,
//                                                             color: Colors.black,
//                                                           )),
//                                                     ),
//                                                     const Spacer(),
//                                                     Container(
//                                                       width: Get.width * 0.3,
//                                                       alignment:
//                                                           Alignment.center,
//                                                       child: Text(
//                                                           TopVariable
//                                                                   .dashboardProvider
//                                                                   .weatherForeCastModel[
//                                                                       index][
//                                                                       'temperature']
//                                                                   .toString() +
//                                                               ' ' +
//                                                               TopVariable
//                                                                   .dashboardProvider
//                                                                   .weatherForeCastModel[
//                                                                       index][
//                                                                       'tempDegree']
//                                                                   .toString(),
//                                                           maxLines: 1,
//                                                           textAlign:
//                                                               TextAlign.start,
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           style:
//                                                               const TextStyle(
//                                                             fontSize: 10,
//                                                             fontWeight:
//                                                                 FontWeight.w300,
//                                                             color: Colors.black,
//                                                           )),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 onTap: () {
//                                                   Navigator.pop(context);
//                                                 }),
//                                           );
//                                         }),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//               );
//             },
//           );
//         }).whenComplete(() {
//       if (kDebugMode) {
//         print('Completion ::::::::: Of Bottom Sheet');
//       }
//     });
//   }

//   Widget inverterNavigate() {
//     return InkWell(
//       onTap: () async {
//         setState(() {
//           // TopVariable.dashboardProvider.customerSubscriptionsTilesList = [];
//           // TopVariable.dashboardProvider.customerSubscriptionsTilesList.clear();
//         });
//         await TopVariable.dashboardProvider
//             .getCustomerInverterAllowedSelection();
//         await TopVariable.switchScreen("/all_inverters_screen");
//         setState(() {});
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Consumer<DashboardProvider>(
//           builder: (context, value, child) {
//             child = Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.charging_station,
//                       size: 35,
//                       // color: appTheme.primaryColor,
//                       color: CustomColor.grenishColor,
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       "${TopVariable.dashboardProvider.selectedIds.length} ${TopVariable.dashboardProvider.selectedIds.length > 1 ? "Sites" : "Site"} selected",
//                       style: const TextStyle(
//                         // color: appTheme.primaryColor,
//                         color: CustomColor.grenishColor,
//                         fontSize: 16,
//                       ),
//                     )
//                   ],
//                 ),
//                 const Icon(
//                   Icons.arrow_forward_ios,
//                   color: Color(0xFFB6B6B6),
//                 )
//               ],
//             );
//             return child;
//           },
//         ),
//       ),
//     );
//   }

//   Widget weatherWidget() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Consumer<DashboardProvider>(builder: (context, value, child) {
//           if (value.weatherData != null) {
//             var temp =
//                 (double.parse(value.weatherData!['main']['temp'].toString()) -
//                         275.15)
//                     .toStringAsFixed(0);
//             var icon = value.weatherData!['weather'][0]['icon'].toString();
//             return Column(
//               children: [
//                 Row(
//                   children: [
//                     Image.network(
//                       value.weatherData == null
//                           ? 'http://openweathermap.org/img/wn/03d@2x.png'
//                           : 'http://openweathermap.org/img/wn/$icon@2x.png',
//                       width: 80,
//                     ),
//                     value.weatherData != null
//                         ? Text(temp + "°C",
//                             style: const TextStyle(
//                               fontSize: 30,
//                               fontWeight: FontWeight.w500,
//                               // color: appTheme.primaryColor,
//                               color: CustomColor.grenishColor,
//                             ))
//                         : const Text(""),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on,
//                       // color: appTheme.primaryColor,
//                       color: CustomColor.grenishColor,
//                     ),
//                     Text(
//                       value.weatherData?['name'] +
//                           ", " +
//                           value.weatherData?["sys"]["country"],
//                       style: const TextStyle(fontSize: 16),
//                     )
//                   ],
//                 )
//               ],
//             );
//           } else {
//             return const Padding(
//               padding: EdgeInsets.only(right: 10.0),
//               child: SizedBox(
//                 width: 30,
//                 height: 30,
//                 child: CircularProgressIndicator(
//                   // color: appTheme.primaryColor,
//                   color: CustomColor.grenishColor,
//                 ),
//               ),
//             );
//           }
//         }),
//         Consumer<DashboardProvider>(
//           builder: (context, value, child) {
//             Map<String, dynamic>? data = value.mappedResponse;
//             child = Column(
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       data?['currentValue'].toString() ?? '0',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         // color: appTheme.primaryColor,
//                         color: CustomColor.grenishColor,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     const Text(
//                       "Watts",
//                       style: TextStyle(
//                         fontSize: 14,
//                         // color: appTheme.primaryColor,
//                         color: CustomColor.grenishColor,
//                       ),
//                     )
//                   ],
//                 ),
//                 const Text("Current Value Today"),
//                 Text(
//                   "${value.customerSubscriptionsTilesList.length} ${value.customerSubscriptionsTilesList.length > 1 ? 'Inverters' : 'Inverter'}",
//                   // "$len ${len > 1 ? 'Inverters' : 'Inverter'}",
//                   style: const TextStyle(color: Colors.grey),
//                 )
//               ],
//             );
//             return child;
//           },
//         )
//       ],
//     );
//   }
//   // Widget weatherWidget() {
//   //   return Row(
//   //     mainAxisAlignment: MainAxisAlignment.spaceAround,
//   //     children: [
//   //       Consumer<DashboardProvider>(builder: (context, value, child) {
//   //         if (value.weatherData != null) {
//   //           var temp =
//   //               (double.parse(value.weatherData!['main']['temp'].toString()) -
//   //                       275.15)
//   //                   .toStringAsFixed(0);
//   //           var icon = value.weatherData!['weather'][0]['icon'].toString();
//   //           return Column(
//   //             children: [
//   //               Row(
//   //                 children: [
//   //                   Image.network(
//   //                     value.weatherData == null
//   //                         ? 'http://openweathermap.org/img/wn/03d@2x.png'
//   //                         : 'http://openweathermap.org/img/wn/$icon@2x.png',
//   //                     width: 80,
//   //                   ),
//   //                   value.weatherData != null
//   //                       ? Text(temp + "°C",
//   //                           style: const TextStyle(
//   //                             fontSize: 30,
//   //                             fontWeight: FontWeight.w500,
//   //                             // color: appTheme.primaryColor,
//   //                             color: CustomColor.grenishColor,
//   //                           ))
//   //                       : const Text(""),
//   //                 ],
//   //               ),
//   //               Row(
//   //                 children: [
//   //                   const Icon(
//   //                     Icons.location_on,
//   //                     // color: appTheme.primaryColor,
//   //                     color: CustomColor.grenishColor,
//   //                   ),
//   //                   Text(
//   //                     value.weatherData?['name'] +
//   //                         ", " +
//   //                         value.weatherData?["sys"]["country"],
//   //                     style: const TextStyle(fontSize: 16),
//   //                   )
//   //                 ],
//   //               )
//   //             ],
//   //           );
//   //         } else {
//   //           return const Padding(
//   //             padding: EdgeInsets.only(right: 10.0),
//   //             child: SizedBox(
//   //               width: 30,
//   //               height: 30,
//   //               child: CircularProgressIndicator(
//   //                 // color: appTheme.primaryColor,
//   //                 color: CustomColor.grenishColor,
//   //               ),
//   //             ),
//   //           );
//   //         }
//   //       }),
//   //       Consumer<DashboardProvider>(
//   //         builder: (context, value, child) {
//   //           Map<String, dynamic>? data = value.mappedResponse;
//   //           child = Column(
//   //             children: [
//   //               Row(
//   //                 crossAxisAlignment: CrossAxisAlignment.end,
//   //                 children: [
//   //                   Text(
//   //                     data?['currentValue'].toString() ?? '0',
//   //                     style: const TextStyle(
//   //                       fontSize: 20,
//   //                       fontWeight: FontWeight.bold,
//   //                       // color: appTheme.primaryColor,
//   //                       color: CustomColor.grenishColor,
//   //                     ),
//   //                   ),
//   //                   const SizedBox(
//   //                     width: 5,
//   //                   ),
//   //                   const Text(
//   //                     "Watts",
//   //                     style: TextStyle(
//   //                       fontSize: 14,
//   //                       // color: appTheme.primaryColor,
//   //                       color: CustomColor.grenishColor,
//   //                     ),
//   //                   )
//   //                 ],
//   //               ),
//   //               const Text("Current Value Today"),
//   //               Text(
//   //                 "${value.customerSubscriptionsTilesList.length} ${value.customerSubscriptionsTilesList.length > 1 ? 'Inverters' : 'Inverter'}",
//   //                 // "$len ${len > 1 ? 'Inverters' : 'Inverter'}",
//   //                 style: const TextStyle(color: Colors.grey),
//   //               )
//   //             ],
//   //           );
//   //           return child;
//   //         },
//   //       )
//   //     ],
//   //   );
//   // }

//   Widget trees() {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Consumer<DashboardProvider>(
//         builder: (context, value, child) {
//           Map<String, dynamic>? data = value.mappedResponseTreePlanted;
//           var list = [];
//           if (data != null) {
//             data.forEach(
//                 (key, val) => list.add(DashboardTreeFactorItems(key, val)));
//           }
//           child = value.mappedResponseTreePlanted == null
//               ? const SizedBox()
//               : SizedBox(
//                   height: Get.height * 0.09,
//                   child: Swiper(
//                     itemBuilder: (BuildContext context, int index) {
//                       return Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             list[index].key.toString().toUpperCase(),
//                             style: const TextStyle(
//                               color: Colors.grey,
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.energy_savings_leaf,
//                                 color: CustomColor.grenishColor,
//                               ),
//                               Text(list[index].val ?? "",
//                                   style: const TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: CustomColor.grenishColor,
//                                   ))
//                             ],
//                           )
//                         ],
//                       );
//                     },
//                     itemCount: list.length > 6 ? 6 : list.length,
//                     // pagination: const SwiperPagination(),
//                     control: const SwiperControl(),
//                     autoplay: false,
//                   ),
//                 );
//           return child;
//         },
//       ),
//     );
//   }

//   Widget yield() {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Consumer<DashboardProvider>(
//         builder: (context, value, child) {
//           Map<String, dynamic>? data = value.mappedResponseYield;

//           child = Column(
//             children: [
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     _isExpended = !_isExpended;
//                   });
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Yield",
//                       style: TextStyle(
//                         fontSize: 14,
//                         // color: appTheme.primaryColor,
//                         color: CustomColor.grenishColor,
//                       ),
//                     ),
//                     Icon(
//                       !_isExpended
//                           ? Icons.keyboard_arrow_down
//                           : Icons.keyboard_arrow_up,
//                       color: Colors.grey,
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               !_isExpended
//                   ? Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           children: [
//                             Container(
//                               padding: padding,
//                               decoration: BoxDecoration(
//                                   color: const Color(0xFFDFEAF0),
//                                   borderRadius: BorderRadius.circular(4)),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     data?['data']['dailyYield'].toString() ??
//                                         '0',
//                                     style: const TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 5,
//                                   ),
//                                   const Text(
//                                     "kWh",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             const Text(
//                               "Daily",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 // color: appTheme.primaryColor,
//                                 color: CustomColor.grenishColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Container(
//                               padding: padding,
//                               decoration: BoxDecoration(
//                                   color: const Color(0xFFDFEAF0),
//                                   borderRadius: BorderRadius.circular(4)),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: const [
//                                   Text(
//                                     // data?['data']['dailyYield'].toString() ??
//                                     '0',
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     "kWh",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             const Text(
//                               "Total",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 // color: appTheme.primaryColor,
//                                 color: CustomColor.grenishColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Container(
//                               padding: padding,
//                               decoration: BoxDecoration(
//                                   color: const Color(0xFFDFEAF0),
//                                   borderRadius: BorderRadius.circular(4)),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     data?["data"]["yearlyYield"].toString() ??
//                                         '0',
//                                     style: const TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 5,
//                                   ),
//                                   const Text(
//                                     "kWh",
//                                     // "kV",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             const Text(
//                               "Yearly", // System size
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 // color: appTheme.primaryColor,
//                                 color: CustomColor.grenishColor,
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     )
//                   : Column(
//                       children: [
//                         // Container(
//                         //   padding: padding,
//                         //   color: const Color(0xFFDFEAF0),
//                         //   child: Row(
//                         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         //     children: [
//                         //       const Text(
//                         //         "System Size",
//                         //         style: TextStyle(
//                         //           fontSize: 14,
//                         //           // color: appTheme.primaryColor,
//                         //           color: CustomColor.grenishColor,
//                         //         ),
//                         //       ),
//                         //       Row(
//                         //         children: [
//                         //           Text(
//                         //             data?["sytemSize"].toString() ?? '0',
//                         //             style: const TextStyle(
//                         //               fontSize: 14,
//                         //               // color: appTheme.primaryColor,
//                         //               color: CustomColor.grenishColor,
//                         //             ).copyWith(
//                         //                 fontSize: 16,
//                         //                 fontWeight: FontWeight.w600),
//                         //           ),
//                         //           const Text(
//                         //             " kV",
//                         //             style: TextStyle(
//                         //               fontSize: 14,
//                         //               // color: appTheme.primaryColor,
//                         //               color: CustomColor.grenishColor,
//                         //             ),
//                         //           )
//                         //         ],
//                         //       ),
//                         //     ],
//                         //   ),
//                         // ),
//                         // const SizedBox(
//                         //   height: 5,
//                         // ),
//                         // Container(
//                         //   padding: padding,
//                         //   child: Row(
//                         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         //     children: [
//                         //       const Text(
//                         //         "Peak Value Today",
//                         //         style: TextStyle(
//                         //           fontSize: 14,
//                         //           // color: appTheme.primaryColor,
//                         //           color: CustomColor.grenishColor,
//                         //         ),
//                         //       ),
//                         //       Row(
//                         //         children: [
//                         //           const Icon(
//                         //             Icons.trending_up,
//                         //             color: Colors.green,
//                         //           ),
//                         //           const SizedBox(
//                         //             width: 5,
//                         //           ),
//                         //           Text(
//                         //             data?['peakValue'].toString() ?? '0',
//                         //             style: const TextStyle(
//                         //               fontSize: 14,
//                         //               // color: appTheme.primaryColor,
//                         //               color: CustomColor.grenishColor,
//                         //             ).copyWith(
//                         //                 fontSize: 16,
//                         //                 fontWeight: FontWeight.w600,
//                         //                 color: const Color(0xFF00BA66)),
//                         //           ),
//                         //           const Text(
//                         //             " Watts",
//                         //             style: TextStyle(
//                         //               fontSize: 14,
//                         //               // color: appTheme.primaryColor,
//                         //               color: CustomColor.grenishColor,
//                         //             ),
//                         //           )
//                         //         ],
//                         //       ),
//                         //     ],
//                         //   ),
//                         // ),
//                         Container(
//                           padding: padding,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "Daily Yeild",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   // color: appTheme.primaryColor,
//                                   color: CustomColor.grenishColor,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.trending_up,
//                                     color: appTheme.primaryColor,
//                                   ),
//                                   const SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     data?["data"]["dailyYield"].toString() ??
//                                         '0',
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ).copyWith(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                         color: appTheme.primaryColor),
//                                   ),
//                                   const Text(
//                                     " kWh",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: padding,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "Month to Date Yeild",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   // color: appTheme.primaryColor,
//                                   color: CustomColor.grenishColor,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.trending_up,
//                                     color: appTheme.primaryColor,
//                                   ),
//                                   const SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     data?["data"]['monthlyYield'].toString() ??
//                                         '0',
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ).copyWith(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                         color: appTheme.primaryColor),
//                                   ),
//                                   const Text(
//                                     " kWh",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: padding,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "year to Date Yeild",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   // color: appTheme.primaryColor,
//                                   color: CustomColor.grenishColor,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.trending_up,
//                                     color: appTheme.primaryColor,
//                                   ),
//                                   const SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     data?["data"]['yearlyYield'].toString() ??
//                                         '0',
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ).copyWith(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                         color: appTheme.primaryColor),
//                                   ),
//                                   const Text(
//                                     " kWh",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: padding,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "Total Yeild",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   // color: appTheme.primaryColor,
//                                   color: CustomColor.grenishColor,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.trending_up,
//                                     color: appTheme.primaryColor,
//                                   ),
//                                   const SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     "0.0",
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ).copyWith(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                         color: appTheme.primaryColor),
//                                   ),
//                                   const Text(
//                                     " kWh",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       // color: appTheme.primaryColor,
//                                       color: CustomColor.grenishColor,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//             ],
//           );
//           return child;
//         },
//       ),
//     );
//   }

//   Widget graph() {
//     String graphType = 'cumulative', graphPeriod = 'daily';
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.only(right: 20),
//           alignment: Alignment.topRight,
//           child: Ink.image(
//             image: const AssetImage(
//               'assets/expand_button.png',
//             ),
//             padding: EdgeInsets.zero,
//             alignment: Alignment.topRight,
//             fit: BoxFit.fill,
//             width: 30,
//             height: 30,
//             child: InkWell(onTap: () {
//               Navigator.push(
//                 context,
//                 PageRouteBuilder(
//                   pageBuilder: (context, animation, secondaryAnimation) =>
//                       FullScreenGraph(
//                     graphDate: TopVariable.dashboardProvider.selectedDate,
//                     graphType: graphType,
//                     graphPeriod: graphPeriod,
//                   ),
//                   transitionsBuilder:
//                       (context, animation, secondaryAnimation, child) {
//                     const begin = Offset(0.0, 1.0);
//                     const end = Offset.zero;
//                     const curve = Curves.ease;

//                     var tween = Tween(begin: begin, end: end)
//                         .chain(CurveTween(curve: curve));

//                     return SlideTransition(
//                       position: animation.drive(tween),
//                       child: child,
//                     );
//                   },
//                 ),
//               );
//             }),
//           ),
//         ),
//         SizedBox(
//           width: Get.width * 0.9,
//           height: Get.height * 0.28,
//           child: Consumer<DashboardProvider>(
//               builder: (context, dashboardConsumer, child) {
//             child = ProductionGraphSyncfusion(
//               xAxisData: dashboardConsumer.syncfusionXAxis,
//               powerDataSeries: dashboardConsumer.syncfusionPowerData,
//               dailyGraph: dashboardConsumer.dailyGraph,
//             );
//             return child;
//           }),
//         ),
//         SizedBox(
//           width: Get.width * 0.9,
//           height: Get.height * 0.05,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 30.0,
//                 width: Get.width * 0.45,
//                 // height: 30.0,
//                 // width: screenWidth! / 2 - 20,
//                 child: DropdownButtonFormField<String>(
//                   icon: const Icon(Icons.arrow_drop_down),
//                   dropdownColor: const Color.fromRGBO(255, 255, 255, 1),
//                   style: const TextStyle(
//                       fontSize: 12,
//                       color: Color.fromRGBO(0, 0, 0, 1),
//                       fontWeight: FontWeight.bold),
//                   decoration: const InputDecoration(
//                     isDense: true,
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 5,
//                       horizontal: 10,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(
//                           color: Color.fromRGBO(230, 86, 39, 1), width: 5.0),
//                     ),
//                     filled: false,
//                     labelText: 'Time Period',
//                     labelStyle: TextStyle(
//                         color: Color.fromRGBO(230, 86, 39, 1), fontSize: 12),
//                   ),
//                   onChanged: (value) {
//                     TopVariable.dashboardProvider
//                         .onGraphTimeChanged(value ?? "");
//                     setState(() {
//                       graphPeriod = value ?? "";
//                     });
//                   },
//                   hint: const Text('Daily'),
//                   items: <String>['Daily', 'Monthly', 'Yearly']
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Row(
//                         children: [
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           Text(value)
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               SizedBox(
//                 height: 30.0,
//                 width: Get.width * 0.45,
//                 // width: screenWidth / 2 - 20,
//                 child: DropdownButtonFormField<String>(
//                   icon: const Icon(Icons.arrow_drop_down),
//                   dropdownColor: const Color.fromRGBO(255, 255, 255, 1),
//                   style: const TextStyle(
//                       fontSize: 12,
//                       color: Color.fromRGBO(0, 0, 0, 1),
//                       fontWeight: FontWeight.bold),
//                   decoration: const InputDecoration(
//                     isDense: true,
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 5,
//                       horizontal: 10,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(
//                           color: Color.fromRGBO(230, 86, 39, 1), width: 5.0),
//                     ),
//                     filled: false,
//                     labelText: 'Graph Type',
//                     labelStyle: TextStyle(
//                         color: Color.fromRGBO(230, 86, 39, 1), fontSize: 12),
//                   ),
//                   onChanged: (value) {
//                     TopVariable.dashboardProvider
//                         .onGraphTypeChanged(value ?? '');
//                     setState(() {
//                       graphType = value ?? '';
//                     });
//                   },
//                   hint: const Text('Cumulative'),
//                   items: <String>['Cumulative', 'Comparative']
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Row(
//                         children: [
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           Text(value)
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class DashboardTreeFactorItems {
//   dynamic key;
//   dynamic val;

//   DashboardTreeFactorItems(this.key, this.val);

//   @override
//   String toString() {
//     return '{ ${this.key}, ${this.val} }';
//   }
// }
