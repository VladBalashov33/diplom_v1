class ApiPath {
  const ApiPath._();

  static const baseUrl = 'http://82.148.18.161:8080/';
  static const instUrl = 'https://www.instagram.com';

  static const users = 'api/user-object/';
  static String user(int id) => '$users$id';
  static String userDel(int id) => '$users$id/';

  static String getInfoHashtag(String tag) =>
      '$instUrl/explore/tags/$tag/?__a=1';
  static String getInfoUser(String name) => '$instUrl/$name/?__a=1';

  static String hashtagLink(String tag) => '$instUrl/explore/tags/$tag/';
  static String userLink(String name) => '$instUrl/$name/';
}
