// ignore_for_file: unnecessary_overrides

part of 'detail_user_bloc.dart';

@immutable
abstract class DetailUserState {
  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  int get hashCode => super.hashCode;

  final UserPosts? posts;
  const DetailUserState(this.posts);
}

class DetailUserPosts extends DetailUserState {
  const DetailUserPosts(UserPosts posts) : super(posts);
}

class DetailUserStores extends DetailUserState {
  const DetailUserStores(UserPosts posts) : super(posts);
}

class DetailUserAll extends DetailUserState {
  const DetailUserAll(UserPosts posts) : super(posts);
}

class DetailUserLoading extends DetailUserState {
  const DetailUserLoading() : super(null);
}

class DetailUserErr extends DetailUserState {
  const DetailUserErr() : super(null);
}
