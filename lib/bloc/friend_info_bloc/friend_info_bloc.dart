import 'package:bloc/bloc.dart';
import 'package:diplom/data_source/user_repo.dart';
import 'package:diplom/models/hashtag.dart';
import 'package:diplom/models/user.dart';
import 'package:meta/meta.dart';

part 'friend_info_state.dart';

class FriendInfoBloc extends Cubit<FriendInfoState> {
  FriendInfoBloc({
    required this.isHashtag,
    this.name,
  }) : super(FriendInfoLoading()) {
    if (name != null) {
      _getInfo();
    } else {
      addInitialEvent();
    }
  }

  final bool isHashtag;
  final String? name;
  final _repository = UserRepository();

  void addInitialEvent() => emit(FriendInfoInitial());
  void addLoadingEvent() => emit(FriendInfoLoading());
  void addErrEvent() => emit(FriendInfoErr());

  Hashtag? hashtag;
  User? friend;

  Future<void> _getInfo() async {
    addLoadingEvent();
    if (isHashtag) {
      return _repository.getInfoHashtag(name!).then((value) {
        hashtag = value;
        addInitialEvent();
      }, onError: (e) {
        print('=getInfo=$e==');
        addErrEvent();
      });
    } else {
      return _repository.getInfoUser(name!).then((value) {
        friend = value;
        addInitialEvent();
      }, onError: (e) {
        print('=getInfo=$e==');
        addErrEvent();
      });
    }
  }
}
