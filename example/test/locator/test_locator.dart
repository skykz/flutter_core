import 'package:flutter_core_example/config/network_confing.dart';
import 'package:flutter_core_example/data/abstract/network/api_service.dart';
import 'package:flutter_core_example/data/news/repository/new_repository.dart';
import 'package:flutter_core_example/domain/news/use_cases/get_news_use_case.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;

void _getCommonModule() {
  sl.registerSingleton(createHttpClient());
}

void _getApiServiceModule() {
  sl.registerSingleton(ApiService(sl.get()));
}

void _getRepositoryModule() {
  sl.registerFactory(() => NewRepository(sl.get()));
}

void _getUseCaseModule() {
  sl.registerFactory(() => GetNewsUserCase(sl.get()));
  sl.registerFactory(() => GetNewsUserCustomErrorCase(sl.get()));
}

void getLocatorModuleTest() {
  _getCommonModule();
  _getApiServiceModule();
  _getRepositoryModule();
  _getUseCaseModule();
}
