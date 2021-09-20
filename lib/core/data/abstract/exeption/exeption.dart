/// базовая обработка http ошибок
/// [error] тело ошибки
/// [code] http код ошибки
class HttpRequestException<T> implements Exception {
  T error;
  int code;
  HttpTypeError httpTypeError;

  HttpRequestException(
    this.error,
    this.code,
    this.httpTypeError,
  );
}

enum HttpTypeError {
  unknown,
  notInternetConnection,
  http,
}
