import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:succucare_app/core/constants/environment.dart';
import 'package:succucare_app/features/garden/services/firebase_ai_plant_identification_service.dart';
import 'package:succucare_app/features/garden/services/plant_identification_service.dart';
import 'package:succucare_app/features/garden/services/unavailable_plant_identification_service.dart';

part 'plant_identification_service_provider.g.dart';

@riverpod
PlantIdentificationService plantIdentificationService(Ref ref) {
  final provider = Environment.aiProvider;

  if (provider == 'firebase_ai') {
    return buildFirebaseAiPlantIdentificationService();
  }

  return const UnavailablePlantIdentificationService();
}
