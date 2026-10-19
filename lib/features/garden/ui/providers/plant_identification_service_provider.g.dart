// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_identification_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(plantIdentificationService)
final plantIdentificationServiceProvider =
    PlantIdentificationServiceProvider._();

final class PlantIdentificationServiceProvider
    extends
        $FunctionalProvider<
          PlantIdentificationService,
          PlantIdentificationService,
          PlantIdentificationService
        >
    with $Provider<PlantIdentificationService> {
  PlantIdentificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantIdentificationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantIdentificationServiceHash();

  @$internal
  @override
  $ProviderElement<PlantIdentificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlantIdentificationService create(Ref ref) {
    return plantIdentificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlantIdentificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlantIdentificationService>(value),
    );
  }
}

String _$plantIdentificationServiceHash() =>
    r'e0d2e5b1e5ffc3bf1879023842649b2edd3f0ef1';
