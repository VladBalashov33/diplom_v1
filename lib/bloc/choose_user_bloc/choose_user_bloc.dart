import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diplom/data_source/user_repo.dart';
import 'package:diplom/models/user.dart';
import 'package:diplom/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'choose_user_state.dart';

class ChooseUserBloc extends Cubit<ChooseUserState> {
  ChooseUserBloc() : super(ChooseUserInitial()) {
    getUsers();
  }

  final _repository = UserRepository();

  void addInitialEvent() => emit(ChooseUserInitial());
  void addLoadingEvent() => emit(ChooseUserLoading());
  void addSuccessEvent() => emit(ChooseUserSuccess());

  List<User> _users = const [];

  List<User> get users => _isRevers ? _sortUsers.reversed.toList() : _sortUsers;

  List<User> get unSortUsers {
    final newUser = <User>[];
    newUser.addAll(_users);
    newUser.removeWhere(
      (e) => _subsRange.start > e.subscribers || e.subscribers > _subsRange.end,
    );
    return newUser;
  }

  bool _isRevers = false;
  bool get getIsRevers => _isRevers;
  void Function(String)? setIsRevers(value) {
    _isRevers = value;
    addInitialEvent();
  }

  SortType _sortType = SortType.name;
  SortType get getSortType => _sortType;
  void Function(String)? setSortType(SortType value) {
    _sortType = value;
    addInitialEvent();
  }

  Timer? _timer;

  late RangeValues subsRangeInit;
  RangeValues _subsRange = const RangeValues(0, 0);
  RangeValues get getSubsRange => _subsRange;
  void Function(String)? setSubsRange(RangeValues value) {
    _timer?.cancel();
    _timer = Timer(
      const Duration(seconds: 1),
      () {
        _subsRange = value;
        addInitialEvent();
      },
    );
  }

  RangeValues getInitSubsRange(List<User> newUsers) {
    // ignore: avoid_types_on_closure_parameters
    newUsers = sortedWithKey(_users, (User a) => a.subscribers);
    if (newUsers.isNotEmpty) {
      return RangeValues(0, newUsers.last.subscribers.toDouble().to100());
    }
    return const RangeValues(0, 1000000);
  }

  Future<void> getUsers() async {
    addLoadingEvent();
    return _repository.getUsers().then((value) {
      _users = value;
      subsRangeInit = getInitSubsRange(_users);
      _subsRange = subsRangeInit;
      addSuccessEvent();
    }, onError: (e) {
      print('=getUsers=$e==');
      addSuccessEvent();
    });
  }

  Future<void> addUser(String username) async {
    addLoadingEvent();
    return _repository.addUser(username).then((value) {
      ToastMsg.showToast('Пользователь добавлен');
      getUsers();
    }, onError: (e) {
      print('=getUsers=$e==');
      addSuccessEvent();
    });
  }

  List<User> get _sortUsers {
    switch (_sortType) {
      case SortType.username:
        return getUsernameSort;
      case SortType.name:
        return getNameSort;
      case SortType.lastActivity:
        return getLastActivitySort;
      case SortType.subscribers:
        return getSubscribersSort;
      case SortType.postCount:
        return getPostCountSort;
      default:
        return unSortUsers;
    }
  }

  List<User> get getUsernameSort {
    return sortedWithKey(unSortUsers, (k) => k.username);
  }

  List<User> get getNameSort {
    return sortedWithKey(unSortUsers, (k) => k.name);
  }

  List<User> get getLastActivitySort {
    return sortedWithKey(
        unSortUsers, (k) => k.lastActivity ?? DateTime(1990, 1, 1));
  }

  List<User> get getSubscribersSort {
    return sortedWithKey(unSortUsers, (a) => a.subscribers);
  }

  List<User> get getPostCountSort {
    return sortedWithKey(unSortUsers, (a) => a.countPublished);
  }

  List<E> sortedWithKey<E, K extends Comparable<Object>>(
    Iterable<E> items,
    K Function(E) toKey,
  ) {
    final keyPairs = [
      for (var element in items) _SortableKeyPair(element, toKey(element)),
    ]..sort();

    return [
      for (var keyPair in keyPairs) keyPair.original,
    ];
  }
}

class _SortableKeyPair<T, K extends Comparable<Object>>
    implements Comparable<_SortableKeyPair<T, K>> {
  _SortableKeyPair(this.original, this.key);

  final T original;
  final K key;

  @override
  int compareTo(_SortableKeyPair<T, K> other) => key.compareTo(other.key);
}
