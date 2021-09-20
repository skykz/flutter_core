/// useCase который не принимает параметры
abstract class CoreNoneParamUseCase<Result> {
  Result execute();
}

/// useCase который принимает параметры
abstract class CoreUseCase<Param, Result> {
  Result execute(Param param);
}

/// useCase который принимает параметры, но возвращает Future
abstract class CoreFutureUseCase<Param, Result>
    extends CoreUseCase<Param, Future<Result>> {
  Future<Result> execute(Param param);
}

/// useCase который не принимает параметры, но возвращает Future
abstract class CoreFutureNoneParamUseCase<Result>
    extends CoreNoneParamUseCase<Future<Result>> {
  Future<Result> execute();
}
