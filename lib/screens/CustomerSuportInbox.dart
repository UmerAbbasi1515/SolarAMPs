// ignore_for_file: file_names


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solaramps/dataModel/allTicketsModal.dart';
import 'package:solaramps/screens/SupportMessageScreen.dart';
import 'package:solaramps/screens/create_ticket_screen.dart';
import 'package:solaramps/screens/new_dashboard.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/extensions.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';

class CustomerSupportInbox extends StatefulWidget {
  const CustomerSupportInbox({Key? key}) : super(key: key);

  @override
  State<CustomerSupportInbox> createState() => _CustomerSupportInboxState();
}

class _CustomerSupportInboxState extends State<CustomerSupportInbox> {
  int tLength = 0;
  List<AllTicketsModal> allTickets = [];
  List<AllTicketsModal> filterList = [];
  int _selectedIndex = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TopVariable.ticketsProvider.getAllTickets();
    });
    super.initState();
  }

  // Widget bottomBar() {
  //   return Theme(
  //     data: Theme.of(context).copyWith(
  //       canvasColor: CustomColor.grenishColor,
  //       textTheme: Theme.of(context).textTheme.copyWith(
  //             caption: const TextStyle(color: Colors.white),
  //           ),
  //     ),
  //     child: BottomNavigationBar(
  //         currentIndex: 1,
  //         fixedColor: Colors.white54,
  //         selectedIconTheme: const IconThemeData(color: Colors.white),
  //         onTap: (e) {
  //           switch (e) {
  //             case 0:
  //               Navigator.pop(context);
  //               break;
  //             case 1:
  //               var route = ModalRoute.of(context);
  //               if (route != null) {
  //                 if (route.settings.name != '/customer_support') {
  //                   TopVariable.switchScreen("/customer_support");
  //                 }
  //               }
  //               break;
  //             case 3:
  //               showDialog(
  //                 context: context,
  //                 builder: (context) => AlertDialog(
  //                   title: const Text('Notifications'),
  //                   content: const Text('No new notification available.'),
  //                   actions: [
  //                     TextButton(
  //                       child: const Text('OK'),
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               );
  //               break;
  //             default:
  //           }
  //         },
  //         items: [
  //           const BottomNavigationBarItem(
  //               icon: Icon(
  //                 Icons.home,
  //                 size: 30,
  //               ),
  //               label: ""),
  //           BottomNavigationBarItem(
  //               icon: Image.asset("assets/home_1.png"), label: ""),
  //           const BottomNavigationBarItem(
  //               icon: Icon(
  //                 Icons.search,
  //                 size: 30,
  //                 color: Colors.white,
  //               ),
  //               label: ""),
  //           const BottomNavigationBarItem(
  //               icon: Icon(
  //                 Icons.notifications,
  //                 size: 30,
  //                 color: Colors.white,
  //               ),
  //               label: ""),
  //         ]),
  //   );
  // }
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
            currentIndex: 1,
            type: BottomNavigationBarType.fixed,
            backgroundColor: CustomColor.grenishColor,
            onTap: (val) {
              setState(() {
                _selectedIndex = val;
              });
              if (kDebugMode) {
                print('Value :::: $val');
                print('_selectedIndex :::: $_selectedIndex');
              }
              switch (val) {
                case 1:
                  var route = ModalRoute.of(context);

                  if (route != null) {
                    setState(() {
                      UserPreferences.setString('showSupporttab', 'true');
                    });
                    if (route.settings.name != '/customer_support') {
                      TopVariable.switchScreen("/customer_support");
                    }
                  }
                  break;
                case 0:
                  Get.off(() => const NewDashboard());
                  break;

                case 2:
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
                  break;
                case 3:
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
                  break;
                default:
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
  Widget build(BuildContext context) {
    setState(() {
      _selectedIndex = 1;
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          TopVariable.apiService.getLov();
          await Get.to(() => const CreateTicketScreen());
          await TopVariable.ticketsProvider.getAllTickets();

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const CreateTicketScreen(),
          //   ),
          // );
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        backgroundColor: const Color(0xFFFF7B50),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
          UserPreferences.getString('showSupporttab') == 'false'
              ? null
              : bottomBar(context),
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 25,
                  ),
                  Text(
                    "Customer Support",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.openSans().fontFamily),
                  ),
                ],
              ),
              color: CustomColor.grenishColor,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 19.0, right: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 2, color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          onChanged: (value) {
                            TopVariable.ticketsProvider.filterList(value);
                          },
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: "open-nova",
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Search tickets',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: "open-nova",
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 19.0, right: 18.0, top: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return TopVariable
                            .ticketsProvider.isLoadingForGetTickets.value
                        ? const SizedBox()
                        : Text(
                            "${TopVariable.ticketsProvider.allTickets.where((element) => element.status.toLowerCase() == "open").length} (Open) / ${TopVariable.ticketsProvider.allTickets.length} (Total)",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: "open-nova",
                            ),
                          );
                  }),
                  Row(
                    children: [
                      const Text(
                        "SHOW CLOSED TICKETS",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: "open-nova"),
                      ),
                      Obx(
                        () => Switch(
                          activeColor: const Color(0xFFFF7B50),
                          value: TopVariable.ticketsProvider.switchValue.value,
                          onChanged: (c) {
                            if (TopVariable.ticketsProvider.switchValue.value ==
                                true) {
                              setState(() {
                                TopVariable.ticketsProvider.switchValue.value =
                                    false;
                              });
                              TopVariable.ticketsProvider.showOnlyOpenTickets();
                            } else {
                              setState(() {
                                TopVariable.ticketsProvider.switchValue.value =
                                    true;
                              });
                              TopVariable.ticketsProvider.filterList('');
                            }
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            Obx(() {
              return TopVariable.ticketsProvider.isLoadingForGetTickets.value
                  ? SizedBox(
                      height: Get.height * 0.5,
                      child: const Center(
                          child: CircularProgressIndicator(
                        color: CustomColor.grenishColor,
                      )))
                  : TicketsListView(
                      filterList: TopVariable.ticketsProvider.allTickets,
                    );
            }),
            // Consumer<TicketsProvider>(builder: (context, tp, child) {
            //   return tp.isLoadinggetAllTickets.value
            //       ? SizedBox(
            //           height: Get.height * 0.3,
            //           child: const Center(
            //               child: CircularProgressIndicator(
            //             color: CustomColor.grenishColor,
            //           )))
            //       : TicketsListView(
            //           filterList: tp.allTickets,
            //         );
            // }
            // ),
          ],
        ),
      ),
    );
  }
}

class TicketsListView extends StatefulWidget {
  final List<AllTicketsModal> filterList;
  const TicketsListView({Key? key, required this.filterList}) : super(key: key);

  @override
  State<TicketsListView> createState() => _TicketsListViewState();
}

class _TicketsListViewState extends State<TicketsListView> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return TopVariable.ticketsProvider.isLoadinggetAllTickets.value
          ? SizedBox(
              height: Get.height * 0.3,
              child: const Center(
                  child: CircularProgressIndicator(
                color: CustomColor.grenishColor,
              )))
          : Expanded(
              child: widget.filterList.isEmpty
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height: Get.width * 0.5,
                        width: Get.width * 0.9,
                        child: const Center(
                          child: Text('No Data Found'),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.filterList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, i) => Container(
                        color: Colors.white,
                        child: Material(
                          key: UniqueKey(),
                          color: Colors.transparent,
                          child: InkWell(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (kDebugMode) {
                                      print(
                                          'Navigation to the detail of ticket 1');
                                    }

                                    // await Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         SupportMessageScreen(item: filterList[i]),
                                    //   ),
                                    // );

                                    setState(() {
                                      TopVariable.ticketsProvider.switchValue
                                          .value = true;
                                    });

                                    await Get.to(() => SupportMessageScreen(
                                          item: widget.filterList[i],
                                          list: widget.filterList[i]
                                              .conversationReferenceDTOList,
                                        ));
                                    TopVariable.ticketsProvider
                                        .isLoadinggetAllTickets.value = true;

                                    TopVariable.ticketsProvider.getAllTickets();
                                    TopVariable.ticketsProvider
                                        .isLoadinggetAllTickets.value = false;
                                    if (kDebugMode) {
                                      print(
                                          'Value of ::::::: Radio ::::: ${TopVariable.ticketsProvider.switchValue}');
                                    }
                                    setState(() {});
                                  },
                                  child: Column(
                                    key: UniqueKey(),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 18.0, left: 19, top: 13),
                                        child: Row(
                                          key: UniqueKey(),
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Ticket #${widget.filterList[i].id.toString()}",
                                              style: const TextStyle(
                                                  // color: appTheme.primaryColor,
                                                  color:
                                                      CustomColor.grenishColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              key: UniqueKey(),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: widget.filterList[i]
                                                            .status ==
                                                        "Open"
                                                    ? const Color(0xFFDFEAF0)
                                                    : const Color(0xFFE2E2E2),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6.0,
                                                    left: 6,
                                                    top: 2,
                                                    bottom: 2),
                                                child: Text(
                                                  widget.filterList[i].status ==
                                                          "Open"
                                                      ? "OPENED"
                                                      : "CLOSED",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: widget
                                                                  .filterList[i]
                                                                  .status ==
                                                              "Open"
                                                          // ? appTheme.primaryColor
                                                          ? CustomColor
                                                              .grenishColor
                                                          : const Color(
                                                              0xFF7E7E7E),
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      widget.filterList[i].summary == ''
                                          ? const SizedBox()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 19.0, top: 5),
                                              child: Text(
                                                  'Summary : ${widget.filterList[i].summary}',
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFFA5A5A5),
                                                      fontFamily: "open-nova")),
                                            ),
                                      widget.filterList[i].message == ''
                                          ? const SizedBox()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 19.0, top: 5),
                                              child: Text(
                                                'Description : ${widget.filterList[i].message}',
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFF505050),
                                                    fontFamily: "open-nova"),
                                              ),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 19.0, top: 10, bottom: 3),
                                        child: Text(
                                          widget.filterList[i].subCategory == ''
                                              ? widget.filterList[i].category
                                              : "${widget.filterList[i].category}  > ${widget.filterList[i].subCategory}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              // color: Theme.of(context).primaryColor,
                                              color: CustomColor.grenishColor,
                                              fontFamily: "open-nova"),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 19.0, top: 5, right: 18),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Priority: ${widget.filterList[i].priority}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  // color: const Color(0xFF2E3850)
                                                  //     .withOpacity(0.7),
                                                  color: CustomColor
                                                      .grenishColor
                                                      .withOpacity(0.7),
                                                  fontFamily: "open-nova"),
                                            ),
                                            Text(
                                              widget.filterList[i].createdAt
                                                  .getDayString(),
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontFamily: "open-nova"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                SizedBox(
                                  height: .5,
                                  child: Container(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            );
    });
  }
}
