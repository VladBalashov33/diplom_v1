import 'package:diplom/models/chart_item.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ChartUserCount extends StatelessWidget {
  const ChartUserCount({required this.data}) : super();

  final List<ChartStringItem> data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 20 * data.length.toDouble(),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            minimum: 20,
            // visibleMinimum: 20,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          title: ChartTitle(
            text: 'Распределение постов относительно часа дня',
          ),
          primaryYAxis: CategoryAxis(
            majorTickLines: const MajorTickLines(size: 0),
            axisLine: const AxisLine(width: 0),
          ),
          series: <BarSeries<ChartStringItem, String>>[
            BarSeries<ChartStringItem, String>(
              dataSource: data,
              name: 'постов в день',
              xValueMapper: (x, xx) => x.str,
              yValueMapper: (sales, _) => sales.item,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                offset: Offset(-5, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
