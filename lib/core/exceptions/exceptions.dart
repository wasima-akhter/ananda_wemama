class AppException implements Exception {
  final String message;
  final String prefix;

  AppException(this.message, [this.prefix = ""]);

  @override
  String toString() => "$prefix$message";
}

// 🔴 400 Errors
class BadRequestException extends AppException {
  BadRequestException(String message) : super(message, "Bad Request: ");
}

// 🔐 401 / 403 Errors
class UnauthorisedException extends AppException {
  UnauthorisedException(String message) : super(message, "Unauthorised: ");
}

// 🌐 Other server / network errors
class FetchDataException extends AppException {
  FetchDataException(String message)
    : super(message, "Error During Communication: ");
}
