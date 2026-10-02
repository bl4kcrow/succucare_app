// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_plant_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddPlantNotifier)
final addPlantProvider = AddPlantNotifierProvider._();

final class AddPlantNotifierProvider
    extends $NotifierProvider<AddPlantNotifier, NewPlantState> {
  AddPlantNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addPlantProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addPlantNotifierHash();

  @$internal
  @override
  AddPlantNotifier create() => AddPlantNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewPlantState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewPlantState>(value),
    );
  }
}

String _$addPlantNotifierHash() => r'4c6a08bbb9f22f0c380bea1351d883598be2f50b';

abstract class _$AddPlantNotifier extends $Notifier<NewPlantState> {
  NewPlantState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NewPlantState, NewPlantState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NewPlantState, NewPlantState>,
              NewPlantState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
