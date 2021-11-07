import 'package:flutter/material.dart';

class LoadingWidgets {
  static Widget loading({
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: CircularProgressIndicator(
        color: color,
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
