import 'package:diplom/models/chart_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ChartDayPost extends StatelessWidget {
  const ChartDayPost({required this.data}) : super();

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
          dateFormat: DateFormat.yMd(),
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
        series: <ColumnSeries<ChartDataItem, DateTime>>[
          ColumnSeries<ChartDataItem, DateTime>(
            dataSource: data,
            name: 'постов в день',
            xValueMapper: (x, xx) => x.getDate,
            yValueMapper: (sales, _) => sales.item,
            onPointTap: (data) {
              Provider.of<GlobalKey<ScaffoldState>>(context, listen: false)
                  .currentState!
                  .openEndDrawer();
            },
          ),
        ],
      ),
    );
  }
}
