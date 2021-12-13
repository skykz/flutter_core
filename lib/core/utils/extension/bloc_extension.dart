import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/core/data/abstract/exeption/exeption.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';

/// результат выполнения запроса успешного ответа
@deprecated
typedef ResultState<T> = CoreState Function(T result);

/// результат выполнения загрузчика (лоадера)
@deprecated
typedef LoadingState = CoreState Function(bool isLoading);

/// расширение работает с [Bloc]
extension LaunchRequestExtension on Bloc {
  /// функиця безопастно запускает запрос без обработки пользовательской
  ///  ошибки(будут выводиться ошибки в стандартных полях предусмотренные сервером)
  /// [request] запрос принимает фнкция useCase
  /// [loading] callback функция информирующая старт загрузки
  /// [resultState] callback успешном результате
  /// [errorState]  callback при ошибке
  @deprecated
  Stream<CoreState> launch<T>(Future<T> request, LoadingState loading,
      ResultState<T> resultState, ResultState<String> errorState) async* {
    yield loading.call(true);
    try {
      final result = await request;
      yield loading.call(false);
      yield resultState.call(result);
    } catch (ex) {
      yield loading.call(false);
      if (ex is HttpRequestException<String>) {
        yield errorState.call(ex.error.toString());
      } else {
        yield errorState.call(ex.toString());
      }
    }
  }

  /// функиця безопастно запускает запрос c обработкой пользовательской
  ///  ошибки(будут выводиться ошибки в стандартных полях предусмотренные сервером)
  /// [request] запрос принимает фнкция useCase
  /// [loading] callback функция информирующая старт загрузки
  /// [resultState] callback успешном результате
  /// [errorState]  callback при ошибке
  @deprecated
  Stream<CoreState> launchWithError<T, V>(
      Future<T> request,
      LoadingState loading,
      ResultState<T> resultState,
      ResultState<V> errorState) async* {
    yield loading.call(true);
    try {
      final result = await request;
      yield loading.call(false);
      yield resultState.call(result);
    } catch (ex) {
      yield loading.call(false);
      if (ex is HttpRequestException<V>) {
        yield errorState.call(ex.error);
      } else {
        yield errorState.call(ex as V);
      }
    }
  }
}

/// расширение работает с [Cubit]
extension LaunchRequestCubitExtension on Cubit {
  /// функиця безопастно запускает запрос без обработки пользовательской
  ///  ошибки(будут выводиться ошибки в стандартных полях предусмотренные сервером)
  /// [request] запрос принимает фнкция useCase
  /// [loading] callback функция информирующая старт загрузки
  /// [resultState] callback успешном результате
  /// [errorState]  callback при ошибке
  @deprecated
  void launch<T>(Future<T> request, LoadingState loading,
      ResultState<T> resultState, ResultState<String> errorState) async {
    emit(loading.call(true));
    try {
      final result = await request;
      emit(loading.call(false));
      emit(resultState.call(result));
    } catch (ex) {
      emit(loading.call(false));
      if (ex is HttpRequestException<String>) {
        emit(errorState.call(ex.error.toString()));
      } else {
        emit(errorState.call(ex.toString()));
      }
    }
  }

  /// функиця безопастно запускает запрос c обработкой пользовательской
  ///  ошибки(будут выводиться ошибки в стандартных полях предусмотренные сервером)
  /// [request] запрос принимает фнкция useCase
  /// [loading] callback функция информирующая старт загрузки
  /// [resultState] callback успешном результате
  /// [errorState]  callback при ошибке
  @deprecated
  void launchWithError<T, V>(Future<T> request, LoadingState loading,
      ResultState<T> resultState, ResultState<V> errorState) async {
    emit(loading.call(true));
    try {
      final result = await request;
      emit(loading.call(false));
      emit(resultState.call(result));
    } catch (ex) {
      emit(loading.call(false));
      if (ex is V) {
        emit(errorState.call(ex));
      } else {
        emit(errorState.call(ex));
      }
    }
  }
}
