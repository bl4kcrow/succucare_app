import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:succucare_app/features/garden/providers/providers.dart';
import 'package:succucare_app/features/garden/models/models.dart';

part 'my_garden_provider.g.dart';

@riverpod
class MyGardenNotifier extends _$MyGardenNotifier {
  @override
  Future<List<Plant>> build() async {
    final initialPlants = await ref
        .read(gardenRepositoryImplProvider)
        .loadInitialplants();
    return initialPlants;
  }

  Future<void> loadNextPlants() async {
    final currentPlants = state.requireValue;

    final nextPlants = await ref
        .read(gardenRepositoryImplProvider)
        .loadInitialplants();

    state = AsyncData([...currentPlants, ...nextPlants]);
  }
}
