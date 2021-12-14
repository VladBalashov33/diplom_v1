import 'package:diplom/bloc/detail_user_bloc/detail_user_bloc.dart';
import 'package:diplom/models/chart_item.dart';
import 'package:diplom/screens/detail_user/detail_user_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartUserCount extends StatelessWidget {
  const ChartUserCount({required this.data}) : super();

  final List<ChartStringItem> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text('Нет хештегов'),
        ),
      );
    }
    return SingleChildScrollView(
      child: SizedBox(
        height: (20 * data.length.toDouble()) + 40,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            maximumLabelWidth: kIsWeb ? null : 140,
            // visibleMinimum: 20,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryYAxis: NumericAxis(
            majorTickLines: const MajorTickLines(size: 0),
            axisLine: const AxisLine(width: 0),
          ),
          series: <BarSeries<ChartStringItem, String>>[
            BarSeries<ChartStringItem, String>(
              dataSource: data,
              name: '',
              xValueMapper: (x, xx) => x.str,
              yValueMapper: (sales, _) => sales.item,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                offset: Offset(-5, 0),
              ),
              onPointDoubleTap: (point) {
                toListLinks(context, data[point.pointIndex!].links);
              },
            ),
          ],
        ),
      ),
    );
  }
}
