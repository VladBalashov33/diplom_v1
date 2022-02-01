import 'package:diplom/bloc/detail_user_bloc/detail_user_bloc.dart';
import 'package:diplom/models/chart_item.dart';
import 'package:diplom/screens/detail_user/detail_user_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const List<String> hashtag = ['Хештеги', 'Нет хештегов'];
const List<String> friends = [
  'Отмеченные пользователи',
  'Нет отмеченных пользователей'
];

class ChartUserCount extends StatelessWidget {
  const ChartUserCount({
    required this.data,
    required this.text,
  }) : super();

  final List<ChartStringItem> data;
  final List<String> text;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(text[1]),
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
                toListLinks(
                  context,
                  data[point.pointIndex!].links,
                  name: data[point.pointIndex!].str,
                  isHashtag: text[1] == hashtag[1],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
