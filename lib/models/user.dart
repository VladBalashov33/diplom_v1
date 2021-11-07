import 'dart:math';

import 'package:diplom/models/publish.dart';
import 'package:diplom/utils/constants.dart';
import 'package:intl/intl.dart';

class User {
  final int id;
  final String name;
  final String username;
  final String? photo;
  final num subscribers;

  final bool isPrivet;
  final String url;
  final int countPublished;
  final int countFollow;
  final DateTime? lastActivity;
  final String description;
  final List<String> alsoUrl;
  final bool isBusiness;
  final String typeBusiness;
  final List<Publish> publish;

  User({
    this.id = 0,
    this.name = '',
    this.username = '',
    this.photo,
    this.subscribers = 0,
    this.isPrivet = false,
    this.url = '',
    this.countPublished = 0,
    this.countFollow = 0,
    this.lastActivity,
    this.description = '',
    this.alsoUrl = const [],
    this.isBusiness = false,
    this.typeBusiness = '',
    this.publish = const [],
  });

  factory User.mock({int? id}) {
    final random = Random();
    return User(
      id: id ?? 0,
      name: 'cat',
      username: 'CatCat',
      photo: Constants.mockImage,
      subscribers: random.nextInt(100000),
      isPrivet: random.nextBool(),
      url: 'https://www.instagram.com/mourn.one',
      countPublished: random.nextInt(100),
      countFollow: random.nextInt(100000),
      lastActivity:
          DateTime.now().subtract(Duration(days: random.nextInt(100))),
      description:
          'Я прибрал к рукам девушку, которая потеряла своего жениха, и теперь я учу её всяким плохим вещам, кормлю вкусняшками, наряжаю в красивые вещи и вообще делаю её самой счастливой девушкой на земле!',
      alsoUrl: [
        'https://www.instagram.com/mourn.one',
        'https://www.instagram.com/mourn.one',
        'https://www.instagram.com/mourn.one'
      ],
      isBusiness: random.nextBool(),
      typeBusiness: 'Волк',
      publish: [],
    );
  }

  String get getLastActivityDate {
    if (lastActivity != null) {
      return DateFormat.yMMMMd().format(lastActivity!);
    }
    return '';
  }
}
