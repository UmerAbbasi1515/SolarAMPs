import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/providers/dashboard_provider.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/constants.dart';
import '../utility/top_level_variables.dart';
import '../widget/custom_appbar.dart';
import '../widget/shimmer.dart';

class SubscriptionListScreen extends StatefulWidget {
  const SubscriptionListScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionListScreen> createState() => _SubscriptionListScreenState();
}

class _SubscriptionListScreenState extends State<SubscriptionListScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      TopVariable.dashboardProvider.customerSubscriptionsTilesListUserProfile =
          [];
    });
    await TopVariable.dashboardProvider.getCustomerSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Shimmer(
          linearGradient: Constants.shimmerGradient,
          child: SafeArea(
            child: Column(
              children: [
                const CustomAppbar(title: 'Subscriptions'),
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              // color: appTheme.primaryColor,
                              color: CustomColor.grenishColor,
                              width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          onChanged: (e) async {
                            if (e.isEmpty) {
                              await TopVariable.dashboardProvider
                                  .getCustomerSubscriptions();
                            } else {
                              await TopVariable.dashboardProvider
                                  .searchSubscriptions(e);
                            }
                          },
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            hintText: 'Search subscription',
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      Consumer<DashboardProvider>(
                          builder: (context, dashboardConsumer, child) {
                        child = Column(
                          children: dashboardConsumer
                              .customerSubscriptionsTilesListUserProfile,
                        );
                        return child;
                      }),
                    ],
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
