import 'package:equatable/equatable.dart';
import 'package:flutter_core_example/data/news/model/news.dart';

class GitHubUser extends Equatable {
  final int id;
  final String name;

  GitHubUser({this.id, this.name});

  factory GitHubUser.fromDTO(GitHubUserDTO user) =>
      GitHubUser(id: user.id, name: user.name);

  @override
  List<Object> get props => [id, name];
}
