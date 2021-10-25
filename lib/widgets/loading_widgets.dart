import 'package:diplom/utils/utils.dart';
import 'package:flutter/material.dart';

class LoadingWidgets {
  static Widget loading({
    Color? color = AppColors.grey757575,
    double? width,
  }) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: CircularProgressIndicator(
        backgroundColor: AppColors.grey757575,
        color: AppColors.grey757575,
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
