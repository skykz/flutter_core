import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:flutter_core/core/utils/mixins/action_state_mixin.dart';

/// пользовательский блок в который следуем заносить весь базовый функционал связанные с UI
/// Содержит в себе только bulder
class CoreUpgradeBlocBuilder<C extends Cubit<S>, S extends CoreState>
    extends StatefulWidget {
  final Function(String error, int code) error404Listener;
  final Function(String error, int code) error500Listener;
  final Function(String error) errorListener;
  final Function() noInternerConnectionListener;
  final Function() applicationExeptionListener;
  final Function redirectLoginListener;

  /// Функция [builder], которая будет вызываться при каждой сборке виджета.
  /// [Builder] принимает `BuildContext` и текущее` состояние` и
  /// должен возвращать виджет.
  /// Это аналог функции [builder] в [StreamBuilder].
  final BlocWidgetBuilder<S> builder;

  /// Функция [builder], которая будет вызываться при первом перестроении в случае ошибки,
  /// для того чтобы пользователь мог, позвторно сделать запрос
  /// [Builder] принимает `BuildContext` и текущее` состояние` и
  /// должен возвращать виджет.
  /// Это аналог функции [builder] в [StreamBuilder].
  final BlocWidgetBuilder<S> errorBuilder;

  /// Функция [builder], которая будет вызываться в случае отсутвия интернета при первичном запуске,
  /// для того чтобы пользователь мог, позвторно сделать запрос,
  /// послудущие разы, данные кульбэк вызываться не будет
  /// [Builder] принимает `BuildContext` и текущее` состояние` и
  /// должен возвращать виджет.
  /// Это аналог функции [builder] в [StreamBuilder].
  final BlocWidgetBuilder<S> notInternetConnectionBuilder;

  /// Функция [builder], которая будет вызываться в случае сбоя в приложении при первичном запуске,
  /// для того чтобы пользователь мог, позвторно сделать запрос,
  /// послудущие разы, данные кульбэк вызываться не будет
  /// [Builder] принимает `BuildContext` и текущее` состояние` и
  /// должен возвращать виджет.
  /// Это аналог функции [builder] в [StreamBuilder].
  final BlocWidgetBuilder<S> applicationExeptionBuilder;

  /// Принимает `BuildContext` вместе с [cubit]` state`
  /// и отвечает за выполнение в ответ на изменения состояния.
  final BlocWidgetListener<S> listener;

  /// [Cubit], с которым будет взаимодействовать [BlocConsumer].
  /// Если не указано, [BlocConsumer] автоматически выполнит поиск, используя
  /// `BlocProvider` и текущий` BuildContext`.
  final C cubit;

  /// Принимает предыдущее `состояние` и текущее` состояние` и отвечает за
  /// возвращаем [bool], который определяет, запускать или нет
  /// [строитель] с текущим `состоянием`.
  final BlocBuilderCondition<S> buildWhen;

  /// Принимает предыдущее `состояние` и текущее` состояние` и отвечает за
  /// возвращаем [bool], который определяет, вызывать ли [listener] из
  /// [BlocConsumer] с текущим `состоянием`.
  final BlocListenerCondition<S> listenWhen;

  /// Если true то пользователю не показываем toast про отсутствие интернета
  /// По умолчанию [true]
  final bool disableNetworkErrorMessages;

  CoreUpgradeBlocBuilder({
    @required this.builder,
    this.errorBuilder,
    this.notInternetConnectionBuilder,
    this.applicationExeptionBuilder,
    this.cubit,
    this.buildWhen,
    this.listenWhen,
    this.listener,
    this.error404Listener,
    this.error500Listener,
    this.errorListener,
    this.redirectLoginListener,
    this.noInternerConnectionListener,
    this.applicationExeptionListener,
    this.disableNetworkErrorMessages = true
  });

  @override
  _CoreUpgradeBlocBuilderState<C, S> createState() =>
      _CoreUpgradeBlocBuilderState<C, S>();
}

class _CoreUpgradeBlocBuilderState<C extends Cubit<S>, S extends CoreState>
    extends State<CoreUpgradeBlocBuilder<C, S>> with ActionStateMixin {
  Widget _widget, _builderWidget;

  @override
  Widget build(BuildContext context) => BlocConsumer<C, S>(
    builder: (context, state) {
      final currentWidget = _widget ?? widget.builder.call(context, state);
      return currentWidget;
    },
    bloc: widget.cubit,
    buildWhen: (prevState, currentState) {
      return makeBuildWhenListener(prevState, currentState,
              (context, state) {
            _widget = null;
            return widget.buildWhen?.call(context, state);
          }, () {
            _widget =
                widget.notInternetConnectionBuilder(context, currentState);
          }, () {
            _widget = widget.errorBuilder(context, currentState);
          }, () {
            _widget = widget.applicationExeptionBuilder(context, currentState);
          });
    },
    listenWhen: widget.listenWhen,
    listener: (context, state) {
      handleErrorListener(
        context,
        state,
        widget.errorListener,
        widget.redirectLoginListener,
        widget.noInternerConnectionListener,
        widget.applicationExeptionListener,
        disableNetworkErrorMessages: widget.disableNetworkErrorMessages
      );
      widget.listener?.call(context, state);
    },
  );
}

