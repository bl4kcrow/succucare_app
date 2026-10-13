// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alerts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlertsNotifier)
final alertsProvider = AlertsNotifierProvider._();

final class AlertsNotifierProvider
    extends $AsyncNotifierProvider<AlertsNotifier, NotificationsState> {
  AlertsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alertsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alertsNotifierHash();

  @$internal
  @override
  AlertsNotifier create() => AlertsNotifier();
}

String _$alertsNotifierHash() => r'5f8aefa859fd9d8c54154a974dd6efadd5201e5a';

abstract class _$AlertsNotifier extends $AsyncNotifier<NotificationsState> {
  FutureOr<NotificationsState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<NotificationsState>, NotificationsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NotificationsState>, NotificationsState>,
              AsyncValue<NotificationsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
