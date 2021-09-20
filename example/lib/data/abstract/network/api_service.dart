import 'dart:async';
import 'package:dio/dio.dart';

class ApiService {
  Dio _httpClient;

  ApiService(this._httpClient);

  Future<Response> getGitHubUsersCustomError() =>
      _httpClient.get("/useracscascs");

  Future<Response> getGitHubUsers() => _httpClient.get("/users");
}
