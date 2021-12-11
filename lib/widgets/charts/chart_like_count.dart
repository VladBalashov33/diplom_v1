import 'package:diplom/bloc/detail_user_bloc/detail_user_bloc.dart';
import 'package:diplom/models/chart_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ChartLikeCount extends StatelessWidget {
  const ChartLikeCount({
    required this.data,
    this.title = '',
  }) : super();

  final List<ChartDataItem> data;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeCategoryAxis(
          intervalType: DateTimeIntervalType.days,
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          // interval: 10,
          majorTickLines: const MajorTickLines(size: 0),
          axisLine: const AxisLine(width: 0),
        ),
        series: <CartesianSeries<ChartDataItem, DateTime>>[
          AreaSeries<ChartDataItem, DateTime>(
            dataSource: data,
            name: title,
            opacity: 0.7,
            xValueMapper: (x, xx) => x.getDay,
            yValueMapper: (sales, _) => sales.item,
            onPointDoubleTap: (point) {
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
