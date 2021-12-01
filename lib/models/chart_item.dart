// ignore_for_file: avoid_positional_boolean_parameters

import 'package:diplom/models/post.dart';
import 'package:diplom/utils/utils.dart';

class ChartDataItem {
  const ChartDataItem(this.date, this.item, {required this.links});

  final DateTime date;
  final int item;
  final List<String> links;

  DateTime get getDay => date.toDay();
  DateTime get getHour => date.toHour();
}

class ChartStringItem {
  const ChartStringItem(this.str, this.item, this.links);

  final String str;
  final int item;
  final List<String> links;
}

class ChartBoolItem {
  const ChartBoolItem(this.isBool, this.item, this.links);

  final bool isBool;
  final int item;
  final List<String> links;
}
