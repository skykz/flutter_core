import 'package:flutter/material.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:flutter_core_example/domain/news/entity/news.dart';

class LoadingNewsState extends CoreLoadingState {
  final String error;
  final List<GitHubUser> news;
  final bool isLoading;

  LoadingNewsState({@required this.news, this.isLoading, this.error});

  LoadingNewsState copyWith(
          {String error, List<GitHubUser> news, bool isLoading}) =>
      LoadingNewsState(
          error: error ?? this.error,
          isLoading: isLoading ?? this.isLoading,
          news: news ?? this.news ?? []);

  @override
  List<Object> get props => [error, news, isLoading];
}
