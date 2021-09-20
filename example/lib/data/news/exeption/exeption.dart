import 'package:flutter_core/core/data/abstract/exeption/exeption.dart';

class GitHubUserErrorExeption extends HttpRequestException<String> {
  String documentationUrl;
  int code;

  GitHubUserErrorExeption({
    this.documentationUrl,
    this.code,
  }) : super(
          documentationUrl,
          code,
          HttpTypeError.http,
        );
  factory GitHubUserErrorExeption.fromJson(
          Map<String, dynamic> map, int code) =>
      GitHubUserErrorExeption(
        documentationUrl: map['documentation_url'],
        code: code,
      );
}
