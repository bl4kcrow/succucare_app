// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_by_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(plantById)
final plantByIdProvider = PlantByIdFamily._();

final class PlantByIdProvider
    extends $FunctionalProvider<AsyncValue<Plant>, Plant, FutureOr<Plant>>
    with $FutureModifier<Plant>, $FutureProvider<Plant> {
  PlantByIdProvider._({
    required PlantByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'plantByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$plantByIdHash();

  @override
  String toString() {
    return r'plantByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Plant> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Plant> create(Ref ref) {
    final argument = this.argument as String;
    return plantById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlantByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plantByIdHash() => r'0a6086798e4214350325fac97838ad4c8a2cab6a';

final class PlantByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Plant>, String> {
  PlantByIdFamily._()
    : super(
        retry: null,
        name: r'plantByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlantByIdProvider call(String plantId) =>
      PlantByIdProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantByIdProvider';
}
