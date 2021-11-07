import 'dart:math';

import 'package:diplom/utils/constants.dart';

class User {
  final int id;
  final String name;
  final String username;
  final String? photo;
  final num subscribers;

  User({
    this.id = 0,
    this.name = '',
    this.username = '',
    this.photo,
    this.subscribers = 0,
  });

  factory User.mock({int? id}) {
    final random = Random();
    return User(
      id: id ?? 0,
      name: 'cat',
      username: 'CatCat',
      photo: Constants.mockImage,
      subscribers: (id ?? 0) * 1000 * random.nextInt(90),
    );
  }
}
