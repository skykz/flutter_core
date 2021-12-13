import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';

/// отслеживаем состояние которые нужно выполнить в базовых случаях
mixin ActionStateMixin {
  bool makeBuildWhenListener<S>(
    S prevState,
    S currentState,
    BlocBuilderCondition<S> buildWhen,
    Function() noInternetConnectionListener,
    Function() primaryErrorListener,
    Function() applicationExtensionListener,
  ) {
    /// в случае если нет интернет соеденения и загрузка была первичной
    if (currentState is CoreNotInternerConnectionState &&
        prevState is CoreLoadingState) {
      noInternetConnectionListener.call();

      return true;
    }

    if (currentState is CoreErrorExeptionState &&
        prevState is CoreLoadingState) {
      applicationExtensionListener?.call();
      return true;
    }

    if (currentState is CoreErrorByCodeState ||
        currentState is CoreErrorMessage ||
        currentState is CoreNotInternerConnectionState ||
        currentState is CoreErrorExeptionState) {
      /// в случае если вылетила ошибка и загрузка была первичной
      if (prevState is CoreLoadingState) {
        primaryErrorListener.call();
        return true;
      }

      return false;
    }
    final value = (buildWhen?.call(prevState, currentState) ?? true);
    return value;
  }

  /// отслеживаем ошибки
  /// [bool disableNetworkErrorMessages] - если true, то ошибки не показваются дефолтным образом в SnackBar
  void handleErrorListener(
      context,
      state,
      Function(String error) errorListener,
      Function() redirectLoginListener,
      Function() notInternetConnectionListener,
      Function() applicationExeptionListener,
      {bool disableNetworkErrorMessages = true}) {
    if (state is CoreErrorByCodeState) {
      _handleErrorByCode(
        context,
        state,
        redirectLoginListener,
      );
      return;
    }
    if (state is CoreNotInternerConnectionState) {
      _makeShowError(
          context, state.error, errorListener, !disableNetworkErrorMessages);
      return;
    }

    if (state is CoreErrorMessage) {
      _makeShowError(context, state.error, notInternetConnectionListener);
      return;
    }
    if (state is CoreErrorExeptionState) {
      _makeShowError(
          context, state.error, errorListener, !disableNetworkErrorMessages);
      return;
    }
  }

  /// вывод ошибок, обработка происходит разово (показ snackbar или переход на другую страницу)
  /// [bool showErrorInSnackBar] - показывать ошибку в SnackBar или нет
  void _makeShowError(
    BuildContext context,
    String error,
    Function errorListener, [
    bool showErrorInSnackBar = true,
  ]) {
    if (errorListener == null) {
      if (showErrorInSnackBar) {
        final snackBar = SnackBar(content: Text(error));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      return;
    }

    if (errorListener is Function(String)) {
      errorListener.call(error);
    } else {
      errorListener.call();
    }
  }

  /// отслеживаем ошибку по коду
  void _handleErrorByCode(
    BuildContext context,
    CoreErrorByCodeState state,
    Function() redirectLogin,
  ) {
    switch (state.code) {
      case HttpStatus.unauthorized:
      case HttpStatus.forbidden:
        {
          redirectLogin?.call();
          return;
        }
    }
  }
}
