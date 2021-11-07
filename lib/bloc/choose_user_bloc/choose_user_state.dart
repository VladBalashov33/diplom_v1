part of 'choose_user_bloc.dart';

@immutable
abstract class ChooseUserState {}

class ChooseUserInitial extends ChooseUserState {}

class ChooseUserSuccess extends ChooseUserState {}

class ChooseUserLoading extends ChooseUserState {}
