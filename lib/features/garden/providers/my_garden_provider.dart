import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:succucare_app/features/garden/providers/providers.dart';
import 'package:succucare_app/features/garden/models/models.dart';

part 'my_garden_provider.g.dart';

@riverpod
class MyGardenNotifier extends _$MyGardenNotifier {
  bool _isLoadingMore = false;
  bool _hasMore = true;
  dynamic _nextCursor;

  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<List<Plant>> build() async {
    final page = await ref
        .read(gardenRepositoryImplProvider)
        .loadInitialPlants();
    _nextCursor = page.nextCursor;
    return page.plants;
  }

  Future<void> loadNextPlants() async {
    if (_isLoadingMore || !_hasMore || !state.hasValue) return;

    _isLoadingMore = true;

    try {
      final page = await ref
          .read(gardenRepositoryImplProvider)
          .loadNextPlants(_nextCursor);

      if (page.plants.isNotEmpty) {
        _nextCursor = page.nextCursor;
        state = AsyncData([...state.requireValue, ...page.plants]);
      }

      if (_nextCursor == null) {
        _hasMore = false;
      }
    } finally {
      _isLoadingMore = false;
    }
  }
}
