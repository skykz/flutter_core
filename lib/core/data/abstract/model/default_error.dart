/// модель получения ошибок по умолчанию
class DefaultError {
  String message;

  DefaultError(this.message);

  factory DefaultError.fromJson(Map<String, dynamic> map) =>
      DefaultError(map['message'] ?? map['error'] ?? map['detail']);
}
