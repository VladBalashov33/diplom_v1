import 'package:intl/intl.dart';

import 'chart_item.dart';
import 'location.dart';
import 'user.dart';

class Post {
  final int takenAt;
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

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      takenAt: json['taken_at'] ?? 0,
      id: json['id'] ?? '',
      mediaType: json['media_type'] ?? 0,
      location: CustomLocation.fromJson(json['location'] ?? {}),
      shouldRequestAds: json['should_request_ads'] ?? false,
      likeAndViewCountsDisabled: json['like_and_view_counts_disabled'] ?? false,
      isCommercial: json['is_commercial'] ?? false,
      isPaidPartnership: json['is_paid_partnership'] ?? false,
      commentCount: json['comment_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      link: json['link'] ?? '',
      createdTime: json['created_time'] ?? '',
      type: json['type'] ?? '',
      // TODO: list tags and user in photos
      tags: [], // json['tags'],
      usersInPhoto: [], // json['users_in_photo'],
    );
  }

  DateTime get getTime => DateTime.fromMillisecondsSinceEpoch(takenAt * 1000);
}

class UserPosts {
  List<Post> post;
  List<DateTime> takenAt;
  List<int> mediaType;
  List<CustomLocation> location;
  List<bool> shouldRequestAds;
  List<bool> likeAndViewCountsDisabled;
  List<bool> isCommercial;
  List<bool> isPaidPartnership;
  List<int> commentCount;
  List<int> likeCount;
  List<String> link;
  List<String> createdTime;
  List<String> type;
  Set<String> tags;
  Set<User> usersInPhoto;

  UserPosts({
    required this.post,
    required this.takenAt,
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

  static UserPosts get init => UserPosts(
        post: [],
        takenAt: [],
        mediaType: [],
        location: [],
        shouldRequestAds: [],
        likeAndViewCountsDisabled: [],
        isCommercial: [],
        isPaidPartnership: [],
        commentCount: [],
        likeCount: [],
        link: [],
        createdTime: [],
        type: [],
        tags: {},
        usersInPhoto: {},
      );

  void addPost(Post post) {
    this.post.add(post);
    takenAt.add(post.getTime);
    mediaType.add(post.mediaType);
    location.add(post.location);
    shouldRequestAds.add(post.shouldRequestAds);
    likeAndViewCountsDisabled.add(post.likeAndViewCountsDisabled);
    isCommercial.add(post.isCommercial);
    isPaidPartnership.add(post.isPaidPartnership);
    commentCount.add(post.commentCount);
    likeCount.add(post.likeCount);
    link.add(post.link);
    createdTime.add(post.createdTime);
    type.add(post.type);
    tags.addAll(post.tags);
    usersInPhoto.addAll(post.usersInPhoto);
  }

  List<ChartBoolItem> get isCommercialData => _truFalseData(isCommercial);

  List<ChartBoolItem> _truFalseData(List<bool> list) {
    var _true = 0;
    var _false = 0;
    for (var element in list) {
      element ? _true++ : _false++;
    }
    return [
      ChartBoolItem(true, _true),
      ChartBoolItem(false, _false),
    ];
  }

  static const _countKey = 'count';
  static const _linkKey = 'link';

  List<ChartDataItem> postPerDay() {
    final _map = <String, Map<String, dynamic>>{};

    for (var i = 0; i < takenAt.length; i++) {
      final date = DateFormat.yMd().format(takenAt[i]);
      _map.containsKey(date)
          ? _map.update(
              date,
              (value) {
                final _link = value[_linkKey];
                _link.add(link[i]);
                return {_countKey: value[_countKey] + 1, _linkKey: _link};
              },
            )
          : _map.addAll(
              {
                date: {
                  _countKey: 1,
                  _linkKey: [link[i]]
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
}
