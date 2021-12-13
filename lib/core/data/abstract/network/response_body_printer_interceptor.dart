import 'package:dio/dio.dart';

/// интерцептор кототрый логирует запросы
class ResponseBodyPrinterInterceptor extends InterceptorsWrapper {


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
     print(response.data);
    super.onResponse(response, handler);
  }
}
