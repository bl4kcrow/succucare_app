// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_plant_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditPlantNotifier)
final editPlantProvider = EditPlantNotifierFamily._();

final class EditPlantNotifierProvider
    extends $NotifierProvider<EditPlantNotifier, EditPlantState> {
  EditPlantNotifierProvider._({
    required EditPlantNotifierFamily super.from,
    required Plant super.argument,
  }) : super(
         retry: null,
         name: r'editPlantProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$editPlantNotifierHash();

  @override
  String toString() {
    return r'editPlantProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EditPlantNotifier create() => EditPlantNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EditPlantState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EditPlantState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EditPlantNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$editPlantNotifierHash() => r'0a64ac6d262010ae04e5df94df1a7461849ac6e1';

final class EditPlantNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          EditPlantNotifier,
          EditPlantState,
          EditPlantState,
          EditPlantState,
          Plant
        > {
  EditPlantNotifierFamily._()
    : super(
        retry: null,
        name: r'editPlantProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EditPlantNotifierProvider call(Plant plant) =>
      EditPlantNotifierProvider._(argument: plant, from: this);

  @override
  String toString() => r'editPlantProvider';
}

abstract class _$EditPlantNotifier extends $Notifier<EditPlantState> {
  late final _$args = ref.$arg as Plant;
  Plant get plant => _$args;

  EditPlantState build(Plant plant);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EditPlantState, EditPlantState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EditPlantState, EditPlantState>,
              EditPlantState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
