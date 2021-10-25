class ApiPath {
  const ApiPath._();

  static const baseUrl = 'http://0.0.0.0:8000/api/v1/';

  static const signin = 'auth/signin/';
  static String productFromCategory(int id) => 'product/categories/$id';
}
