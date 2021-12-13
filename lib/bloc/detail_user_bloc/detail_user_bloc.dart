import 'package:bloc/bloc.dart';
import 'package:diplom/data_source/user_repo.dart';
import 'package:diplom/models/post.dart';
import 'package:diplom/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'detail_user_state.dart';

class DetailUserBloc extends Cubit<DetailUserState> {
  DetailUserBloc(this.id) : super(const DetailUserLoading()) {
    getUser();
  }
  final int id;

  final _repository = UserRepository();

  void addPostsEvent() => emit(DetailUserPosts(user.getPostInfo));
  void addStoresEvent() => emit(DetailUserStores(user.getStoryInfo));
  void addAllEvent() {
    final res = UserPosts.init;
    user.getPostInfo.posts.forEach(res.addPost);
    user.getStoryInfo.posts.forEach(res.addPost);
    emit(DetailUserAll(res));
  }

  void addLoadingEvent() => emit(const DetailUserLoading());
  void addErrEvent() => emit(const DetailUserErr());
  void addDelEvent() => emit(const DetailUserDelete());

  User? _user;

  User get user => _user ?? User();

  UserPosts get posts {
    if (dateRange != null) {
      return _posts.getPostInRange(dateRange!);
    }
    return _posts;
  }

  UserPosts get _posts {
    return state.posts ?? UserPosts.init;
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
      addPostsEvent();
    }, onError: (e) {
      print('=getUser=$e==');
      addErrEvent();
    });
  }

  Future<void> delUser() async {
    addLoadingEvent();
    return _repository.delUser(id).then((value) {
      ToastMsg.showToast('Пользователь удален');
      addDelEvent();
    }, onError: (e) {
      print('=getUser=$e==');
      addPostsEvent();
    });
  }

  void switchState({required bool isPost, required bool isStory}) {
    if (isPost && isStory) {
      addAllEvent();
      return;
    }
    if (!isPost && isStory) {
      addStoresEvent();
      return;
    }
    if (isPost && !isStory) {
      addPostsEvent();
      return;
    }
    if (!isPost && !isStory) {
      addErrEvent();
      return;
    }
  }
}
