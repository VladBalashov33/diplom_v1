import 'package:diplom/bloc/detail_user_bloc/detail_user_bloc.dart';
import 'package:diplom/models/chart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ChartTrueFalse extends StatelessWidget {
  const ChartTrueFalse({required this.data}) : super();

  final List<ChartBoolItem> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SfCircularChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <PieSeries<ChartBoolItem, bool>>[
          PieSeries<ChartBoolItem, bool>(
            dataSource: data,
            xValueMapper: (x, xx) => x.isBool,
            yValueMapper: (sales, _) => sales.item,
            dataLabelMapper: (data, count) => '${data.isBool} ${data.item}',
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
            ),
            // groupMode: CircularChartGroupMode.value,
            // groupTo: 7,
            pointColorMapper: (data, _) => data.isBool ? null : Colors.red,
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
