import 'package:freezed_annotation/freezed_annotation.dart';

import 'models.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(<Plant>[]) List<Plant> plants,
    @Default(PlantCategoryFilter.all) PlantCategoryFilter selectedCategory,
    @Default('') String query,
  }) = _HomeState;
}