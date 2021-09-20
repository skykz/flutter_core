import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/core/data/abstract/exeption/exeption.dart';
import 'package:flutter_core/core/utils/http_call_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DioAdapterMock extends Mock implements HttpClientAdapter {}

class _Token extends HttpRequestException<String> {
  String token;
  int code;

  _Token(this.token, this.code) : super(token, code, HttpTypeError.http);

  factory _Token.fromJson(Map<String, dynamic> json, int code) {
    return _Token(json['token'], code);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DioAdapterMock dioAdapterMock;
  final Dio dio = Dio();

  setUp(() {
    dioAdapterMock = DioAdapterMock();
    dio.httpClientAdapter = dioAdapterMock;
  });

  group("safe api call test", () {
    test("safeApiCall code 200", () async {
      final responsePayload = json.encode({'token': 'token'});
      final httpResponse = ResponseBody.fromString(responsePayload, 200);

      when(dioAdapterMock?.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final response = dio.get("/");
      final result = await safeApiCall<_Token>(response, (js) {
        return _Token.fromJson(json.decode(js), -1);
      }, isTest: true);
      expect(result.token, 'token');
    });

    test("safeApiCall code 400", () async {
      final responsePayload = json.encode({'token': 'token'});
      final httpResponse = ResponseBody.fromString(responsePayload, 400);

      when(dioAdapterMock?.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final response = dio.get("/");

      expect(
          () async => await safeApiCallWithError<_Token, String>(
                  response, (json) => _Token.fromJson(json, 1),
                  (errorJson, defaultError, code) {
                return _Token.fromJson(json.decode(errorJson), 1);
              }, isTest: true),
          throwsA(isInstanceOf<_Token>()));
    });

    test("safeApiCall code 400 with message", () async {
      final responsePayload = json.encode({'token': 'token'});
      final httpResponse = ResponseBody.fromString(responsePayload, 400);

      when(dioAdapterMock?.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final response = dio.get("/");

      expect(
        () async => await safeApiCallWithError<_Token, String>(
            response, (json) => _Token.fromJson(json, 1),
            (errorJson, error, code) {
          return _Token.fromJson(json.decode(errorJson), -1);
        }, isTest: true),
        throwsA(
          predicate(
            (e) {
              print(e);
              return e is _Token && e.token == "token";
            },
          ),
        ),
      );
    });

    test("safeApiCall code 500 with message", () async {
      final responsePayload = json.encode({'token': 'token 500'});
      final httpResponse = ResponseBody.fromString(responsePayload, 500);

      when(dioAdapterMock?.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final response = dio.get("/");

      expect(
        () async => await safeApiCallWithError<_Token, String>(
            response, (json) => _Token.fromJson(json, -1),
            (errorJson, error, code) {
          return _Token.fromJson(json.decode(errorJson), -1);
        }, isTest: true),
        throwsA(
          predicate(
            (e) {
              print(e);
              return e is _Token && e.token == "token 500";
            },
          ),
        ),
      );
    });
  });
}
