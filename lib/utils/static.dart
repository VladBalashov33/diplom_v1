import 'dart:developer';

import 'package:dio/dio.dart';

import 'utils.dart';

class Static {
  Static._();

  static Dio dio({String? newUrl, bool responseBody = true}) {
    final baseClient = Dio(
      BaseOptions(
        baseUrl: newUrl ?? ApiPath.baseUrl,
      ),
    );
    baseClient.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: responseBody,
        logPrint: (value) => log('$value'),
      ),
    );
    baseClient.interceptors.add(RepeatInterceptors(baseClient));
    return baseClient;
  }
}
