import 'dart:io';

import 'package:dio/dio.dart';
import 'package:diplom/utils/utils.dart';

mixin SendWithToastMixin {
  Future<dynamic> sendWithToast({
    required Future<dynamic> tryBloc,
    bool isToast = true,
    String info = 'info',
    String toast = 'Что-то пошло не так',
  }) async {
    try {
      final result = await tryBloc;
      return result;
    } on DioError catch (e) {
      if (isToast) {
        final data = e.response?.data;
        if (data != null && data.toString().contains(info)) {
          try {
            final String msg = data['$info'] ?? toast;
            // final String msg = data.toString(); //['$info'] ?? toast;
            ToastMsg.showToast(msg);
          } catch (e) {
            ToastMsg.showToast(toast);
          }
        } else {
          ToastMsg.showToast(toast);
        }
      }
      rethrow;
    } on SocketException catch (e) {
      print(' SocketException catch ($e) {');
      ToastMsg.showToast('Проблемы с соединением');
      rethrow;
    } catch (e) {
      print('Произошла непредвиденная ошибка: $e');
      ToastMsg.showToast('Произошла непредвиденная ошибка');
      rethrow;
    }
  }
}

class RepeatInterceptors extends InterceptorsWrapper {
  final Dio baseClient;

  RepeatInterceptors(this.baseClient);

  @override
  Future<void> onError(err, handler) async {
    final isSocket = err.error.toString().contains('SocketException');
    final isTimeOut = err.type == DioErrorType.sendTimeout ||
        err.type == DioErrorType.receiveTimeout ||
        err.type == DioErrorType.connectTimeout;
    if (isTimeOut || isSocket) {
      baseClient.lock();
      await Future.delayed(Constants.repeatDuration);
      baseClient.unlock();
      return handler.resolve(
        await baseClient.request(
          err.requestOptions.path,
          options: Options(
            contentType: err.requestOptions.contentType,
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        ),
      );
    } else {
      return handler.next(err);
    }
  }
}
