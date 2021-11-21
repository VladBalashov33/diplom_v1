import 'package:bloc/bloc.dart';
import 'package:diplom/data_source/user_repo.dart';
import 'package:diplom/models/user.dart';
import 'package:diplom/utils/constants.dart';
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

  Future<void> getUsers() async {
    addLoadingEvent();
    return _repository.getUsers().then((value) {
      _users = value;
      addSuccessEvent();
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
        return _users;
    }
  }

  List<User> get users => _isRevers ? _sortUsers.reversed.toList() : _sortUsers;

  // Comparator<User> sortById = (a, b) =>
  // a.subscribers.compareTo(b.subscribers);

  // List<User> get getSubSort2 {
  //   final sss = <User>[];
  //   sss.addAll(users);
  //   sss.sort(sortById);
  //   return sss;
  // }

  List<User> get getUsernameSort {
    return sortedWithKey(_users, (k) => k.username);
  }

  List<User> get getNameSort {
    return sortedWithKey(_users, (k) => k.name);
  }

  List<User> get getLastActivitySort {
    return sortedWithKey(_users, (k) => k.lastActivity ?? DateTime(1990, 1, 1));
  }

  List<User> get getSubscribersSort {
    return sortedWithKey(_users, (a) => a.subscribers);
  }

  List<User> get getPostCountSort {
    return sortedWithKey(_users, (a) => a.countPublished);
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
