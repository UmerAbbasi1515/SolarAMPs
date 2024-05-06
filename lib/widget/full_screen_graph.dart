
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/widget/production_graph_syncfusion.dart';
import '../providers/dashboard_provider.dart';
import '../utility/top_level_variables.dart';

class FullScreenGraph extends StatefulWidget {
  final DateTime graphDate;
  final String graphType, graphPeriod;
  const FullScreenGraph(
      {Key? key,
      required this.graphDate,
      required this.graphType,
      required this.graphPeriod})
      : super(key: key);

  @override
  _FullScreenGraphState createState() => _FullScreenGraphState();
}

class _FullScreenGraphState extends State<FullScreenGraph> {
  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      /* DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,*/
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    fullScreenGraphDate = widget.graphDate;
  }

  DateTime fullScreenGraphDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              //  mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding:const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${widget.graphPeriod.toUpperCase()} - ${widget.graphType.toUpperCase()}',
                    style: TextStyle(
                        color: appTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        padding:
                           const EdgeInsets.only(top: 10, bottom: 15, right: 70),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              color: Colors.black,
                              onPressed: () {
                                TopVariable.dashboardProvider.onDateSelected(
                                    fullScreenGraphDate
                                        .subtract(const Duration(days: 1)));
                                setState(() {
                                  fullScreenGraphDate = fullScreenGraphDate
                                      .subtract(const Duration(days: 1));
                                });
                              },
                            ),
                            Text(
                              DateFormat('EEE dd-MM-yyyy')
                                  .format(fullScreenGraphDate)
                                  .toString(),
                              style:const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              color: Colors.black,
                              onPressed: () {
                                TopVariable.dashboardProvider.onDateSelected(
                                    fullScreenGraphDate.add(const Duration(days: 1)));
                                setState(() {
                                  fullScreenGraphDate = fullScreenGraphDate
                                      .add(const Duration(days: 1));
                                });
                              },
                            ),
                          ],
                        )),
                  ],
                )),
                GestureDetector(
                  child: Container(
                    padding:const EdgeInsets.only(top: 12, bottom: 15, right: 20),
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      'assets/expand_button.png',
                      width: 35,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(
              width: screenHeight!,
              height: screenWidth! - 80,
              child: Consumer<DashboardProvider>(
                  builder: (context, dashboardConsumer, child) {
                /*child = ProductionGraph(graphData: dashboardConsumer.allGraphSeries.toString(), width: screenHeight!-50, height: screenWidth!-100,
                      xAxisData: dashboardConsumer.graphXAxis.toString(), graphType: dashboardConsumer.graphType,);*/
                child = ProductionGraphSyncfusion(
                  xAxisData: dashboardConsumer.syncfusionXAxis,
                  powerDataSeries: dashboardConsumer.syncfusionPowerData,
                  dailyGraph: dashboardConsumer.dailyGraph,
                );
                return child;
              }),
            )
          ],
        ),
      ),
    );
  }
}
