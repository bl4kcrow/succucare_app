// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photos_repository_impl_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(photosRepositoryImpl)
final photosRepositoryImplProvider = PhotosRepositoryImplProvider._();

final class PhotosRepositoryImplProvider
    extends
        $FunctionalProvider<
          PhotosRepository,
          PhotosRepository,
          PhotosRepository
        >
    with $Provider<PhotosRepository> {
  PhotosRepositoryImplProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photosRepositoryImplProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photosRepositoryImplHash();

  @$internal
  @override
  $ProviderElement<PhotosRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotosRepository create(Ref ref) {
    return photosRepositoryImpl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotosRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotosRepository>(value),
    );
  }
}

String _$photosRepositoryImplHash() =>
    r'8e630efcae5be48cae7466a6f52fae0fd854fbf7';
