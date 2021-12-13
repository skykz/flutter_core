import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
import 'package:flutter_core/core/abstarct/constant/core_network_constant.dart';
import 'package:flutter_core/core/data/abstract/exeption/exeption.dart';
import 'package:flutter_core/core/data/abstract/model/default_error.dart';

/// функция для получения резултата
typedef ResponseJson<T> = T Function(dynamic);

/// функция для получения пользователькой ошибка
/// [dynamic] ошибка в виде json
/// [String] ошибка по умалчанию
typedef ErrorResponsePrinter<T> = HttpRequestException<T> Function(
    dynamic, String, int);

/// вызов безопасно http функцию с обработкой пользовтелькой ошибки
/// T отвер сервера
Future<T> safeApiCall<T>(
  Future<Response> response,
  ResponseJson<T> jsonCall, {
  bool isTest,
}) async {
  await _makeThrowInternerConnection(isTest);
  try {
    final result = await response;
    final json = result.data;
    return jsonCall.call(json);
  } catch (ex) {
    if (ex is DioError) {
      final data = ex.response?.data;
      final message = _handleDioErrorType(ex, data);
      throw HttpRequestException<String>(
        message,
        ex.response?.statusCode ?? CoreConstant.negative,
        HttpTypeError.http,
      );
    }
    throw _throwDefaultError(ex);
  }
}

/// вызов безопасно http функцию возвращает void (вызывать в случае пустого ответа)
/// [response] - ответ от сервера
Future<void> safeApiCallVoid(
  Future<Response> response, {
  bool isTest,
}) async {
  await _makeThrowInternerConnection(isTest);
  try {
    await response;
    return;
  } catch (ex) {
    if (ex is DioError) {
      final data = ex.response?.data;
      final message = _handleDioErrorType(ex, data);
      throw HttpRequestException<String>(
        message,
        ex.response?.statusCode ?? CoreConstant.negative,
        HttpTypeError.http,
      );
    }
    throw _throwDefaultError(ex);
  }
}

/// вызов безопасно http функцию
/// T отвер сервера
/// V ответ сервера в виде ошибки
Future<T> safeApiCallWithError<T, V>(
  Future<Response> response,
  ResponseJson<T> jsonCall,
  ErrorResponsePrinter<V> errorResponsePrinter, {
  bool isTest,
}) async {
  await _makeThrowInternerConnection(isTest);
  try {
    final result = await response;
    final json = result.data;
    return jsonCall.call(json);
  } catch (ex) {
    if (ex is DioError) {
      final data = ex.response?.data;
      throw errorResponsePrinter.call(
        data,
        _handleDioErrorType(ex),
        ex.response?.statusCode ?? CoreConstant.negative,
      );
    }

    throw _throwDefaultError(ex);
  }
}

/// выкидывает исключение в виде ошибки по умалчанию
HttpRequestException<String> _throwDefaultError(Exception exception) {
  return HttpRequestException<String>(
    exception.toString(),
    CoreConstant.negative,
    HttpTypeError.unknown,
  );
}

/// вызывает исключение при отсутсии интернета
Future<HttpRequestException<String>> _makeThrowInternerConnection(
  bool isTest,
) async {
  if (isTest != true) {
    final isInternerConnection = await _checkInternetConnection();
    if (!isInternerConnection) {
      throw HttpRequestException<String>(
        "Нет интернет соеденения",
        CoreConstant.negative,
        HttpTypeError.notInternetConnection,
      );
    }
  }
}

/// проверка интернет соеденения
Future<bool> _checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

/// обработчик ошибок по типу ошибко [Dio]
/// [DioErrorType] ошибка
String _handleDioErrorType(DioError ex, [Map<String, dynamic> data]) {
  switch (ex.type) {
    case DioErrorType.connectTimeout:
    case DioErrorType.sendTimeout:
    case DioErrorType.receiveTimeout:
      {
        return "Время таймаута истекло";
      }
    default:
      {
        if (ex.message.contains(CoreNetworkConstant.socketException)) {
          return "Ошибка соеденения";
        }
        return data != null ? Error.fromJson(data).message : "Ошибка сервера";
      }
  }
}
