import 'package:bot_toast/bot_toast.dart';
import 'package:diplom/utils/utils.dart';
import 'package:flutter/material.dart';

class ToastMsg {
  static void showToast(String message) {
    BotToast.showText(
      contentColor: Colors.white.withOpacity(0.8),
      text: message,
      textStyle: AppTypography.font16.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
