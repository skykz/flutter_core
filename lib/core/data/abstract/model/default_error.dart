/// модель получения ошибок по умолчанию
class Error {
  String message;

  Error(this.message);

  factory Error.fromJson(Map<String, dynamic> map) =>
      Error(map['message'] ?? map['error'] ?? map['detail']);
}
