import 'package:diplom/bloc/detail_user_bloc/detail_user_bloc.dart';
import 'package:diplom/models/chart_item.dart';
import 'package:diplom/screens/detail_user/detail_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ChartCurricular extends StatelessWidget {
  const ChartCurricular({required this.data}) : super();

  final List<ChartStringItem> data;

  @override
  Widget build(BuildContext context) {
    var all = 0;
    for (var i in data) {
      all += i.item;
    }
    return SizedBox(
      height: 250,
      child: SfCircularChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <PieSeries<ChartStringItem, String>>[
          PieSeries<ChartStringItem, String>(
            dataSource: data,
            xValueMapper: (x, xx) => x.str,
            yValueMapper: (sales, _) => sales.item,
            dataLabelMapper: (data, count) =>
                '${data.str} ${(data.item / all * 100).toInt()}%',
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
            ),
            // groupMode: CircularChartGroupMode.value,
            // groupTo: 7,
            // pointColorMapper: (data, _) => data.isBool ? null : Colors.red,
            onPointDoubleTap: (point) {
              toListLinks(context, data[point.pointIndex!].links);
            },
          ),
        ],
      ),
    );
  }
}
