import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_user.dart';

part 'authentication.freezed.dart';

@freezed
abstract class Authentication with _$Authentication {
  factory Authentication({
    required AppUser user,
    required String errorMessage,
  }) = _Authentication;
}
