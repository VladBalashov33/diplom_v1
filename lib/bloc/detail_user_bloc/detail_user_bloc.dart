import 'package:bloc/bloc.dart';
import 'package:diplom/models/post.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'detail_user_state.dart';

class DetailUserBloc extends Cubit<DetailUserState> {
  DetailUserBloc(this._posts) : super(DetailUserInitial());

  final UserPosts _posts;
  UserPosts get posts {
    if (dateRange != null) {
      return _posts.getPostInRange(dateRange!);
    }
    return _posts;
  }

  DateTimeRange? _dateRange;
  DateTimeRange? get dateRange => _dateRange;
  void Function(DateTimeRange?)? setDateRange(DateTimeRange? value) {
    _dateRange = value;
    emit(DetailUserInitial());
  }

  List<String> _postLinks = [];
  List<String> get postLinks => _postLinks;
  void Function(List<String>)? setPostLinks(List<String> value) {
    _postLinks = value;
    emit(DetailUserInitial());
  }
}
