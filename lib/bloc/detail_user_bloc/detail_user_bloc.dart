import 'package:bloc/bloc.dart';
import 'package:diplom/data_source/user_repo.dart';
import 'package:diplom/models/post.dart';
import 'package:diplom/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'detail_user_state.dart';

class DetailUserBloc extends Cubit<DetailUserState> {
  DetailUserBloc(this.id) : super(DetailUserLoading()) {
    getUser();
  }
  final int id;

  final _repository = UserRepository();

  void addInitialEvent(UserPosts value) => emit(DetailUserInitial(value));
  void addLoadingEvent() => emit(DetailUserLoading());

  User? _user;

  User get user => _user ?? User();

  UserPosts get posts {
    if (dateRange != null) {
      return _posts.getPostInRange(dateRange!);
    }
    return _posts;
  }

  UserPosts get _posts {
    if (state is DetailUserInitial) {
      return (state as DetailUserInitial).posts;
    } else {
      return UserPosts.init;
    }
  }

  DateTimeRange? _dateRange;
  DateTimeRange? get dateRange => _dateRange;
  void Function(DateTimeRange?)? setDateRange(DateTimeRange? value) {
    _dateRange = value;
    emit(state);
  }

  List<String> _postLinks = [];
  List<String> get postLinks => _postLinks;
  void Function(List<String>)? setPostLinks(List<String> value) {
    _postLinks = value;
    emit(state);
  }

  Future<void> getUser() async {
    addLoadingEvent();
    return _repository.getUser(id).then((value) {
      _user = value;
      addInitialEvent(value.postInfo ?? UserPosts.init);
    }, onError: (e) {
      print('=getUser=$e==');
      addInitialEvent(UserPosts.init);
    });
  }
}
