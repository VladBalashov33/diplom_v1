import 'package:diplom/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum DateType { day, month, year, hour }

String getMean<E, K extends Comparable<Object>>(
  Iterable<E> items,
  num Function(E) toKey,
) {
  num res = 0;
  for (var i in items) {
    res += toKey(i);
  }
  try {
    return '${res ~/ items.length}';
  } catch (e) {
    return '${res ~/ 1}';
  }
}

String getMeanFloat<E, K extends Comparable<Object>>(
  Iterable<E> items,
  num Function(E) toKey,
) {
  num res = 0;
  for (var i in items) {
    res += toKey(i);
  }
  try {
    return (res / items.length).toStringAsFixed(2);
  } catch (e) {
    return (res / 1).toStringAsFixed(2);
  }
}

extension Convert on DateTime {
  DateTime toDay() {
    return DateTime(year, month, day);
  }

  DateTime toMonth() {
    return DateTime(year, month);
  }

  DateTime toYear() {
    return DateTime(year);
  }

  DateTime toHour() {
    return DateTime(1900, 1, 1, hour, 0);
  }

  DateTime toDayType(DateType type) {
    switch (type) {
      case DateType.day:
        return toDay();
      case DateType.month:
        return toMonth();
      case DateType.year:
        return toYear();
      case DateType.hour:
        return toHour();
      default:
        return this;
    }
  }
}

extension DoubleConvert on double {
  double to100() {
    return (this ~/ 100 + 1) * 100;
  }
}

extension RangeValuesConvert on RangeValues {
  RangeValues to100() {
    return RangeValues(start.to100(), end.to100());
  }
}

extension StringExt on String {
  String toPhone() {
    if (length != 11) {
      return '';
    } else {
      // ignore: lines_longer_than_80_chars
      return '+7 (${substring(1, 4)}) ${substring(4, 7)}-${substring(7, 9)}-${substring(9, 11)}';
    }
  }

  String toPhoneClean() {
    final a = replaceAll(RegExp(r'\D'), '');
    return '+$a';
  }
}

extension WidgetExtension on Widget {
  Widget unfocus(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: this,
    );
  }

  Widget refreshIndicator({
    required RefreshController refreshController,
    void Function()? onRefresh,
    void Function()? onLoading,
    bool reverse = false,
    bool isRefresh = true,
    bool isLoad = true,
  }) {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: isLoad,
      enablePullDown: isRefresh,
      reverse: reverse,
      physics: const BouncingScrollPhysics(),
      footer: const ClassicFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        completeDuration: Duration(milliseconds: 500),
        idleText: '',
        loadingText: 'Загрузка...',
        canLoadingText: 'Отпустите, чтобы загрузить больше',
        failedText: 'Результатов больше нет',
      ),
      header: isRefresh
          ? WaterDropHeader(
              waterDropColor: Colors.transparent,
              complete: Container(),
              idleIcon: LoadingWidgets.loading(),
              completeDuration: Duration.zero,
              refresh: LoadingWidgets.loading(),
            )
          : null,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: this,
    );
  }
}
