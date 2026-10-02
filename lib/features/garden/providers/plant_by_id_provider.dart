import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';

part 'plant_by_id_provider.g.dart';

@riverpod
Future<Plant> plantById(Ref ref, String plantId) {
  return ref.read(gardenRepositoryImplProvider).loadPlantById(plantId);
}