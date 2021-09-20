import 'package:flutter_core_example/data/news/exeption/exeption.dart';
import 'package:flutter_core_example/domain/news/use_cases/get_news_use_case.dart';

import 'package:flutter_core_example/presentation/home/ui/bloc_state.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_cubit.dart';

class HomeCubit extends CoreCubit {
  GetNewsUserCase _getNewsUseCase;
  GetNewsUserCustomErrorCase _getNewsUserCustomErrorCase;

  HomeCubit(
    GetNewsUserCase getNewsUseCase,
    GetNewsUserCustomErrorCase getNewsUserCustomErrorCase,
  ) : super(
          LoadingNewsState(news: []),
          useCaseLaunchers: [getNewsUseCase, getNewsUserCustomErrorCase],
        ) {
    _getNewsUseCase = getNewsUseCase;
    _getNewsUserCustomErrorCase = getNewsUserCustomErrorCase;
  }

  void callWithCustomError() {
    final request = _getNewsUserCustomErrorCase.execute();
    launchWithError<GitHubUserResult, GitHubUserErrorExeption>(
        request: request,
        loading: (loading) {
          print(loading);
        },
        resultData: (data) {
          print(data);
        },
        errorData: (error) {
          print(error.documentationUrl);
        });
  }

  void call() {
    final request = _getNewsUseCase.execute();
    launch(
      request: request,
      loading: (loading) {
        print(loading);
      },
      resultData: (data) {
        emit(LoadingNewsState(news: []));
      },
    );
  }
}
