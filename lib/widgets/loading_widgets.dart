import 'package:diplom/utils/utils.dart';
import 'package:flutter/material.dart';

class LoadingWidgets {
  static Widget loading({
    Color? color,
    double? width,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: CircularProgressIndicator(
        color: color,
        // size: width ?? 40.w,
      ),
    );
  }

  static Widget loadingCenter({Color? color}) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          loading(color: color),
          Expanded(child: Row()),
        ],
      ),
    );
  }
}
