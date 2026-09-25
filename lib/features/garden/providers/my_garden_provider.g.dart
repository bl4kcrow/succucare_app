// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_garden_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyGardenNotifier)
final myGardenProvider = MyGardenNotifierProvider._();

final class MyGardenNotifierProvider
    extends $AsyncNotifierProvider<MyGardenNotifier, List<Plant>> {
  MyGardenNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myGardenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myGardenNotifierHash();

  @$internal
  @override
  MyGardenNotifier create() => MyGardenNotifier();
}

String _$myGardenNotifierHash() => r'5812e1adedda71e48b96550e969567d911582e56';

abstract class _$MyGardenNotifier extends $AsyncNotifier<List<Plant>> {
  FutureOr<List<Plant>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Plant>>, List<Plant>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Plant>>, List<Plant>>,
              AsyncValue<List<Plant>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
