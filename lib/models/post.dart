import 'dart:math';

import 'package:diplom/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diplom/utils/utils.dart';

import 'chart_item.dart';
import 'location.dart';
import 'user.dart';

class Post {
  final DateTime takenAt;
  final String id;
  final int mediaType;
  final CustomLocation location;
  final bool shouldRequestAds;
  final bool likeAndViewCountsDisabled;
  final bool isCommercial;
  final bool isPaidPartnership;
  final int commentCount;
  final int likeCount;
  final String link;
  final String createdTime;
  final String type;
  final List<String> tags;
  final List<String> usersInPhoto;

  Post({
    required this.takenAt,
    required this.id,
    required this.mediaType,
    required this.location,
    required this.shouldRequestAds,
    required this.likeAndViewCountsDisabled,
    required this.isCommercial,
    required this.isPaidPartnership,
    required this.commentCount,
    required this.likeCount,
    required this.link,
    required this.createdTime,
    required this.type,
    required this.tags,
    required this.usersInPhoto,
  });

  factory Post.fromJson(Map<String, dynamic> json, String id) {
    var _users = <String>[];
    try {
      _users = (json['friends'] as List).map((e) => e.toString()).toList();
    } catch (e) {}
    var _tags = <String>[];
    try {
      _tags = (json['hashtags'] as List).map((e) => e.toString()).toList();
    } catch (e) {}
    var dateTime = DateTime(1900);
    try {
      dateTime = DateTime.parse(json['date']);
    } catch (e) {}
    final _link = json['link'] ??
        'история от ${DateFormat('HH:mm - dd.MM.yy').format(dateTime)}';

    return Post(
      id: id,
      takenAt: dateTime,
      link: _link,
      type: json['type'] ?? '',
      likeCount: json['likes'] ?? 0,
      mediaType: json['media_type'] ?? 0,
      commentCount: json['comments'] ?? 0,
      tags: _tags,
      usersInPhoto: _users,
      //===
      location: CustomLocation.fromJson(json['location'] ?? {}),
      shouldRequestAds: json['should_request_ads'] ?? false,
      likeAndViewCountsDisabled: json['like_and_view_counts_disabled'] ?? false,
      isCommercial: json['is_commercial'] ?? false,
      isPaidPartnership: json['is_paid_partnership'] ?? false,
      createdTime: json['created_time'] ?? '',
    );
  }

  factory Post.mock(String id) {
    final random = Random();

    return Post(
      id: id,
      takenAt: DateTime.now().subtract(
        Duration(days: random.nextInt(100), hours: random.nextInt(20)),
      ),
      link: 'https://www.instagram.com/p/CZBiQnrqOiv/',
      type: '',
      likeCount: random.nextInt(100000),
      mediaType: random.nextInt(100000),
      commentCount: random.nextInt(100000),
      tags: ['голубыеволосы'],
      usersInPhoto: [
        'https://scontent-arn2-1.cdninstagram.com/v/t51.2885-15/e35/241371015_254217719900017_8328479284927476423_n.jpg?_nc_ht=scontent-arn2-1.cdninstagram.com&_nc_cat=101&_nc_ohc=5vdUj8a_8FgAX83b5yG&tn=XI0rXWnqJHTR41IU&edm=ABZsPhsBAAAA&ccb=7-4&ig_cache_key=MjY1NjU3NDI5Nzc4MDUxMTA1MA%3D%3D.2-ccb7-4&oh=00_AT9sIgoq90OAIpXP-Lqc9OQnuUfIZCeGnbmTfGHJJ7PWiA&oe=61FD42CC&_nc_sid=4efc9f'
      ],
      //===
      location: CustomLocation.fromJson({
        'lat': (random.nextBool() && random.nextBool())
            ? 55.0 + random.nextInt(100) / 100
            : null,
        'lng': 30.0 + random.nextInt(1000) / 100,
      }),
      shouldRequestAds: false,
      likeAndViewCountsDisabled: false,
      isCommercial: false,
      isPaidPartnership: false,
      createdTime: '',
    );
  }

  bool get isLocation => location.lat != null && location.lng != null;
  DateTime get getTime => takenAt;
  PeriodDay get getDayPeriod {
    final date = getTime.toHour().hour;
    if (date < 6) {
      return PeriodDay.night;
    } else if (date < 12) {
      return PeriodDay.morning;
    } else if (date < 18) {
      return PeriodDay.day;
    } else {
      return PeriodDay.evening;
    }
  }
}

enum PeriodDay { morning, day, evening, night }
const Map<PeriodDay, String> dayPeriodStrings = {
  PeriodDay.morning: 'Утро',
  PeriodDay.day: 'День',
  PeriodDay.evening: 'Вечер',
  PeriodDay.night: 'Ночь',
};

class UserPosts {
  final List<Post> posts;
  final Map<String, ChartStringItem> tags;
  final Map<String, ChartStringItem> usersInPhoto;

  final List<int> tagsCountList = [];

  UserPosts({
    required this.posts,
    required this.tags,
    required this.usersInPhoto,
  });

  static UserPosts get init => UserPosts(
        posts: [],
        tags: {},
        usersInPhoto: {},
      );

  void addPost(Post post) {
    posts.add(post);
    tagsCountList.add(post.tags.length);
    for (var i in post.tags) {
      tags.update(
          i,
          (value) => ChartStringItem(
                i,
                value.item + 1,
                value.links..add(post.link),
              ),
          ifAbsent: () => ChartStringItem(i, 1, [post.link]));
    }
    for (var i in post.usersInPhoto) {
      usersInPhoto.update(
          i,
          (value) => ChartStringItem(
                i,
                value.item + 1,
                value.links..add(post.link),
              ),
          ifAbsent: () => ChartStringItem(i, 1, [post.link]));
    }
  }

  List<ChartStringItem> get getTagsChartData {
    final res = tags.values.toList();
    res.sort((a, b) => a.item.compareTo(b.item));
    return res;
  }

  List<ChartStringItem> get getFriendsChartData {
    final res = usersInPhoto.values.toList();
    res.sort((a, b) => a.item.compareTo(b.item));
    return res;
  }

  UserPosts getPostInRange(DateTimeRange range) {
    final _start = range.start;
    final _end = range.end;
    final _posts = <Post>[];
    _posts.addAll(posts);
    _posts.removeWhere(
      (e) => !(e.getTime.isAfter(_start) && e.getTime.isBefore(_end)),
    );
    final res = UserPosts.init;
    _posts.forEach(res.addPost);
    return res;
  }

  List<ChartDataItem> get likeCountByPostData => _countData(
        posts.map((e) => e.likeCount).toList(),
      );
  List<ChartDataItem> get commentCountByPostData => _countData(
        posts.map((e) => e.commentCount).toList(),
      );

  List<ChartDataItem> _countData(List<int> list) {
    final res = <ChartDataItem>[];
    for (var i = 0; i < list.length; i++) {
      res.add(ChartDataItem(posts[i].getTime, list[i], links: [posts[i].link]));
    }
    return res;
  }

  List<ChartBoolItem> get isCommercialData => _truFalseData(
        posts.map((e) => e.isCommercial).toList(),
      );

  List<ChartBoolItem> _truFalseData(List<bool> list) {
    var _true = 0;
    var _false = 0;
    final _falseLinks = <String>[];
    final _trueLinks = <String>[];
    for (var i = 0; i < list.length; i++) {
      if (list[i]) {
        _true++;
        _trueLinks.add(posts[i].link);
      } else {
        _false++;
        _falseLinks.add(posts[i].link);
      }
    }
    return [
      ChartBoolItem(true, _true, _trueLinks),
      ChartBoolItem(false, _false, _falseLinks),
    ];
  }

  List<ChartDataItem> postPerPeriod(DateType type) {
    final _map = <DateTime, ChartDataItem>{};

    for (var i = 0; i < posts.length; i++) {
      final date = posts[i].getTime.toDayType(type);
      _map.update(
        date,
        (value) => ChartDataItem(
          date,
          value.item + 1,
          links: value.links..add(posts[i].link),
          posts: value.posts?..add(posts[i]),
        ),
        ifAbsent: () => ChartDataItem(
          date,
          1,
          links: [posts[i].link],
          posts: [posts[i]],
        ),
      );
    }
    return _map.values.toList();
  }

  Map<DateTime, ChartDataItem> _chartDataItem(int hour) => {
        DateTime(1900, 1, 1, hour, 0): ChartDataItem(
          DateTime(1900, 1, 1, hour, 0),
          0,
          links: <String>[],
        )
      };

  List<ChartDataItem> postAmongDay() {
    final _map = <DateTime, ChartDataItem>{};
    for (var i = 0; i < 24; i++) {
      _map.addAll(_chartDataItem(i));
    }
    for (var i = 0; i < posts.length; i++) {
      final date = posts[i].getTime.toHour();
      _map.update(
        date,
        (value) => ChartDataItem(
          date,
          value.item + 1,
          links: value.links..add(posts[i].link),
        ),
      );
    }
    return _map.values.toList();
  }

  String get meanLikes => getMean(posts, (e) => (e as Post).likeCount);

  String get meanComment => getMean(posts, (e) => (e as Post).commentCount);

  String get meanTags => getMean(tagsCountList, (e) => e as int);

  int get locCount {
    var res = 0;
    for (var i in posts) {
      if (i.isLocation) {
        res += 1;
      }
    }
    return res;
  }
}

class PostFunc {
  const PostFunc._();

  static List<ChartStringItem> postAmongDayPeriod(List<Post> value) {
    var _morning = 0;
    var _day = 0;
    var _evening = 0;
    var _night = 0;
    final _morningLinks = <String>[];
    final _dayLinks = <String>[];
    final _eveningLinks = <String>[];
    final _nightLinks = <String>[];
    for (var i = 0; i < value.length; i++) {
      switch (value[i].getDayPeriod) {
        case PeriodDay.morning:
          _morning++;
          _morningLinks.add(value[i].link);
          break;
        case PeriodDay.day:
          _day++;
          _dayLinks.add(value[i].link);
          break;
        case PeriodDay.evening:
          _evening++;
          _eveningLinks.add(value[i].link);
          break;
        case PeriodDay.night:
          _night++;
          _nightLinks.add(value[i].link);
          break;
      }
    }
    return [
      ChartStringItem(
        dayPeriodStrings[PeriodDay.morning]!,
        _morning,
        _morningLinks,
      ),
      ChartStringItem(
        dayPeriodStrings[PeriodDay.day]!,
        _day,
        _dayLinks,
      ),
      ChartStringItem(
        dayPeriodStrings[PeriodDay.evening]!,
        _evening,
        _eveningLinks,
      ),
      ChartStringItem(
        dayPeriodStrings[PeriodDay.night]!,
        _night,
        _nightLinks,
      ),
    ];
  }

  static Map<PeriodDay, String> dayPeriodMean(
      List<ChartDataItem> postPerPeriod) {
    final resList = <List<ChartStringItem>>[];
    for (var i in postPerPeriod) {
      resList.add(postAmongDayPeriod(i.posts ?? []));
    }
    return {
      PeriodDay.morning:
          getMeanFloat(resList, (e) => (e as List<ChartStringItem>)[0].item),
      PeriodDay.day:
          getMeanFloat(resList, (e) => (e as List<ChartStringItem>)[1].item),
      PeriodDay.evening:
          getMeanFloat(resList, (e) => (e as List<ChartStringItem>)[2].item),
      PeriodDay.night:
          getMeanFloat(resList, (e) => (e as List<ChartStringItem>)[3].item),
    };
  }

  static String meanPost(List<ChartDataItem> postPerPeriod) =>
      getMeanFloat(postPerPeriod, (e) => (e as ChartDataItem).item);
}
