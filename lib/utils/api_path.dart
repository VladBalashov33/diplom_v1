class ApiPath {
  const ApiPath._();

  static const baseUrl = 'http://82.148.18.161:8080/';

  static const users = 'api/user-object/';
  static String user(int id) => '$users$id';
}
