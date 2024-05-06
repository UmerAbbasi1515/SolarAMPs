import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/gen/assets.gen.dart';
import 'package:solaramps/providers/general_provider.dart';
import 'package:solaramps/providers/home_screen_provider.dart';
import 'package:solaramps/providers/tickets_provider.dart';
import 'package:solaramps/utility/constants.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import 'package:solaramps/widget/bottom_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:solaramps/widget/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Location location = Location();

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  VideoPlayerController? controller;

  @override
  void initState() {
    TopVariable.homeScreenProvider.getSliderImages();
    TopVariable.ticketsProvider.getAllTickets();
    fetchLocation();
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
    _locationData = await location.getLocation();
    TopVariable.dashboardProvider.fetchWeatherData(
        _locationData!.latitude!.toString(),
        _locationData!.longitude!.toString(),'true');
  }

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const HomeHeader(),
              Consumer(builder: (context, HomeScreenProvider v, c) {
                if (v.sliderImages != null) {
                  c = CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      autoPlay: true,
                    ),
                    items: v.sliderImages!.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: i.url!.contains("mp4")
                                  ? VideoPlayer(
                                      VideoPlayerController.network(i.url!))
                                  : Image.network(i.url!, fit: BoxFit.fill));
                        },
                      );
                    }).toList(),
                  );
                } else {
                  c = Image.asset("assets/slider_temp.png");
                }
                return c;
              }),
              const SizedBox(
                height: 10,
              ),
              UserPreferences.user.userType != "CUSTOMER"
                  ? Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                spreadRadius: 3)
                          ]),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Power Monitoring",
                                    style: TextStyle(
                                        color: appTheme.colorScheme.primary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    "Analyze your system power",
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.grey)
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.timeline,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "26.7",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "kWh",
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Text("Daily yeild".toUpperCase())
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.trending_up,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "45.89",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Watts",
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Text("Peak value today".toUpperCase())
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.solar_power,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "1200",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "kV",
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Text("System Size".toUpperCase())
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  : Container(),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 3)
                ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Community Solar Garden",
                              style: TextStyle(
                                  color: appTheme.colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "Analyze your system power",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey)
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "0",
                              style: TextStyle(color: Colors.green),
                            ),
                            Text("Solar Credits".toUpperCase())
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "0",
                              style: TextStyle(color: Colors.blue),
                            ),
                            Text("Billed Amounts".toUpperCase())
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "0",
                              style: TextStyle(color: Colors.blue),
                            ),
                            Text("Paid Amounts".toUpperCase())
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: screenHeight! / 6,
                            color: appTheme.colorScheme.primary,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "0",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "Active Subscriptions".toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: UserPreferences.user.userType == "CUSTOMER"
                              ? Container(
                                  height: screenHeight! / 6,
                                  color: Colors.grey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "0",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "Total Bills".toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  height: screenHeight! / 6,
                                  color: appTheme.colorScheme.primary,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "0",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "Alerts / Messages".toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    UserPreferences.user.userType == "CUSTOMER"
                        ? Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: screenHeight! / 6,
                                  color: Colors.grey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "0",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "Payments till date".toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                height: screenHeight! / 6,
                                color: appTheme.colorScheme.primary,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "0",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Alerts / Messages".toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              )),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 3)
                ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.book_online),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Tickets",
                              style: TextStyle(
                                  color: appTheme.colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Consumer<TicketsProvider>(
                            builder: (context, tp, child) {
                          return InkWell(
                            onTap: () =>
                                TopVariable.switchScreen("/customer_support"),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                tp.allTickets.isNotEmpty
                                    ? Text(
                                        "${tp.allTickets.where((element) => element.status.toLowerCase() == "open").length} Active Tickets",
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      )
                                    : const Text(
                                        "0 Tickets",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(Icons.arrow_forward_ios,
                                    color: Colors.grey)
                              ],
                            ),
                          );
                        }),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
