import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:solaramps/controllers_/user_profile_screen_controller.dart';
import 'package:solaramps/screens/CustomerSuportInbox.dart';
import 'package:solaramps/screens/home/home_bottom_sheet_one.dart';
import 'package:solaramps/screens/new_dashboard.dart';
import 'package:solaramps/screens/user_profile_screen.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/paths.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';

class HomeScreenTabs extends StatefulWidget {
  final int initialIndex;
  const HomeScreenTabs({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _HomeScreenTabsState createState() => _HomeScreenTabsState();
}

class _HomeScreenTabsState extends State<HomeScreenTabs> {
  Widget space = Container(
    height: 1,
    color: Colors.grey.shade300,
  );
  EdgeInsets padding =
      const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5);
  TextStyle style = TextStyle(fontSize: 14, color: appTheme.primaryColor);

  List<Widget> _buildScreens = [];
  int _selectedIndex = 0;

  UserProfileScreenController controller =
      Get.put(UserProfileScreenController());

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    getProfileData();
    super.initState();
  }

  getProfileData() async {
    await controller.getUserProfileDetail();
    // getAllTickets
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TopVariable.ticketsProvider.getAllTickets();
      setState(() {});
    });
  }

  // Dashboard
  @override
  Widget build(BuildContext context) {
    _buildScreens = [
      const HomeScreenBottomSheetOne(),
      const CustomerSupportInbox(),
      const UserProfileScreen(),
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
          image: const AssetImage(assetsLogo),
          fit: BoxFit.fill,
        )),
      ),
    ];
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: bottomBar(context),
        body: _buildScreens[_selectedIndex],
      ),
    );
  }

  Widget bottomBar(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: CustomColor.grenishColor,
        textTheme: Theme.of(context).textTheme.copyWith(
              caption: const TextStyle(color: Colors.white),
            ),
      ),
      child: BottomNavigationBar(
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: CustomColor.grenishColor,
          onTap: (val) {
            if (val == 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                TopVariable.ticketsProvider.fetchLocation();
              });
              setState(() {
                TopVariable.ticketsProvider.listOfTreePlanted.clear();
                TopVariable.ticketsProvider.isShowWidget.value = false;
                TopVariable.dashboardProvider.selectedIds.clear();
              });
              Get.off(() => const NewDashboard());
            }
            if (val == 1) {
              setState(() {
                TopVariable.ticketsProvider.listOfTreePlanted.clear();
                TopVariable.ticketsProvider.isShowWidget.value = false;
                UserPreferences.setString('showSupporttab', 'false');
              });
            }
            if (val == 2) {
              TopVariable.ticketsProvider.listOfTreePlanted.clear();
              TopVariable.ticketsProvider.isShowWidget.value = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.getClientUserDetail();
              });
            }
            if (val == 3) {
              TopVariable.ticketsProvider.listOfTreePlanted.clear();
              TopVariable.ticketsProvider.isShowWidget.value = false;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Notifications'),
                  content: const Text('No new notification available.'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
              setState(() {});
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
                      ? 'assets/ic_power_monitoring_dashboard_white.svg'
                      : 'assets/ic_power_monitoring_dashboard.svg',
                  height: 15,
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
                      ? 'assets/ic_user_white.svg'
                      : 'assets/ic_user.svg',
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
          ]),
    );
  }
}
