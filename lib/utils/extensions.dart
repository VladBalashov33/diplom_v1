import 'package:diplom/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

extension Convert on DateTime {
  String toFieldString() {
    return DateFormat('dd MMMM yyyy', 'ru').format(this);
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
