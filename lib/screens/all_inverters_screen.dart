import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/providers/dashboard_provider.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import 'package:solaramps/widget/subscription_tile_widget.dart';

class AllInvertersScreen extends StatefulWidget {
  const AllInvertersScreen({Key? key}) : super(key: key);

  @override
  State<AllInvertersScreen> createState() => _AllInvertersScreenState();
}

class _AllInvertersScreenState extends State<AllInvertersScreen> {
  @override
  void initState() {
    setState(() {
      TopVariable.dashboardProvider.customerSubscriptionsTilesList = [];
    });
    getDataRelatedToInverterList();

    super.initState();
  }

  getDataRelatedToInverterList() async {
    TopVariable.dashboardProvider.getCustomerInverterList();
    if (kDebugMode) {
      print(
          'Selected Sites :::::::: ${UserPreferences.getAllowedSiteSelectionVal}');
      print(
          'Selected Sites :::::::: ${UserPreferences.getAllowedSiteSelectionVal == ''}');
    }
    if (UserPreferences.getAllowedSiteSelectionVal == '') {
      await TopVariable.dashboardProvider.getCustomerInverterAllowedSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    int length = 0;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
              if (TopVariable.dashboardProvider.selectedIds.isNotEmpty) {
                TopVariable.dashboardProvider.valueOFSelectedID.value =
                    TopVariable.dashboardProvider.selectedIds.first;
              }
              TopVariable.dashboardProvider.getInverterData();
            },
            child: const Icon(Icons.check),
            shape: const CircleBorder(
              side: BorderSide(),
            )),
        appBar: AppBar(
          backgroundColor: CustomColor.grenishColor,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
              TopVariable.dashboardProvider.valueOFSelectedID.value =
                  TopVariable.dashboardProvider.selectedIds.first;
              TopVariable.dashboardProvider.getInverterData();
            },
            child: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          title: const Text("Sites"),
          // title: const Text("Inverters"),
        ),
        body: RefreshIndicator(
          onRefresh: (() {
            setState(() {
              TopVariable.dashboardProvider.customerSubscriptionsTilesList = [];
            });
            TopVariable.dashboardProvider.getCustomerInverterList();
            return Future<void>.delayed(const Duration(seconds: 3));
          }),
          child: Consumer<DashboardProvider>(
              builder: (context, dashboardConsumer, child) {
            length = dashboardConsumer.customerSubscriptionsTilesList.length;
            List<SubscriptionTile> selectedList = dashboardConsumer
                .customerSubscriptionsTilesList
                .where((element) => element.selected)
                .toList();

            child = Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 8, right: 8),
                  child: SizedBox(
                    height: 40,
                    child: TextFormField(
                      onChanged: (value) {
                        List<SubscriptionTile> f = dashboardConsumer
                            .customerSubscriptionsTilesList
                            .where((v) => v.subscriptionId.contains(value))
                            .toList();
                        setState(() {
                          length = f.length;
                        });
                        if (kDebugMode) {
                          print(f.length);
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.search),
                        hintText: "Search",
                        labelText: "Search",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          height: 1,
                          fontWeight: FontWeight.w500,
                          fontFamily: GoogleFonts.openSans().fontFamily,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFCACACA),
                            width: 1.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$length ${length > 1 ? 'Sites' : 'Site'}"),
                      Row(
                        children: [
                          Text(
                            "${selectedList.length} ${length > 1 ? 'Sites' : 'Site'} selected",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Checkbox(
                            // activeColor: appTheme.primaryColor,
                            activeColor: CustomColor.grenishColor,
                            tristate: true,
                            value: selectedList.length == length
                                ? true
                                : selectedList.isNotEmpty
                                    ? null
                                    : selectedList.isEmpty
                                        ? false
                                        : true,
                            onChanged: (d) {},
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: length,
                      itemBuilder: (it, i) => inverterItem(i)),
                )
              ],
            );
            return child;
          }),
        ),
      ),
    );
  }

  Widget inverterItem(int index) {
    SubscriptionTile item =
        TopVariable.dashboardProvider.customerSubscriptionsTilesList[index];

    return Column(
      children: [
        Container(
          color: item.selected ? const Color(0XFFDFEAF0) : Colors.white,
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.eco),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width * 0.71,
                      child: Text(
                        item.subscriptionId,
                        style: const TextStyle(
                            color: CustomColor
                                .grenishColor, //appTheme.primaryColor,
                            fontFamily: "ProximaNova",
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.71,
                      child: Text(
                        "| ${item.garden}",
                        style: const TextStyle(
                            color: CustomColor
                                .grenishColor, //appTheme.primaryColor,
                            fontFamily: "ProximaNova",
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      item.variantAlias,
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                )
              ]),
              Checkbox(
                // checkColor: appTheme.primaryColor,
                activeColor: CustomColor.grenishColor, //appTheme.primaryColor,
                value: item.selected,
                onChanged: (d) async {
                  if (TopVariable.dashboardProvider
                          .customerSubscriptionsTilesList[index].selected ==
                      true) {
                    item.selected = d!;
                    TopVariable.dashboardProvider.checkInverter(index, d);
                    return;
                  }

                  List<SubscriptionTile> selectedList = TopVariable
                      .dashboardProvider.customerSubscriptionsTilesList
                      .where((element) => element.selected)
                      .toList();

                  var allowedSelectedDevices =
                      UserPreferences.getAllowedSiteSelectionVal;

                  if (kDebugMode) {
                    print('selectedList Length ::::: ${selectedList.length}');
                    print(
                        'allowedSelectedDevices Length ::::: $allowedSelectedDevices');
                    print(int.parse(selectedList.length.toString()) >
                        int.parse(allowedSelectedDevices));
                  }
                  if (int.parse(selectedList.length.toString()) >
                      int.parse(allowedSelectedDevices)) {
                    TopVariable.dashboardProvider
                        .getCustomerInverterSelectionExceedMsg(
                            selectedList.length.toString());
                    return;
                  }
                  item.selected = d!;
                  TopVariable.dashboardProvider.checkInverter(index, d);
                },
              )
            ],
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey.shade300,
        )
      ],
    );
  }
}
