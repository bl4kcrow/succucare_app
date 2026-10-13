import 'package:succucare_app/core/utils/utils.dart';

sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppError error;
  Failure(this.error);
}