// ignore_for_file: lines_longer_than_80_chars

import 'dart:math';

import 'package:diplom/models/post.dart';
import 'package:diplom/utils/constants.dart';
import 'package:intl/intl.dart';

import 'post_json.dart';

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
  final UserPosts? postInfo;

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
    this.postInfo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final _medias = json['medias'];
    final _postsStat = UserPosts.init;

    if (_medias != null) {
      for (var i in (_medias as Map).keys) {
        final _post = Post.fromJson(_medias[i], '$i');
        _postsStat.addPost(_post);
      }
    }

    final _alsoUrl = <String>[];
    try {
      _alsoUrl.addAll(json['external_link']);
    } catch (e) {}
    DateTime? dateTime;
    try {
      dateTime = DateTime.parse(json['last_update']);
    } on Exception catch (e) {}
    return User(
      id: json['id'],
      username: json['username'],
      name: json['full_name'],
      countPublished: json['media_count'],
      subscribers: json['follower_count'],
      countFollow: json['following_count'],
      url: json['instagram_link'],
      photo: json['pic'],
      lastActivity: dateTime,
      isBusiness: json['is_business'],
      postInfo: _postsStat,
      // :json['activate'],
      // :json['is_updated'],
//================================================================
      description: json['biography'] ?? '',
      alsoUrl: _alsoUrl,
      typeBusiness: json['business_category'] ?? '',
    );
  }

  factory User.mock({int? id}) {
    final random = Random();
    final _postsStat = UserPosts.init;

    // for (var i in postJson['res'] as List) {
    //   final _post = Post.fromJson(i);
    //   _postsStat.addPost(_post);
    // }

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
    );
  }

  String get getLastActivityDate {
    if (lastActivity != null) {
      return DateFormat.yMMMMd().format(lastActivity!);
    }
    return '';
  }
}
