import 'package:flutter/foundation.dart' show debugPrint;

import 'package:succucare_app/core/errors/errors.dart';
import 'package:succucare_app/features/garden/services/plant_identification_service.dart';

import '../models/models.dart';

class UnavailablePlantIdentificationService
    implements PlantIdentificationService {
  const UnavailablePlantIdentificationService();

  @override
  Future<PlantIdentification> identify(PlantPhotoInput photo) async {
    debugPrint('Identification requested but no AI source is configured');
    throw AppFailure(AppFailureCode.plantIdentificationUnavailable);
  }
}
