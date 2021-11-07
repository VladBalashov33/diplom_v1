// import 'package:dio/dio.dart';
import 'package:diplom/data_source/local/local_storage.dart';
import 'package:diplom/models/user.dart';
import 'package:diplom/utils/utils.dart';

class UserApi with SendWithToastMixin {
  UserApi();

  // final Dio _client = Static.dio();

  final token = LocalStorageApi.instance.getToken();

  Future<List<User>> getUsers() async {
    // final Response response = await sendWithToast(
    //   tryBloc: _client.post(
    //     '',
    //     options: Options(headers: {'Authorization': token}),
    //   ),
    // );
    // return response;
    await Future.delayed(Constants.delayDuration);
    return [
      User.mock(id: 1),
      User.mock(id: 2),
      User.mock(id: 3),
      User.mock(id: 4),
      User.mock(id: 5),
      User.mock(id: 6),
      User.mock(id: 7),
      User.mock(id: 8),
      User.mock(id: 9),
      User.mock(id: 10),
      User.mock(id: 11),
    ];
  }
}
