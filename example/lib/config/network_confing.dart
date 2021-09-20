import 'package:dio/dio.dart';
import 'package:flutter_core/core/data/abstract/network/response_body_printer_interceptor.dart';

Dio createHttpClient() {
  Dio dio = new Dio();
  dio.options.baseUrl = "https://api.github.com/";
  dio.options.connectTimeout = 50000; //5s
  dio.options.receiveTimeout = 30000;
  dio.interceptors
    ..add(LogInterceptor(requestBody: true))
    ..add(ResponseBodyPrinterInterceptor());

  return dio;
}
