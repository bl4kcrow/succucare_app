// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Auth)
final authProvider = AuthProvider._();

final class AuthProvider extends $NotifierProvider<Auth, Authentication> {
  AuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authHash();

  @$internal
  @override
  Auth create() => Auth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Authentication value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Authentication>(value),
    );
  }
}

String _$authHash() => r'10fa49d9dc9b87df9ff1a8e2f8aaac711de64d5a';

abstract class _$Auth extends $Notifier<Authentication> {
  Authentication build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Authentication, Authentication>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Authentication, Authentication>,
              Authentication,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
