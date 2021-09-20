import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// /// общий класс обработки састояния
abstract class CoreState extends Equatable {
  @override
  List<Object> get props => [];
}

// общий класс обработки састояния c уникальный index-ом для постоянного эмита в bloc/cubit
abstract class CoreIndexedState extends CoreState {
  final index = DateTime.now().microsecondsSinceEpoch;

  @override
  List<Object> get props => [index];
}

class CoreLoadingState extends CoreState {}

class CoreNotInternerConnectionState extends CoreState {
  final index = DateTime.now().millisecondsSinceEpoch;
  final String error;

  CoreNotInternerConnectionState(this.error);

  @override
  List<Object> get props => [index, error];
}

class CoreErrorByCodeState extends CoreIndexedState {
  final String error;
  final int code;

  CoreErrorByCodeState(this.error, this.code);

  @override
  List<Object> get props => [error, code, index];
}

class CoreErrorMessage extends CoreIndexedState {
  final String error;
  CoreErrorMessage(this.error);
  @override
  List<Object> get props => [error, index];
}

/// класс обработки ошибок
@deprecated
class CoreErrorState extends CoreState {
  final String error;

  CoreErrorState({this.error});

  @override
  List<Object> get props => [];
}

@deprecated
class CoreErrorWithLoadingState extends CoreState {
  final String error;
  final bool isLoading;

  CoreErrorWithLoadingState({@required this.error, @required this.isLoading});

  CoreErrorWithLoadingState copyWith({String error, bool isLoading}) =>
      CoreErrorWithLoadingState(error: error, isLoading: isLoading);

  @override
  List<Object> get props => [];
}

/// состояние при внутреней ошибке приложения
class CoreErrorExeptionState extends CoreIndexedState {
  final String error;

  CoreErrorExeptionState({this.error});

  @override
  List<Object> get props => [index, error];
}
