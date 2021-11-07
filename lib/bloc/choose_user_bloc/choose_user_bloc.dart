import 'package:bloc/bloc.dart';
import 'package:diplom/data_source/user_repo.dart';
import 'package:diplom/models/user.dart';
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

  List<User> users = const [];

  Future<void> getUsers() async {
    addLoadingEvent();
    return _repository.getUsers().then((value) {
      users = value;
      addSuccessEvent();
    }, onError: (e) {
      print('=getUsers=$e==');
      addSuccessEvent();
    });
  }
}
