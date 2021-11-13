class ChartDataItem {
  const ChartDataItem(this.date, this.item);

  final String date;
  final int item;

  DateTime get getDate {
    try {
      return DateTime.parse(date);
    } catch (e) {
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
