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
}

class DetailUserInitial extends DetailUserState {
  final UserPosts posts;
  DetailUserInitial(this.posts);
}

class DetailUserLoading extends DetailUserState {}
