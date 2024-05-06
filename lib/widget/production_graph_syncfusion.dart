import 'package:flutter/material.dart';
import 'package:solaramps/theme/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProductionGraphSyncfusion extends StatefulWidget {
  final List<String> xAxisData;
  final List<SyncfusionPowerDataSeriesModel> powerDataSeries;
  final bool dailyGraph;
  const ProductionGraphSyncfusion(
      {Key? key,
      required this.xAxisData,
      required this.powerDataSeries,
      required this.dailyGraph})
      : super(key: key);

  @override
  _ProductionGraphSyncfusionState createState() =>
      _ProductionGraphSyncfusionState();
}

class _ProductionGraphSyncfusionState extends State<ProductionGraphSyncfusion> {
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      
        primaryXAxis: CategoryAxis(
          majorTickLines: const MajorTickLines(color: Colors.transparent),
          axisLine: const AxisLine(
            width: 0,
          ),
          majorGridLines: const MajorGridLines(width: 0),
        ),
        // primaryYAxis: CategoryAxis(
        //   majorTickLines: const MajorTickLines(color: Colors.transparent),
        //   axisLine: const AxisLine(
        //     width: 0,
        //   ),
        //   borderColor: Colors.red,
        //   majorGridLines: const MajorGridLines(width: 0),
        // ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
        ),
        // Enable tooltip
        tooltipBehavior: _tooltipBehavior,
        zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
        plotAreaBorderWidth: 0,
        series: widget.dailyGraph
            ? getGraphDataSpline(widget.xAxisData, widget.powerDataSeries)
            : getGraphDataBar(widget.xAxisData, widget.powerDataSeries));
  }

  List<SplineSeries<SyncfusionPowerGraphDataModel, String>> getGraphDataSpline(
      List<String> xAxisData,
      List<SyncfusionPowerDataSeriesModel> powerDataSeries) {
    List<SplineSeries<SyncfusionPowerGraphDataModel, String>> listToReturn = [];
    for (SyncfusionPowerDataSeriesModel singleSeriesData in powerDataSeries) {
      listToReturn.add(SplineSeries<SyncfusionPowerGraphDataModel, String>(
          // Bind data source
          color: CustomColor.grenishColor,
          // Other required properties.
          dataSource: getDataSourceForSingleSeries(singleSeriesData, xAxisData),
          xValueMapper: (SyncfusionPowerGraphDataModel sales, _) => sales.time,
          yValueMapper: (SyncfusionPowerGraphDataModel sales, _) => sales.power,
          enableTooltip: true,
          markerSettings: const MarkerSettings(
            isVisible: true,
            width: 4,
            height: 4,
            borderColor: CustomColor.grenishColor,
          ),
          xAxisName: 'Time',
          yAxisName: 'Watts',
          name: singleSeriesData.seriesName,
          isVisibleInLegend: true
          // Enable data label
          //  dataLabelSettings: DataLabelSettings(isVisible: true)
          ));
    }
    return listToReturn;
  }

  List<ColumnSeries<SyncfusionPowerGraphDataModel, String>> getGraphDataBar(
      List<String> xAxisData,
      List<SyncfusionPowerDataSeriesModel> powerDataSeries) {
    List<ColumnSeries<SyncfusionPowerGraphDataModel, String>> listToReturn = [];
    for (SyncfusionPowerDataSeriesModel singleSeriesData in powerDataSeries) {
      listToReturn.add(ColumnSeries<SyncfusionPowerGraphDataModel, String>(
          // Bind data source
          color: CustomColor.grenishColor,
          dataSource: getDataSourceForSingleSeries(singleSeriesData, xAxisData),
          xValueMapper: (SyncfusionPowerGraphDataModel dataModel, _) =>
              dataModel.time,
          yValueMapper: (SyncfusionPowerGraphDataModel dataModel, _) =>
              dataModel.power,
          enableTooltip: true,
          //  markerSettings: MarkerSettings(isVisible: true, width: 4, height: 4),
          xAxisName: 'Time',
          yAxisName: 'Watts',
          markerSettings: const MarkerSettings(
            isVisible: true,
            width: 4,
            height: 4,
            borderColor: CustomColor.grenishColor,
          ),
          name: singleSeriesData.seriesName,
          isVisibleInLegend: true
          // Enable data label
          //  dataLabelSettings: DataLabelSettings(isVisible: true)
          ));
    }
    return listToReturn;
  }

  List<SyncfusionPowerGraphDataModel> getDataSourceForSingleSeries(
      SyncfusionPowerDataSeriesModel singleSeriesData, List<String> xAxisData) {
    List<SyncfusionPowerGraphDataModel> listToReturn = [];
    for (int i = 0; i < singleSeriesData.powerValues.length; i++) {
      listToReturn.add(SyncfusionPowerGraphDataModel(
        xAxisData[i],
        singleSeriesData.powerValues[i],
      ));
    }
    return listToReturn;
  }
}

class SyncfusionPowerGraphDataModel {
  SyncfusionPowerGraphDataModel(
    this.time,
    this.power,
  );
  final String time;
  final double power;
}

class SyncfusionPowerDataSeriesModel {
  SyncfusionPowerDataSeriesModel(
    this.powerValues,
    this.seriesName,
  );
  final List<double> powerValues;
  final String seriesName;
}

// before graph update
// import 'package:flutter/material.dart';
// import 'package:solaramps/theme/color.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class ProductionGraphSyncfusion extends StatefulWidget {
//   final List<String> xAxisData;
//   final List<SyncfusionPowerDataSeriesModel> powerDataSeries;
//   final bool dailyGraph;
//   const ProductionGraphSyncfusion(
//       {Key? key,
//       required this.xAxisData,
//       required this.powerDataSeries,
//       required this.dailyGraph})
//       : super(key: key);

//   @override
//   _ProductionGraphSyncfusionState createState() =>
//       _ProductionGraphSyncfusionState();
// }

// class _ProductionGraphSyncfusionState extends State<ProductionGraphSyncfusion> {
//   TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
//   @override
//   void initState() {
//     _tooltipBehavior = TooltipBehavior(enable: true);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SfCartesianChart(
//         primaryXAxis: CategoryAxis(
//           majorTickLines: const MajorTickLines(color: Colors.transparent),
//           axisLine: const AxisLine(
//             width: 0,
//           ),
//           majorGridLines: const MajorGridLines(width: 0),
//         ),
//         // primaryYAxis: CategoryAxis(
//         //   majorTickLines: const MajorTickLines(color: Colors.transparent),
//         //   axisLine: const AxisLine(
//         //     width: 0,
//         //   ),
//         //   borderColor: Colors.red,
//         //   majorGridLines: const MajorGridLines(width: 0),
//         // ),
//         legend: Legend(
//           isVisible: true,
//           position: LegendPosition.bottom,
//         ),
//         // Enable tooltip
//         tooltipBehavior: _tooltipBehavior,
//         zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
//         plotAreaBorderWidth: 0,
//         series: widget.dailyGraph
//             ? getGraphDataSpline(widget.xAxisData, widget.powerDataSeries)
//             : getGraphDataBar(widget.xAxisData, widget.powerDataSeries));
//   }

//   List<SplineSeries<SyncfusionPowerGraphDataModel, String>> getGraphDataSpline(
//       List<String> xAxisData,
//       List<SyncfusionPowerDataSeriesModel> powerDataSeries) {
//     List<SplineSeries<SyncfusionPowerGraphDataModel, String>> listToReturn = [];
//     for (SyncfusionPowerDataSeriesModel singleSeriesData in powerDataSeries) {
//       listToReturn.add(SplineSeries<SyncfusionPowerGraphDataModel, String>(
//           // Bind data source
//           color: Colors.red,
//           // Other required properties.
//           dataSource: getDataSourceForSingleSeries(singleSeriesData, xAxisData),
//           xValueMapper: (SyncfusionPowerGraphDataModel sales, _) => sales.time,
//           yValueMapper: (SyncfusionPowerGraphDataModel sales, _) => sales.power,
//           enableTooltip: true,
//           markerSettings: const MarkerSettings(
//             isVisible: true,
//             width: 4,
//             height: 4,
//             borderColor: CustomColor.grenishColor,
//           ),
//           xAxisName: 'Time',
//           yAxisName: 'Watts',
//           name: singleSeriesData.seriesName,
//           isVisibleInLegend: true
//           // Enable data label
//           //  dataLabelSettings: DataLabelSettings(isVisible: true)
//           ));
//     }
//     return listToReturn;
//   }

//   List<ColumnSeries<SyncfusionPowerGraphDataModel, String>> getGraphDataBar(
//       List<String> xAxisData,
//       List<SyncfusionPowerDataSeriesModel> powerDataSeries) {
//     List<ColumnSeries<SyncfusionPowerGraphDataModel, String>> listToReturn = [];
//     for (SyncfusionPowerDataSeriesModel singleSeriesData in powerDataSeries) {
//       listToReturn.add(ColumnSeries<SyncfusionPowerGraphDataModel, String>(
//           // Bind data source
//           dataSource: getDataSourceForSingleSeries(singleSeriesData, xAxisData),
//           xValueMapper: (SyncfusionPowerGraphDataModel dataModel, _) =>
//               dataModel.time,
//           yValueMapper: (SyncfusionPowerGraphDataModel dataModel, _) =>
//               dataModel.power,
//           enableTooltip: true,
//           //  markerSettings: MarkerSettings(isVisible: true, width: 4, height: 4),
//           xAxisName: 'Time',
//           yAxisName: 'Watts',
//           markerSettings: const MarkerSettings(
//             isVisible: true,
//             width: 4,
//             height: 4,
//             borderColor: CustomColor.grenishColor,
//           ),
//           name: singleSeriesData.seriesName,
//           isVisibleInLegend: true
//           // Enable data label
//           //  dataLabelSettings: DataLabelSettings(isVisible: true)
//           ));
//     }
//     return listToReturn;
//   }

//   List<SyncfusionPowerGraphDataModel> getDataSourceForSingleSeries(
//       SyncfusionPowerDataSeriesModel singleSeriesData, List<String> xAxisData) {
//     List<SyncfusionPowerGraphDataModel> listToReturn = [];
//     for (int i = 0; i < singleSeriesData.powerValues.length; i++) {
//       listToReturn.add(SyncfusionPowerGraphDataModel(
//           xAxisData[i], singleSeriesData.powerValues[i]));
//     }
//     return listToReturn;
//   }
// }

// class SyncfusionPowerGraphDataModel {
//   SyncfusionPowerGraphDataModel(this.time, this.power);
//   final String time;
//   final double power;
// }

// class SyncfusionPowerDataSeriesModel {
//   SyncfusionPowerDataSeriesModel(this.powerValues, this.seriesName);
//   final List<double> powerValues;
//   final String seriesName;
// }
