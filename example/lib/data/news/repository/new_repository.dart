import 'dart:async';

import 'package:flutter_core/core/utils/http_call_utils.dart';
import 'package:flutter_core_example/data/abstract/network/api_service.dart';
import 'package:flutter_core_example/data/news/exeption/exeption.dart';
import 'package:flutter_core_example/data/news/model/news.dart';
import 'package:flutter_core_example/domain/news/entity/news.dart';

class NewRepository {
  ApiService _apiService;

  NewRepository(this._apiService);

  Future<List<GitHubUser>> getGitHubUsersCustomError() =>
      safeApiCallWithError(_apiService.getGitHubUsersCustomError(), (result) {
        final list = result as List;
        return list
            .map((jsonElement) =>
                GitHubUser.fromDTO(GitHubUserDTO.fromJson(jsonElement)))
            .toList();
      }, (error, defaultError, code) {
        return GitHubUserErrorExeption.fromJson(error, code);
      });

  Future<List<GitHubUser>> loadGitHubUsers() =>
      safeApiCall(_apiService.getGitHubUsers(), (result) {
        final list = result as List;
        return list
            .map((jsonElement) =>
                GitHubUser.fromDTO(GitHubUserDTO.fromJson(jsonElement)))
            .toList();
      });
}
