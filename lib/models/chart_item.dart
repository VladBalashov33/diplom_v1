// ignore_for_file: avoid_positional_boolean_parameters

import 'package:diplom/models/post.dart';

class ChartDataItem {
  const ChartDataItem(this.date, this.item, {this.links = const []});

  final String date;
  final int item;
  final List<String> links;

  DateTime get getDate {
    final _date = date.replaceAll('.', '-');
    try {
      return DateTime.parse(_date);
    } catch (e) {
      try {
        final _newDate = _date.split('-').map(int.parse).toList();
        return DateTime(_newDate[2], _newDate[1], _newDate[0]);
      } catch (e) {}
      print('==$e==');
      return DateTime(1900, 1, 1);
    }
  }
}

class ChartStringItem {
  const ChartStringItem(this.str, this.item);

  final String str;
  final int item;
}

class ChartBoolItem {
  const ChartBoolItem(this.isBool, this.item);

  final bool isBool;
  final int item;
}
