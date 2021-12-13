import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void coreModule() {
  _serviceModule();
  _repositoryModule();
  _useCaseModule();
}

/// для сервисов
void _serviceModule() {}

/// для репозиторий
void _repositoryModule() {}

/// для useCase
void _useCaseModule() {}
