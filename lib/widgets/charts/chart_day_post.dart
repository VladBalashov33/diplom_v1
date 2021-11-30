import 'package:diplom/bloc/detail_user_bloc/detail_user_bloc.dart';
import 'package:diplom/models/chart_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ChartDayPost extends StatelessWidget {
  const ChartDayPost({
    required this.data,
  }) : super();

  final List<ChartDataItem> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeCategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelIntersectAction: AxisLabelIntersectAction.rotate45,
          dateFormat: DateFormat.yMd(),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          interval: 10,
          majorTickLines: const MajorTickLines(size: 0),
          axisLine: const AxisLine(width: 0),
        ),
        series: <ColumnSeries<ChartDataItem, DateTime>>[
          ColumnSeries<ChartDataItem, DateTime>(
            dataSource: data,
            xValueMapper: (x, xx) => x.getDate,
            yValueMapper: (sales, _) => sales.item,
            onPointTap: (point) {
              context
                  .read<DetailUserBloc>()
                  .setPostLinks(data[point.pointIndex!].links);

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

class ChartAmongDayPost extends StatelessWidget {
  const ChartAmongDayPost({
    required this.data,
  }) : super();

  final List<ChartDataItem> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
            // visibleMinimum: 20,
            ),
        // primaryXAxis: DateTimeCategoryAxis(
        //   majorGridLines: const MajorGridLines(width: 0),
        //   labelIntersectAction: AxisLabelIntersectAction.rotate45,
        //   dateFormat: DateFormat.yMd(),
        // ),
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          interval: 10,
          majorTickLines: const MajorTickLines(size: 0),
          axisLine: const AxisLine(width: 0),
        ),
        series: <ColumnSeries<ChartDataItem, int>>[
          ColumnSeries<ChartDataItem, int>(
            dataSource: data,
            xValueMapper: (x, xx) => int.parse(x.date),
            yValueMapper: (sales, _) => sales.item,
            onPointTap: (point) {
              context
                  .read<DetailUserBloc>()
                  .setPostLinks(data[point.pointIndex!].links);

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
