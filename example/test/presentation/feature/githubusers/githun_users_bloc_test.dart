import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:flutter_core_example/data/news/exeption/exeption.dart';
import 'package:flutter_core_example/domain/news/entity/news.dart';
import 'package:flutter_core_example/domain/news/use_cases/get_news_use_case.dart';
import 'package:flutter_core_example/presentation/home/ui/bloc.dart';
import 'package:flutter_core_example/presentation/home/ui/bloc_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

/// моковый [HomeCubit] кубит для выполнение тестов
class MockGitHubUserBloc extends MockCubit<CoreState> implements HomeCubit {}

/// моковый [GetNewsUserCase] usecase для выполнение тестов
class MockGetNewsUseCase extends Mock implements GetNewsUserCase {}

/// моковый [MockGetNewsCustomErrorUseCase] usecase для выполнение тестов
class MockGetNewsCustomErrorUseCase extends Mock
    implements GetNewsUserCustomErrorCase {}

main() {
  MockGetNewsUseCase useCase;
  MockGetNewsCustomErrorUseCase customErrorUseCase;
  HomeCubit cubit;

  setUp(() {
    //getLocatorModuleTest();
    useCase = MockGetNewsUseCase();
    customErrorUseCase = MockGetNewsCustomErrorUseCase();
    cubit = HomeCubit(
      useCase,
      customErrorUseCase,
    );
  });

  group("тестирование cubit", () {
    blocTest(
      'количество ожидаемых стейтов',
      build: () {
        when(useCase.execute())
            .thenAnswer((realInvocation) => Future.value(GitHubUserResult(
                1,
                [
                  GitHubUser(),
                  GitHubUser(),
                  GitHubUser(),
                ],
                "Hello")));

        return cubit;
      },
      act: (bloc) => bloc.call(),
      expect: ()=> [
        isA<LoadingNewsState>()
      ]
    );

    blocTest(
      'количество соответвие резельтат пришедшего из useCase без ошибки',
      build: () {
        when(useCase.execute())
            .thenAnswer((realInvocation) => Future.value(GitHubUserResult(
                1,
                [
                  GitHubUser(name: "GitHubUser 1"),
                  GitHubUser(name: "GitHubUser 2"),
                  GitHubUser(name: "GitHubUser 3")
                ],
                "Hello")));

        return cubit;
      },
      act: (bloc) => bloc.call(),
      expect: () => [
        LoadingNewsState(news: []),
        // LoadingNewsState(news: [], isLoading: false),
        // LoadingNewsState(news: [
        //   GitHubUser(name: "GitHubUser 1"),
        //   GitHubUser(name: "GitHubUser 2"),
        //   GitHubUser(name: "GitHubUser 3")
        // ])
      ],
    );

    blocTest(
      'получение состояния ошибки Exception',
      build: () {
        when(useCase.execute()).thenAnswer(
            (realInvocation) => Future.error(Exception("Exception : error")));

        return HomeCubit(useCase, customErrorUseCase);
      },
      act: (bloc) => bloc.call(),
      expect: () => [
        isA<CoreErrorExeptionState>(),
      ],
    );

    blocTest(
      'получение состояния ошибки HttpRequestException',
      build: () {
        when(customErrorUseCase.execute()).thenAnswer(
            (realInvocation) => Future.error(GitHubUserErrorExeption()));

        return HomeCubit(useCase, customErrorUseCase);
      },
      act: (bloc) => bloc.callWithCustomError(),
      expect: () => [
        isA<CoreErrorByCodeState>(),
      ],
    );
  });
}
