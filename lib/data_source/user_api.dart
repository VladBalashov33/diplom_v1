import 'package:dio/dio.dart';
import 'package:diplom/data_source/local/local_storage.dart';
import 'package:diplom/models/hashtag.dart';
import 'package:diplom/models/user.dart';
import 'package:diplom/utils/utils.dart';

class UserApi with SendWithToastMixin {
  UserApi();

  final Dio _client = Static.dio();
  final Dio _clientInst = Static.dio(
    newUrl: ApiPath.instUrl,
    responseBody: false,
  );

  final token = LocalStorageApi.instance.getToken();

  Future<List<User>> getUsers() async {
    // return [
    //   User.mock(id: 1),
    //   User.mock(id: 2),
    // ];
    final Response response = await sendWithToast(
      tryBloc: _client.get(
        ApiPath.users,
        options: Options(headers: {'Content-Type': 'application/json'}),
      ),
    );
    return (response.data as List).map((e) => User.fromJson(e)).toList();
  }

  Future<User> getUser(int id) async {
    // return User.mock(id: id);
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

  Future<Hashtag> getInfoHashtag(String hashtag) async {
    final Response response = await sendWithToast(
      tryBloc: _clientInst.get(
        ApiPath.getInfoHashtag(hashtag),
        options: Options(headers: {'Content-Type': 'application/json'}),
      ),
    );
    return Hashtag.fromJson(response.data);
  }

  Future<User> getInfoUser(String name) async {
    final Response response = await sendWithToast(
      tryBloc: _clientInst.get(
        ApiPath.getInfoUser(name),
        options: Options(headers: {'Content-Type': 'application/json'}),
      ),
    );
    return User.fromJsonInst(response.data, ApiPath.userLink(name));
  }
}
