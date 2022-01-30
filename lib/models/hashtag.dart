// ignore_for_file: lines_longer_than_80_chars

class Hashtag {
  final String id;
  final int mediaCount;
  final int userPostCount;
  final String link;
  final String? pic;

  Hashtag({
    this.id = '0',
    this.mediaCount = 0,
    this.userPostCount = 0,
    this.link = '',
    this.pic,
  });

  factory Hashtag.fromJson(Map<String, dynamic> json) {
    return Hashtag(
      id: '${json['id'] ?? 0}',
      mediaCount: json['media_count'] ?? 0,
      pic: json['profile_pic_url'],
    );
  }

  Hashtag copyWith({
    String? link,
    int? userPostCount,
  }) {
    return Hashtag(
      id: id,
      mediaCount: mediaCount,
      link: link ?? this.link,
      userPostCount: userPostCount ?? this.userPostCount,
      pic: pic,
    );
  }
}
