import 'package:dio/dio.dart';
import 'package:diplom/models/user.dart';

import 'user_api.dart';

class UserRepository {
  final _api = UserApi();

  Future<List<User>> getUsers() async {
    return await _api.getUsers();
  }

  Future<User> getUser(int id) async {
    return await _api.getUser(id);
  }

  Future<Response> addUser(String username) async {
    return await _api.addUser(username);
  }

  Future<Response> delUser(int id) async {
    return await _api.deleteUser(id);
  }
}
