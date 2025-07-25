import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

@freezed
abstract class AppUser with _$AppUser {
  factory AppUser({
    required String id,
    required String name,
    required String email,
  }) = _AppUser;
}
