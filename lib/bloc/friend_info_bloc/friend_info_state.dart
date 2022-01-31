part of 'friend_info_bloc.dart';

@immutable
abstract class FriendInfoState {}

class FriendInfoInitial extends FriendInfoState {}

class FriendInfoLoading extends FriendInfoState {}

class FriendInfoErr extends FriendInfoState {}
