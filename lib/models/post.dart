import 'package:diplom/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final List<User> usersInPhoto;

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
    DateTime? dateTime;
    try {
      dateTime = DateTime.parse(json['date']);
    } catch (e) {}
    return Post(
      id: id,
      takenAt: dateTime ?? DateTime(1900),
      link: json['link'] ?? '',
      type: json['type'] ?? '',
      likeCount: json['likes'] ?? 0,
      mediaType: json['media_type'] ?? 0,
      commentCount: json['comments'] ?? 0,
      tags: [], // json['hashtags'],
      usersInPhoto: [], // json['friends'],
      //===
      location: CustomLocation.fromJson(json['location'] ?? {}),
      shouldRequestAds: json['should_request_ads'] ?? false,
      likeAndViewCountsDisabled: json['like_and_view_counts_disabled'] ?? false,
      isCommercial: json['is_commercial'] ?? false,
      isPaidPartnership: json['is_paid_partnership'] ?? false,
      createdTime: json['created_time'] ?? '',
    );
  }
  // factory Post.fromJson(Map<String, dynamic> json) {
  //   return Post(
  //     takenAt: json['taken_at'] ?? 0,
  //     id: json['id'] ?? '',
  //     mediaType: json['media_type'] ?? 0,
  //     location: CustomLocation.fromJson(json['location'] ?? {}),
  //     shouldRequestAds: json['should_request_ads'] ?? false,
  //     likeAndViewCountsDisabled: json['like_and_view_counts_disabled'] ?? false,
  //     isCommercial: json['is_commercial'] ?? false,
  //     isPaidPartnership: json['is_paid_partnership'] ?? false,
  //     commentCount: json['comment_count'] ?? 0,
  //     likeCount: json['like_count'] ?? 0,
  //     link: json['link'] ?? '',
  //     createdTime: json['created_time'] ?? '',
  //     type: json['type'] ?? '',
  //     // TODO: list tags and user in photos
  //     tags: [], // json['tags'],
  //     usersInPhoto: [], // json['users_in_photo'],
  //   );
  // }

  DateTime get getTime => takenAt;
}

class UserPosts {
  List<Post> posts;
  Set<String> tags;
  Set<User> usersInPhoto;

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
    tags.addAll(post.tags);
    usersInPhoto.addAll(post.usersInPhoto);
  }

  UserPosts getPostInRange(DateTimeRange range) {
    final _start = range.start;
    final _end = range.end;
    final _posts = <Post>[];
    _posts.addAll(posts);
    _posts.removeWhere(
      (e) => e.getTime.isAfter(_start) || e.getTime.isBefore(_end),
    );
    return UserPosts(
      posts: _posts,
      tags: tags,
      usersInPhoto: usersInPhoto,
    );
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

  static const _countKey = 'count';
  static const _linkKey = 'link';

  List<ChartDataItem> postPerDay() {
    final _map = <DateTime, Map<String, dynamic>>{};

    for (var i = 0; i < posts.length; i++) {
      final date = posts[i].getTime.toDay();
      _map.containsKey(date)
          ? _map.update(
              date,
              (value) {
                final _link = value[_linkKey];
                _link.add(posts[i].link);
                return {_countKey: value[_countKey] + 1, _linkKey: _link};
              },
            )
          : _map.addAll(
              {
                date: {
                  _countKey: 1,
                  _linkKey: [posts[i].link]
                }
              },
            );
    }
    final _list = <ChartDataItem>[];
    _map.forEach((key, value) {
      _list.add(ChartDataItem(key, value[_countKey], links: value[_linkKey]));
    });
    return _list;
  }

  List<ChartDataItem> postAmongDay() {
    final _map = <DateTime, Map<String, dynamic>>{
      DateTime(1900, 1, 1, 0, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 1, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 2, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 3, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 4, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 5, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 6, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 7, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 8, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 9, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 10, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 11, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 12, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 13, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 14, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 15, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 16, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 17, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 18, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 19, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 20, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 21, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 22, 0): {_countKey: 0, _linkKey: <String>[]},
      DateTime(1900, 1, 1, 23, 0): {_countKey: 0, _linkKey: <String>[]},
    };

    for (var i = 0; i < posts.length; i++) {
      final date = posts[i].getTime.toHour();
      _map.update(
        date,
        (value) {
          final _link = value[_linkKey];
          _link.add(posts[i].link);
          return {_countKey: value[_countKey] + 1, _linkKey: _link};
        },
      );
    }
    final _list = <ChartDataItem>[];
    _map.forEach((key, value) {
      _list.add(ChartDataItem(key, value[_countKey], links: value[_linkKey]));
    });
    return _list;
  }
}
