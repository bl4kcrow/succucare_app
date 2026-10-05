
import '../models/models.dart';

abstract interface class PlantIdentificationService {
  Future<PlantIdentification> identify(PlantPhotoInput photo);
}
