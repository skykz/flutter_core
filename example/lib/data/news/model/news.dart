class GitHubUserDTO {
  int id;
  String name;

  GitHubUserDTO({this.id, this.name});

  factory GitHubUserDTO.fromJson(Map<String, dynamic> map) =>
      GitHubUserDTO(id: map['id'], name: map['login']);
}
