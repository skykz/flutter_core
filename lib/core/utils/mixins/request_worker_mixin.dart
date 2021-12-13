import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_core/core/data/abstract/exeption/exeption.dart';

typedef CoreResultData<T> = void Function(T result);

/// результат выполнения загрузчика (лоадера)
typedef CoreLoadingData = void Function(bool isLoading);
mixin CoreRequestWorketMixin {
  /// Timer для запроса
  Timer _timer;

  String _defaultError = "Произошла ошибка";

  /// показываем ошибку в виде [String]
  /// [errorMessage] сообщение об ошибке
  Function(String errorMessage) showErrorCallback;

  /// показывает сообщение об ошибке с возможность передачи http кода
  /// [errorMessage] сообщение об ошибке
  /// [code] http код ошибки
  Function(String errorMessage, int code) showErrorByCodeCallback;

  /// показывает сообщение об ошибке при отсутвии интернета
  /// [errorMessage] сообщение об ошибке
  Function(String errorMessage) showErrorInternetConnection;

  /// показывает сообщение об ошибке при cбое самого приложения
  /// [errorMessage] сообщение об ошибке
  Function(String errorMessage) showErrorExeptionCallback;

  /// функиця безопастно запускает запрос без обработки пользовательской
  ///  ошибки(будут выводиться ошибки в стандартных полях предусмотренные сервером)
  /// [request] запрос принимает фнкция useCase
  /// [loading] callback функция информирующая старт загрузки
  /// [resultState] callback успешном результате
  /// [errorState]  callback при ошибке

  void launch<T>({
    Future<T> request,
    CoreLoadingData loading,
    CoreResultData<T> resultData,
    CoreResultData<String> errorData,
  }) async {
    loading?.call(true);
    try {
      final result = await request;
      loading?.call(false);
      resultData?.call(result);
    } on HttpRequestException catch (ex) {
      loading?.call(false);
      _makeHttpExeption(ex, (error) {
        if (errorData == null) {
          showErrorCallback?.call(error?.error?.toString());
          return;
        }
        errorData?.call(error?.error?.toString());
      });
    } catch (ex) {
      loading?.call(false);
      _makeExeption(ex);
    }
  }

  /// функиця безопастно запускает запрос c обработкой пользовательской
  ///  ошибки c возможностью добавить задержку
  /// [delay] время задержки запроса
  /// [request] запрос принимает фнкция useCase
  /// [loading] callback функция информирующая старт загрузки
  /// [resultState] callback успешном результате
  /// [errorState]  callback при ошибке
  void launchDelayWithError<T, V extends HttpRequestException>(
    int delay, {
    Future<T> request,
    CoreLoadingData loading,
    CoreResultData<T> resultData,
    @required Function(V) errorData,
  }) async {
    _delay(delay, () async {
      loading?.call(true);
      try {
        final result = await request;
        loading?.call(false);
        resultData?.call(result);
      } on HttpRequestException catch (ex) {
        loading?.call(false);
        _makeHttpExeption(
          ex,
          (error) => errorData?.call(ex),
        );
      } catch (ex, s) {
        loading?.call(false);
        _makeExeption(s);
      }
    });
  }

  /// функиця безопастно запускает запрос c обработкой пользовательской
  ///  ошибки c возможностью добавить задержку
  /// [request] запрос принимает фнкция useCase
  /// [loading] callback функция информирующая старт загрузки
  /// [resultState] callback успешном результате
  /// [errorState]  callback при ошибке
  void launchWithError<T, V extends HttpRequestException>({
    Future<T> request,
    CoreLoadingData loading,
    CoreResultData<T> resultData,
    @required Function(V) errorData,
  }) async {
    loading?.call(true);
    try {
      final result = await request;
      loading?.call(false);
      resultData?.call(result);
    } on HttpRequestException catch (ex) {
      loading?.call(false);
      _makeHttpExeption(
        ex,
        (error) => errorData?.call(ex),
      );
    } catch (ex, s) {
      loading?.call(false);
      _makeExeption(s);
    }
  }

  /// функиця безопастно запускает запрос без обработки пользовательской
  ///  ошибки(будут выводиться ошибки в стандартных полях предусмотренные сервером)
  /// [delay] время задержки запроса
  /// [request] запрос принимает фнкция useCase
  /// [loading] callback функция информирующая старт загрузки
  /// [resultState] callback успешном результате
  /// [errorState]  callback при ошибке
  void launchDelay<T>(
    int delay, {
    Future<T> request,
    CoreLoadingData loading,
    CoreResultData<T> resultData,
    CoreResultData<String> errorData,
  }) async {
    _delay(delay, () async {
      loading?.call(true);
      try {
        final result = await request;
        loading?.call(false);
        resultData?.call(result);
      } on HttpRequestException catch (ex) {
        loading?.call(false);
        _makeHttpExeption(ex, (error) {
          if (errorData == null) {
            showErrorCallback?.call(error?.error?.toString());
            return;
          }
          errorData?.call(error?.error?.toString());
        });
      } catch (ex) {
        loading?.call(false);
        _makeExeption(ex);
      }
    });
  }

  void clear() {
    _timer = null;
  }

  /// отображает http ошибки
  void _makeHttpExeption<T>(
    HttpRequestException ex,
    Function(HttpRequestException ex) httpException,
  ) {
    if (ex.httpTypeError == HttpTypeError.notInternetConnection) {
      showErrorInternetConnection.call(ex.error);
      return;
    }

    httpException?.call(ex);

    showErrorByCodeCallback?.call(
      ex.error.toString(),
      ex.code,
    );
  }

  /// функция запускает таймер на определенное время
  void _delay(int delay, Function run) {
    if (_timer?.isActive ?? false) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: delay), () async {
      run?.call();
    });
  }

  /// отображает различные исключения
  void _makeExeption(ex) {
    showErrorExeptionCallback.call(_defaultError);
    print(ex);
  }
}
