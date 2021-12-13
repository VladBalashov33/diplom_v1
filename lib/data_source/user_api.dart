import 'package:dio/dio.dart';
import 'package:diplom/data_source/local/local_storage.dart';
import 'package:diplom/models/user.dart';
import 'package:diplom/utils/utils.dart';

class UserApi with SendWithToastMixin {
  UserApi();

  final Dio _client = Static.dio();

  final token = LocalStorageApi.instance.getToken();

  Future<List<User>> getUsers() async {
    final Response response = await sendWithToast(
      tryBloc: _client.get(
        ApiPath.users,
        options: Options(headers: {'Content-Type': 'application/json'}),
      ),
    );
    return (response.data as List).map((e) => User.fromJson(e)).toList();
  }

  Future<User> getUser(int id) async {
    final Response response = await sendWithToast(
      tryBloc: _client.get(
        ApiPath.user(id),
        options: Options(headers: {'Content-Type': 'application/json'}),
      ),
    );
    return User.fromJson(response.data);
  }

  Future<Response> addUser(String username) async {
    final Response response = await sendWithToast(
      tryBloc: _client.post(
        ApiPath.users,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {'username': username},
      ),
      info: 'username',
    );
    return response;
  }

  Future<Response> deleteUser(int id) async {
    final Response response = await sendWithToast(
      tryBloc: _client.delete(
        ApiPath.userDel(id),
        options: Options(headers: {'Content-Type': 'application/json'}),
      ),
    );
    return response;
  }
}
