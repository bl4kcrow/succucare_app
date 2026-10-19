sealed class AppError {}

class NoInternetError extends AppError {}

class ServerError extends AppError {
  final int statusCode;
  final String message;

  ServerError({required this.statusCode, required this.message});
}

class ParseError extends AppError {
  final String message;
  ParseError(this.message);
}

class UnknownError extends AppError {
  final String message;
  UnknownError(this.message);
}
