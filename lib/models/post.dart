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
  final List<Post> posts;
  final Map<String, ChartStringItem> tags;
  final Map<String, ChartStringItem> usersInPhoto;

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
        ),
        ifAbsent: () => ChartDataItem(date, 1, links: [posts[i].link]),
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
}
