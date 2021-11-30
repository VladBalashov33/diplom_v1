import 'package:diplom/models/chart_item.dart';
import 'package:flutter/material.dart';

enum SortType {
  username,
  name,
  lastActivity,
  subscribers,
  postCount,
}

class Constants {
  const Constants._();

  static const buttonDuration = Duration(milliseconds: 300);
  static const repeatDuration = Duration(seconds: 5);
  static const searchDuration = Duration(seconds: 1);

  static const delayDuration = Duration(seconds: 1);

  static const reSendCodeSeconds = 60;

  static String mockImage =
      'https://cdnn21.img.ria.ru/images/07e5/06/18/1738448523_0:54:864:540_1920x0_80_0_0_22bd72aa578b3fece6a89a620c95c4a1.jpg';
  static String mockVideo =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  static const listPadding = EdgeInsets.only(
    top: 8,
    bottom: 60,
    left: 12,
    right: 12,
  );
  static Map<SortType, String> sortTypeName = {
    SortType.username: 'Имя пользователя',
    SortType.name: 'Полное имя',
    SortType.subscribers: 'Подписчики',
    SortType.lastActivity: 'Последняя активность',
    SortType.postCount: 'Кол-во постов',
  };
}
