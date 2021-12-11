import 'package:diplom/models/chart_item.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ChartDateCount extends StatelessWidget {
  const ChartDateCount({required this.data}) : super();

  final List<ChartDataItem> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeCategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelIntersectAction: AxisLabelIntersectAction.rotate45,
          // dateFormat: DateFormat.E(),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        title: ChartTitle(
          text: 'Распределение постов относительно часа дня',
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          interval: 10,
          majorTickLines: const MajorTickLines(size: 0),
          axisLine: const AxisLine(width: 0),
        ),
        series: <CartesianSeries<ChartDataItem, DateTime>>[
          LineSeries<ChartDataItem, DateTime>(
            dataSource: data,
            name: 'постов в день',
            // onCreateShader: (ShaderDetails details) {
            //   return ui.Gradient.linear(
            //       details.rect.topCenter, details.rect.bottomCenter, <Color>[
            //     const Color.fromRGBO(26, 112, 23, 1),
            //     const Color.fromRGBO(26, 112, 23, 1),
            //     const Color.fromRGBO(4, 8, 195, 1),
            //     const Color.fromRGBO(4, 8, 195, 1),
            //     const Color.fromRGBO(229, 11, 10, 1),
            //     const Color.fromRGBO(229, 11, 10, 1),
            //   ], <double>[
            //     0,
            //     0.333333,
            //     0.333333,
            //     0.666666,
            //     0.666666,
            //     0.999999,
            //   ]);
            // },
            xValueMapper: (x, xx) => x.getDay,
            yValueMapper: (sales, _) => sales.item,
            onPointDoubleTap: (data) {
              print('==$data==');
            },
            // markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}
