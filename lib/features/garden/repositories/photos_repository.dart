import 'dart:io';

abstract class PhotosRepository {
  Future<String> uploadPlantPhoto(String plantId, File imageFile);
  Future<void> deletePlantPhoto(String photoUrl);
}
