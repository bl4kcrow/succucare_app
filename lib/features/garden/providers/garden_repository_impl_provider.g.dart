// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_repository_impl_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gardenRepositoryImpl)
final gardenRepositoryImplProvider = GardenRepositoryImplProvider._();

final class GardenRepositoryImplProvider
    extends
        $FunctionalProvider<
          GardenRepository,
          GardenRepository,
          GardenRepository
        >
    with $Provider<GardenRepository> {
  GardenRepositoryImplProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gardenRepositoryImplProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gardenRepositoryImplHash();

  @$internal
  @override
  $ProviderElement<GardenRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GardenRepository create(Ref ref) {
    return gardenRepositoryImpl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GardenRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GardenRepository>(value),
    );
  }
}

String _$gardenRepositoryImplHash() =>
    r'4dac2cd84a951b707fa1adbe4051eb4264f475a9';
