// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeViewModel)
final homeViewModelProvider = HomeViewModelProvider._();

final class HomeViewModelProvider
    extends $NotifierProvider<HomeViewModel, HomeState> {
  HomeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeViewModelHash();

  @$internal
  @override
  HomeViewModel create() => HomeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeState>(value),
    );
  }
}

String _$homeViewModelHash() => r'515da939ce7771cc2af8497aca72eea4419ab300';

abstract class _$HomeViewModel extends $Notifier<HomeState> {
  HomeState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<HomeState, HomeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeState, HomeState>,
              HomeState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredPlants)
final filteredPlantsProvider = FilteredPlantsProvider._();

final class FilteredPlantsProvider
    extends $FunctionalProvider<List<Plant>, List<Plant>, List<Plant>>
    with $Provider<List<Plant>> {
  FilteredPlantsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredPlantsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredPlantsHash();

  @$internal
  @override
  $ProviderElement<List<Plant>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Plant> create(Ref ref) {
    return filteredPlants(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Plant> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Plant>>(value),
    );
  }
}

String _$filteredPlantsHash() => r'56f4a94b884d420c4f01aeba96e3212f2bf2fb10';
