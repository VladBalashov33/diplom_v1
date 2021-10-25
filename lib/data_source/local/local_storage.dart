import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageApi {
  final _tokenKey = 'auth_token';

  static late LocalStorageApi _instance;

  static LocalStorageApi get instance => _instance;

  late SharedPreferences _sharedPreferences;

  factory LocalStorageApi() {
    return _instance;
  }

  LocalStorageApi._internal();

  static Future<void> init() async {
    _instance = LocalStorageApi._internal();
    _instance._sharedPreferences = await SharedPreferences.getInstance();
  }

  String? getToken() {
    final value = _getForKey(key: _tokenKey);
    if (value == null) {
      return value;
    } else {
      return 'Token $value';
    }
  }

  Future<void> saveToken(String token) async {
    return _saveForKey(key: _tokenKey, value: token);
  }

  void _saveForKey({required String key, required String value}) =>
      _sharedPreferences.setString(key, value);

  String? _getForKey({required String key}) =>
      _sharedPreferences.getString(key);

  void dropToken() {
    _sharedPreferences.remove(_tokenKey);
  }
}
