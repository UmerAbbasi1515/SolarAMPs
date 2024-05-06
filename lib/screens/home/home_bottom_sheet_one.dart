// ignore_for_file: invalid_use_of_protected_member
import 'package:card_swiper/card_swiper.dart';
import 'package:conversion_units/conversion_units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/dataModel/user_model.dart';
import 'package:solaramps/providers/dashboard_provider.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';

class HomeScreenBottomSheetOne extends StatefulWidget {
  const HomeScreenBottomSheetOne({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreenBottomSheetOne> createState() =>
      _HomeScreenBottomSheetOneState();
}

class _HomeScreenBottomSheetOneState extends State<HomeScreenBottomSheetOne> {
  UserModel user = UserPreferences.user;

  int heightOfGrid = 0;
  // bool? _serviceEnabled;
  // Location location = Location();
  // PermissionStatus? _permissionGranted;
  // LocationData? _locationData;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TopVariable.ticketsProvider.fetchLocation();
    });
    super.initState();
  }

  //   void fetchLocation() async {
  //   // // getAllTickets
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     TopVariable.ticketsProvider.getAllTickets();
  //     TopVariable.ticketsProvider
  //         .getCompanyImagesLike(UserPreferences.compName);
  //     setState(() {});
  //   });
  //   // Three Planted Factor
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //     await TopVariable.ticketsProvider
  //         .getCustomerInverterListForNewBottomSheet();
  //   });
  //   if (Platform.isAndroid) {
  //     if (kDebugMode) {
  //       print('Fetching Location for Weather Data :::::::::::: ');
  //     }
  //     _serviceEnabled = await location.serviceEnabled();
  //     if (kDebugMode) {
  //       print(
  //           'Fetching Location for _serviceEnabled 1:::::::::::: $_serviceEnabled');
  //       print(
  //           'Fetching Location for _serviceEnabled 2:::::::::::: ${!_serviceEnabled!}');
  //     }
  //     if (!_serviceEnabled!) {
  //       _serviceEnabled = await location.requestService();
  //       if (!_serviceEnabled!) {
  //         Get.snackbar('error', '_serviceEnabled issue',
  //             backgroundColor: Colors.red);
  //         return;
  //       }
  //     }

  //     _permissionGranted = await location.hasPermission();
  //     if (kDebugMode) {
  //       print(
  //           'Fetching Location for _permissionGranted 1:::::::::::: $_permissionGranted');
  //       print(
  //           'Fetching Location for _permissionGranted 2:::::::::::: ${_permissionGranted == PermissionStatus.denied}');
  //     }
  //     if (_permissionGranted == PermissionStatus.denied) {
  //       _permissionGranted = await location.requestPermission();
  //       if (_permissionGranted != PermissionStatus.granted) {
  //         Get.snackbar('error', '_permissionGranted issue',
  //             backgroundColor: Colors.red);
  //         return;
  //       }
  //     }

  //     if (kDebugMode) {
  //       print(
  //           'Fetching Location for _locationData 1:::::::::::: ${location.getLocation()}');
  //       print(
  //           'Fetching Location for _locationData 2:::::::::::: $_locationData');
  //     }
  //     _locationData = await location.getLocation();

  //     if (kDebugMode) {
  //       print(
  //           'Fetching Location for _locationData 3:::::::::::: $_locationData');
  //       print(
  //           'Fetching Location for _locationData 4:::::::::::: ${_locationData!.latitude} ${_locationData!.longitude}');
  //     }

  //     await TopVariable.dashboardProvider.fetchWeatherData(
  //         _locationData!.latitude!.toString(),
  //         _locationData!.longitude!.toString(),
  //         'false');
  //     setState(() {});
  //   } else {
  //     var position = await GeolocatorPlatform.instance
  //         .getCurrentPosition(locationSettings: const LocationSettings());
  //     if (kDebugMode) {
  //       print('Fetching Location for _locationData 3:::::::::::: $position');
  //       print(
  //           'Fetching Location for _locationData 4:::::::::::: ${position.latitude} ${position.longitude}');
  //     }

  //     await TopVariable.dashboardProvider.fetchWeatherData(
  //         position.latitude.toString(), position.longitude.toString(), 'false');
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var imagesList = UserPreferences.imagerUrlGet;

    if (imagesList.isEmpty) {
      imagesList.add(
          'https://cdn.britannica.com/85/162485-050-7670426D/Solar-panel-array-rooftop.jpg');
    }

    if (!TopVariable.ticketsProvider.isLoadingForGetTickets.value) {
      setState(() {});
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      body: Obx(() {
        return TopVariable.ticketsProvider.isLoadingForJustObs.value
            ? const SizedBox()
            : Column(
                children: [
                  // APPbar
                  appbar(user),
                  Stack(
                    children: [
                      // SWIPER
                      Container(
                        height: Get.height * 0.3,
                        width: double.infinity,
                        color: CustomColor.grenishColor.withOpacity(0.85),
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(
                              imagesList[index].toString().trim(),
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            );
                          },
                          itemCount: imagesList.length, //5,
                          // pagination: const SwiperPagination(),
                          // control: const SwiperControl(),
                          autoplay: imagesList.length == 1 ? false : true,
                        ),
                      ),
                      // Top 2 cards
                      // TREES and CO REDUCTION
                      TopVariable.ticketsProvider.isLoadingForTreePlanted.value
                          ? Padding(
                              padding: EdgeInsets.only(top: Get.height * 0.2),
                              child: SizedBox(
                                height: Get.height * 0.1,
                                width: Get.height * 0.9,
                                child: Container(
                                  height: Get.height * 0.08,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    // color: const Color.fromRGBO(27, 194, 118, 1),
                                    color: CustomColor.grenishColor,

                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : !TopVariable.ticketsProvider.isShowWidget.value
                              ? const SizedBox()
                              : Padding(
                                  padding:
                                      EdgeInsets.only(top: Get.height * 0.248),
                                  child: SizedBox(
                                    height: Get.height * 0.1,
                                    width: Get.height * 0.9,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Swiper(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            height: Get.height * 0.08,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(27, 194, 118, 1),
                                              color: TopVariable
                                                          .ticketsProvider
                                                          .listOfTreePlanted
                                                          .value[index]
                                                          .key ==
                                                      'co2Reduction'
                                                  ? const Color.fromRGBO(
                                                      23, 47, 73, 1)
                                                  : CustomColor.grenishColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    TopVariable
                                                                .ticketsProvider
                                                                .listOfTreePlanted
                                                                .value[index]
                                                                .key ==
                                                            'co2Reduction'
                                                        ? SvgPicture.asset(
                                                            'assets/ic_co2_reduction.svg',
                                                            height: Get.height *
                                                                0.023,
                                                            width: Get.height *
                                                                0.023,
                                                            fit: BoxFit
                                                                .fitHeight,
                                                          )
                                                        : SizedBox(
                                                            height: Get.height *
                                                                0.023,
                                                            width: Get.height *
                                                                0.023,
                                                            child: Image.asset(
                                                                'assets/tree_1.png'),
                                                          ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          ' ' +
                                                              TopVariable
                                                                  .ticketsProvider
                                                                  .listOfTreePlanted
                                                                  .value[index]
                                                                  .val
                                                                  .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18),
                                                        ),
                                                        Text(
                                                          TopVariable
                                                                  .ticketsProvider
                                                                  .listOfTreePlanted
                                                                  .value[index]
                                                                  .key ??
                                                              "",
                                                          style: TextStyle(
                                                            color: TopVariable
                                                                        .ticketsProvider
                                                                        .listOfTreePlanted
                                                                        .value[
                                                                            index]
                                                                        .key ==
                                                                    'co2Reduction'
                                                                ? const Color
                                                                        .fromRGBO(
                                                                    253,
                                                                    204,
                                                                    104,
                                                                    1)
                                                                : const Color
                                                                        .fromRGBO(
                                                                    175,
                                                                    255,
                                                                    219,
                                                                    1),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        itemCount: TopVariable
                                                    .ticketsProvider
                                                    .listOfTreePlanted
                                                    .value
                                                    .length >
                                                6
                                            ? 6
                                            : TopVariable.ticketsProvider
                                                .listOfTreePlanted.value.length,
                                        control: const SwiperControl(
                                            color: Colors.white54),
                                        autoplay: false,
                                      ),
                                    ),
                                  ),
                                ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: Get.height * 0.25),
                      //   child: Row(
                      //     children: [
                      //       SizedBox(
                      //         width: Get.width * 0.05,
                      //       ),
                      //       Container(
                      //         height: Get.height * 0.084,
                      //         width: Get.width * 0.42,
                      //         decoration: BoxDecoration(
                      //           // color: const Color.fromRGBO(27, 194, 118, 1),
                      //           color: CustomColor.grenishColor,
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           children: [
                      //             Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               crossAxisAlignment: CrossAxisAlignment.center,
                      //               children: [
                      //                 SizedBox(
                      //                     height: Get.height * 0.03,
                      //                     width: Get.height * 0.03,
                      //                     child: Image.asset('assets/tree_1.png')),
                      //                 const Text(
                      //                   "  1087.56",
                      //                   style: TextStyle(
                      //                     color: Color.fromRGBO(175, 255, 219, 1),
                      //                     fontSize: 17,
                      //                     fontWeight: FontWeight.bold,
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //             const SizedBox(
                      //               height: 5,
                      //             ),
                      //             const Text(
                      //               "TREES PLANTED FACTOR",
                      //               style: TextStyle(color: Colors.white, fontSize: 10),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: Get.width * 0.05,
                      //       ),
                      //       Container(
                      //         height: Get.height * 0.084,
                      //         width: Get.width * 0.42,
                      //         decoration: BoxDecoration(
                      //             // color: const Color.fromRGBO(23, 47, 73, 1),
                      //             color: CustomColor.grenishColor,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           children: [
                      //             Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               crossAxisAlignment: CrossAxisAlignment.center,
                      //               children: [
                      //                 SizedBox(
                      //                     height: Get.height * 0.03,
                      //                     width: Get.height * 0.035,
                      //                     child: Image.asset(
                      //                       'assets/reduction_1.png',
                      //                       fit: BoxFit.fill,
                      //                     )),
                      //                 const Text(
                      //                   "  1457.04 lb",
                      //                   style: TextStyle(
                      //                     color: Color.fromRGBO(253, 204, 104, 1),
                      //                     fontSize: 17,
                      //                     fontWeight: FontWeight.bold,
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //             const SizedBox(
                      //               height: 5,
                      //             ),
                      //             const Text(
                      //               "CO REDUCTION",
                      //               style: TextStyle(color: Colors.white, fontSize: 10),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: Get.width * 0.05,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Column(
                            children: [
                              Container(
                                width: Get.width * 0.93,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 211, 205, 205),
                                      width: 0.5),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    await TopVariable.switchScreenAndRemoveAll(
                                        '/new_dashboard');
                                    setState(() {});
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: Get.width * 0.04,
                                                bottom: Get.width * 0.02,
                                                right: Get.width * 0.022),
                                            child: const Text(
                                              'Power Monitoring',
                                              style: TextStyle(
                                                  // color: Color.fromRGBO(
                                                  //     2, 87, 122, 1),
                                                  color:
                                                      CustomColor.grenishColor,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: Get.width * 0.05,
                                                bottom: Get.width * 0.02,
                                                right: Get.width * 0.022),
                                            child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: const Color.fromRGBO(
                                                  156, 156, 156, 1),
                                              size: Get.height * 0.027,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.01,
                                        // height: Get.height * 0.009,
                                      ),
                                      // ListView.builder(
                                      //     padding: EdgeInsets.zero,
                                      //     physics: const NeverScrollableScrollPhysics(),
                                      //     itemCount: 2,
                                      //     shrinkWrap: true,
                                      //     itemBuilder: (context, i) {
                                      //       return Column(
                                      //         children: [
                                      //           InkWell(
                                      //               onTap: () async {
                                      //                 await TopVariable
                                      //                     .switchScreenAndRemoveAll(
                                      //                         '/new_dashboard');
                                      //                 setState(() {});
                                      //               },
                                      //               child: Row(
                                      //                 mainAxisAlignment:
                                      //                     MainAxisAlignment.spaceAround,
                                      //                 children: const [
                                      //                   PowerMonitoringColumnWidget(
                                      //                     image:
                                      //                         'assets/ic_graph_points.png',
                                      //                     title: 'DAILY YEILD',
                                      //                     unit: '  kWh',
                                      //                     value: '26.7',
                                      //                     colorVal:
                                      //                         CustomColor.grenishColor,
                                      //                     // colorVal: Color.fromRGBO(
                                      //                     //     57, 182, 255, 1),
                                      //                   ),
                                      //                   PowerMonitoringColumnWidget(
                                      //                     image: 'assets/ic_peak.png',
                                      //                     title: 'PEAK VALUE TODAY',
                                      //                     unit: '  Watts',
                                      //                     value: '45.89',
                                      //                     colorVal:
                                      //                         CustomColor.grenishColor,
                                      //                     // colorVal: Color.fromRGBO(
                                      //                     //     57, 182, 255, 1),
                                      //                   ),
                                      //                   PowerMonitoringColumnWidget(
                                      //                     image:
                                      //                         'assets/ic_solar_size.png',
                                      //                     title: 'SYSTEM SIZE',
                                      //                     unit: '  KV',
                                      //                     value: '1200',
                                      //                     colorVal:
                                      //                         CustomColor.grenishColor,
                                      //                     // colorVal:
                                      //                     //     Color.fromRGBO(2, 87, 122, 1),
                                      //                   ),
                                      //                 ],
                                      //               )),
                                      //           i == 1
                                      //               ? const SizedBox(
                                      //                   height: 5,
                                      //                 )
                                      //               : const Divider()
                                      //         ],
                                      //       );
                                      //     }),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                                // height: 10,
                              )
                            ],
                          ),

                          // Power Monitoring
                          SizedBox(
                            height: Get.height * 0.0,
                          ),

                          // Community Solar Garden
                          // Container(
                          //   width: Get.width * 0.93,
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(10),
                          //     border: Border.all(
                          //         color: const Color.fromARGB(255, 211, 205, 205),
                          //         width: 0.5),
                          //   ),
                          //   child: Column(
                          //     children: [
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.start,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Padding(
                          //             padding: EdgeInsets.only(
                          //                 top: Get.width * 0.022,
                          //                 left: Get.width * 0.022),
                          //             child: Column(
                          //               mainAxisAlignment: MainAxisAlignment.start,
                          //               crossAxisAlignment: CrossAxisAlignment.start,
                          //               children: [
                          //                 const Text(
                          //                   'Community Solar Garden',
                          //                   style: TextStyle(
                          //                       // color: Color.fromRGBO(
                          //                       //     2, 87, 122, 1),
                          //                       color: CustomColor.grenishColor,
                          //                       fontSize: 13),
                          //                 ),
                          //                 const SizedBox(
                          //                   width: 10,
                          //                 ),
                          //                 Text(
                          //                   // UserPreferences.user.firstName ?? "",
                          //                   user.userName ??
                          //                       'Analyze your system power',
                          //                   style: const TextStyle(
                          //                     color: Color.fromRGBO(156, 156, 156, 1),
                          //                     fontSize: 9,
                          //                   ),
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //           const Spacer(),
                          //           Padding(
                          //             padding: EdgeInsets.only(
                          //                 top: Get.width * 0.05,
                          //                 right: Get.width * 0.022),
                          //             child: Icon(
                          //               Icons.arrow_forward_ios_outlined,
                          //               color: const Color.fromRGBO(156, 156, 156, 1),
                          //               size: Get.height * 0.027,
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //       SizedBox(
                          //         height: Get.height * 0.009,
                          //       ),
                          //       ListView.builder(
                          //           padding: EdgeInsets.zero,
                          //           shrinkWrap: true,
                          //           itemCount: 2,
                          //           physics: const NeverScrollableScrollPhysics(),
                          //           itemBuilder: (context, i) {
                          //             return Column(
                          //               children: [
                          //                 Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceAround,
                          //                   children: const [
                          //                     CoummintySOlarGardenColumnWidget(
                          //                       image: 'assets/ic_graph_points.png',
                          //                       title: 'SOLAR CREDITS',
                          //                       unit: '',
                          //                       value: '\$506.78',
                          //                       colorVal:
                          //                           Color.fromRGBO(0, 186, 102, 1),
                          //                     ),
                          //                     CoummintySOlarGardenColumnWidget(
                          //                       image: 'assets/ic_peak.png',
                          //                       title: 'BILLED AMOUNTS',
                          //                       unit: '',
                          //                       value: '\$2932.67',
                          //                       colorVal: CustomColor.grenishColor,
                          //                       // colorVal:
                          //                       //     Color.fromRGBO(57, 182, 255, 1),
                          //                     ),
                          //                     CoummintySOlarGardenColumnWidget(
                          //                       image: 'assets/ic_solar_size.png',
                          //                       title: 'PAID AMOUNTS',
                          //                       unit: '',
                          //                       value: '\$5499.32',
                          //                       colorVal: CustomColor.grenishColor,
                          //                       // colorVal:
                          //                       //     Color.fromRGBO(57, 182, 255, 1),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 i == 1
                          //                     ? const SizedBox(
                          //                         height: 5,
                          //                       )
                          //                     : const Divider()
                          //               ],
                          //             );
                          //           })
                          //     ],
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Grid
                          Obx(() {
                            return TopVariable.ticketsProvider
                                    .isLoadingForGetTickets.value
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(top: Get.height * 0.05),
                                    child: SizedBox(
                                      height: Get.height * 0.3,
                                      width: Get.height * 0.9,
                                      child: Container(
                                        height: Get.height * 0.08,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          // color: const Color.fromRGBO(27, 194, 118, 1),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                        left: Get.width * 0.05,
                                        right: Get.width * 0.05),
                                    child: SizedBox(
                                      child: GridView.count(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 3 / 1.6,
                                        children: List.generate(
                                            TopVariable.ticketsProvider.gridList
                                                .value.length, (index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                color: TopVariable
                                                                .ticketsProvider
                                                                .gridList
                                                                .value[index]
                                                                .title
                                                                .toString() ==
                                                            'ACTIVE SUBSCRIPTIONS' ||
                                                        TopVariable
                                                                .ticketsProvider
                                                                .gridList
                                                                .value[index]
                                                                .title
                                                                .toString() ==
                                                            'MESSAGES'
                                                    ? CustomColor.grenishColor
                                                    : const Color.fromRGBO(
                                                        183, 183, 183, 1),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                FittedBox(
                                                  child: Text(
                                                      TopVariable
                                                          .ticketsProvider
                                                          .gridList
                                                          .value[index]
                                                          .val
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      )),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    TopVariable
                                                        .ticketsProvider
                                                        .gridList
                                                        .value[index]
                                                        .title
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  );
                          }),

                          // Power Monitoring
                          // SizedBox(
                          //   height: Get.height * 0.02,
                          // ),
                          // InkWell(
                          //   onTap: () async {
                          //     await TopVariable.switchScreenAndRemoveAll(
                          //         '/new_dashboard');
                          //     setState(() {});
                          //   },
                          //   child: Padding(
                          //     padding: EdgeInsets.only(
                          //         left: Get.width * 0.05, right: Get.width * 0.05),
                          //     child: Container(
                          //       padding: const EdgeInsets.all(10),
                          //       decoration: BoxDecoration(
                          //         color: Colors.white,
                          //         borderRadius: BorderRadius.circular(7),
                          //         border: Border.all(
                          //             color: const Color.fromARGB(255, 211, 205, 205),
                          //             width: 0.5),
                          //       ),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         children: [
                          //           Icon(
                          //             Icons.topic,
                          //             color: CustomColor.grenishColor,
                          //             // color: const Color.fromRGBO(2, 87, 122, 1),
                          //             size: Get.height * 0.02,
                          //           ),
                          //           const SizedBox(
                          //             width: 10,
                          //           ),
                          //           Column(
                          //             mainAxisAlignment: MainAxisAlignment.start,
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: const [
                          //               Text(
                          //                 'Power Monitoring',
                          //                 style: TextStyle(
                          //                     // color: Color.fromRGBO(2, 87, 122, 1),
                          //                     color: CustomColor.grenishColor,
                          //                     fontSize: 13),
                          //               ),
                          //             ],
                          //           ),
                          //           const Spacer(),
                          //           const Text(
                          //             // UserPreferences.user.firstName ?? "",
                          //             '0 Active Tickets',
                          //             style: TextStyle(
                          //               color: Color.fromRGBO(156, 156, 156, 1),
                          //               fontSize: 10,
                          //             ),
                          //           ),
                          //           Center(
                          //             child: Padding(
                          //               padding:
                          //                   EdgeInsets.only(right: Get.width * 0.000),
                          //               child: Icon(
                          //                 Icons.arrow_forward_ios_outlined,
                          //                 color: const Color.fromRGBO(156, 156, 156, 1),
                          //                 size: Get.height * 0.02,
                          //               ),
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          SizedBox(
                            height: Get.height * 0.025,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }

  Widget appbar(UserModel user) {
    return Container(
      height: Get.height * 0.087,
      color: CustomColor.grenishColor,
      // color: appTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back ',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 200,
                  child: Text(
                    UserPreferences.getString('userName') ?? "--",
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                    maxLines: 2,
                  ),
                )
              ],
            ),
            const Spacer(),

            // Image.asset('assets/ic_cloudy_rainy.png'),
            weatherWidget()
            // const Text(
            //   "17 " "°C",
            //   style: TextStyle(color: Colors.white, fontSize: 20),
            // ),
          ],
        ),
      ),
    );
  }
}

class PowerMonitoringColumnWidget extends StatelessWidget {
  final String image;
  final String value;
  final String unit;
  final String title;
  final Color colorVal;
  const PowerMonitoringColumnWidget({
    Key? key,
    required this.image,
    required this.value,
    required this.unit,
    required this.title,
    required this.colorVal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(
                height: Get.height * 0.02,
                width: Get.height * 0.02,
                child: Image.asset(
                  image,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: value,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorVal,
                          fontWeight: FontWeight.w900,
                        )),
                    TextSpan(
                      text: unit,
                      style: const TextStyle(
                        color: Color.fromRGBO(156, 156, 156, 1),
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Text(title,
              style: const TextStyle(
                color: Color.fromRGBO(46, 56, 80, 1),
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ))
        ],
      ),
    );
  }
}

class CoummintySOlarGardenColumnWidget extends StatelessWidget {
  final String image;
  final String value;
  final String unit;
  final String title;
  final Color colorVal;
  const CoummintySOlarGardenColumnWidget({
    Key? key,
    required this.image,
    required this.value,
    required this.unit,
    required this.title,
    required this.colorVal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: value,
                        style: TextStyle(
                          color: colorVal,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        )),
                    TextSpan(
                      text: unit,
                      style: const TextStyle(
                        color: Color.fromRGBO(156, 156, 156, 1),
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Text(title,
              style: const TextStyle(
                color: Color.fromRGBO(46, 56, 80, 1),
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ))
        ],
      ),
    );
  }
}

Widget weatherWidget() {
  return Consumer<DashboardProvider>(builder: (context, value, child) {
    if (value.weatherData == null) {
      return const SizedBox();
    }
    var normalTemp =
        double.parse(value.weatherData!['main']['temp'].toString()) - 275.15;

    var fahrenheit = Celsius.toFahrenheit(normalTemp);

    var icon = value.weatherData!['weather'][0]['icon'].toString();
    return Obx(() {
      return TopVariable.ticketsProvider.isloadingForWeatherBottomSheetNew.value
          ? const SizedBox()
          : Row(
              children: [
                Image.network(
                  value.weatherData == null
                      ? 'http://openweathermap.org/img/wn/03d@2x.png'
                      : 'http://openweathermap.org/img/wn/$icon@2x.png',
                  width: 40,
                ),
                value.weatherData != null
                    ? Text(fahrenheit.toStringAsFixed(0) + "°F",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            // color: appTheme.primaryColor,
                            color: Colors.white))
                    : const Text(""),
              ],
            );
    });
  });
}

class GridListClass {
  RxString val;
  RxString title;

  GridListClass(this.val, this.title);
}
