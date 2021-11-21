// ignore_for_file: unnecessary_overrides

part of 'choose_user_bloc.dart';

@immutable
abstract class ChooseUserState {
  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}

class ChooseUserInitial extends ChooseUserState {}

class ChooseUserSuccess extends ChooseUserState {}

class ChooseUserLoading extends ChooseUserState {}
