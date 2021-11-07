import 'package:diplom/models/user.dart';

import 'user_api.dart';

class UserRepository {
  final _api = UserApi();

  Future<List<User>> getUsers() async {
    return await _api.getUsers();
  }
}
