import 'dart:async';
import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:flutter_core_example/data/news/repository/new_repository.dart';
import 'package:flutter_core_example/domain/news/entity/news.dart';
import 'package:flutter_core/core/utils/mixins/request_worker_mixin.dart';

class GetNewsUserCase extends CoreFutureNoneParamUseCase<GitHubUserResult>
    with CoreRequestWorketMixin {
  NewRepository _repository;

  GetNewsUserCase(this._repository);

  @override
  Future<GitHubUserResult> execute() async {
    final usr = await _repository.loadGitHubUsers();
    return GitHubUserResult(0, usr, "sxacas");
  }
}

class GetNewsUserCustomErrorCase
    extends CoreFutureNoneParamUseCase<GitHubUserResult>
    with CoreRequestWorketMixin {
  NewRepository _repository;

  GetNewsUserCustomErrorCase(this._repository);

  @override
  Future<GitHubUserResult> execute() async {
    final usr = await _repository.getGitHubUsersCustomError();
    return GitHubUserResult(0, usr, "sxacas");
  }
}

class GitHubUserResult {
  List<GitHubUser> news;
  String userNameById;
  int size;
  GitHubUserResult(this.size, this.news, this.userNameById);
}
