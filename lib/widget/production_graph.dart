import 'package:flutter/material.dart';
import 'package:high_chart/high_chart.dart';

class ProductionGraph extends StatefulWidget {
  final double width, height;
  const ProductionGraph({Key? key, required this.graphData, required this.width, required this.height, required this.xAxisData, required this.graphType}) : super(key: key);
  final String graphData, graphType;
  final String xAxisData;

  @override
  _ProductionGraphState createState() => _ProductionGraphState();
}

class _ProductionGraphState extends State<ProductionGraph> {
  @override
  Widget build(BuildContext context) {
    String highChartDataSet = _chartData1 + "height:\"${widget.height}\",width:\"${widget.width}\"" + _chartData2 + widget.graphType + _chartData3 + widget.xAxisData + _chartData4 + widget.graphData + '}';
   // print('high chart data...\t\t$highChartDataSet');
    return HighCharts(
      loader: const SizedBox(
        child: LinearProgressIndicator(),
        width: 200,
      ),
      size: const Size(400, 400),
      data: highChartDataSet,
      scripts: const [
        "https://code.highcharts.com/highcharts.js",
        'https://code.highcharts.com/modules/networkgraph.js',
        'https://code.highcharts.com/modules/exporting.js',
      ],
    );
  }




  final String _chartData1 = '''{
  chart: {
        zoomType: 'xy',
       // height: (9 / 16 * 100) + '%',
       //height: 200, width: 380,
        ''';

  final String _chartData2 = ''', backgroundColor: '#FFFFFF',
        type:''';

  final String _chartData3 = '''},
      title: {
          text: ''
      },
      credits: {
      enabled: false
      },
       tooltip: {
        style: {
            color: 'black',
            fontWeight: 'bold'
        }
    },    
      xAxis: {
          categories:''';
  final String _chartData4 =  '''},
      yAxis: {
      title: { 
      text: 'Watts'
      },
      },
      labels: {
          items: [/*{
              html: 'Cumulative',
              style: {
                  color: ( // theme
                      Highcharts.defaultOptions.title.style &&
                      Highcharts.defaultOptions.title.style.color
                  ) || 'black'
              }
          }*/]
      },
      series: ''';
}
