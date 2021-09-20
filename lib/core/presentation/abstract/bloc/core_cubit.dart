import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/core/utils/mixins/request_worker_mixin.dart';

import 'core_state.dart';

abstract class CoreCubit extends Cubit<CoreState> with CoreRequestWorketMixin {
  List<CoreRequestWorketMixin> _useCaseLaunchers;
  CoreCubit(
    CoreState state, {
    List<CoreRequestWorketMixin> useCaseLaunchers,
  }) : super(state) {
    _useCaseLaunchers = useCaseLaunchers;
    _useCaseLaunchers?.forEach((element) {
      element?.showErrorByCodeCallback = (String errorMessage, int code) {
        emit(CoreErrorByCodeState(errorMessage, code));
      };

      element?.showErrorCallback = (error) {
        emit(CoreErrorMessage(error));
      };

      element?.showErrorInternetConnection = (error) {
        emit(CoreNotInternerConnectionState(error));
      };
      element?.showErrorExeptionCallback = (error) {
        emit(CoreNotInternerConnectionState(error));
      };
    });

    showErrorCallback = (error) {
      emit(CoreErrorMessage(error));
    };

    showErrorInternetConnection = (error) {
      emit(CoreNotInternerConnectionState(error));
    };

    showErrorByCodeCallback = (errorMessage, int code) {
      emit(CoreErrorByCodeState(errorMessage, code));
    };

    showErrorExeptionCallback = (error) {
      emit(CoreErrorExeptionState());
    };
  }

  @override
  Future<void> close() {
    _useCaseLaunchers?.forEach((element) {
      element.clear();
    });
    clear();
    return super.close();
  }
}
