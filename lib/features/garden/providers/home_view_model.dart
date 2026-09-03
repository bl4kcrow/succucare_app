import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/data.dart';
import '../models/models.dart';

part 'home_view_model.g.dart';

List<Plant> filterPlants(
  List<Plant> plants, {
  required PlantCategoryFilter category,
  required String query,
}) {
  final normalizedQuery = query.trim().toLowerCase();

  return plants.where((plant) {
    final matchesCategory =
        category.category == null ||
        plant.categories.contains(category.category);
    final matchesQuery =
        normalizedQuery.isEmpty ||
        plant.name.toLowerCase().contains(normalizedQuery) ||
        plant.scientificName.toLowerCase().contains(normalizedQuery);

    return matchesCategory && matchesQuery;
  }).toList();
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() {
    return const HomeState(plants: mockPlants);
  }

  void selectCategory(PlantCategoryFilter category) {
    state = state.copyWith(selectedCategory: category);
  }

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }
}

@riverpod
List<Plant> filteredPlants(Ref ref) {
  final homeState = ref.watch(homeViewModelProvider);

  return filterPlants(
    homeState.plants,
    category: homeState.selectedCategory,
    query: homeState.query,
  );
}