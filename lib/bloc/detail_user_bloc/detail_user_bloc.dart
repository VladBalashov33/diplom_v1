import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'detail_user_state.dart';

class DetailUserBloc extends Cubit<DetailUserState> {
  DetailUserBloc() : super(DetailUserInitial());

  List<String> _postLinks = [];
  List<String> get postLinks => _postLinks;
  void Function(List<String>)? setPostLinks(List<String> value) {
    _postLinks = value;
    emit(DetailUserInitial());
  }
}
