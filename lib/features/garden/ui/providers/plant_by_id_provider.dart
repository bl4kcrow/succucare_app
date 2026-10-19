import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:succucare_app/features/garden/data/models/models.dart';
import 'package:succucare_app/features/garden/ui/providers/providers.dart';

part 'plant_by_id_provider.g.dart';

@riverpod
Future<Plant> plantById(Ref ref, String plantId) {
  return ref.read(gardenRepositoryImplProvider).loadPlantById(plantId);
}