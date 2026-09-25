import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:succucare_app/features/garden/datasource/datasource.dart';
import 'package:succucare_app/features/garden/repositories/repositories.dart';

part 'photos_repository_impl_provider.g.dart';

@riverpod
PhotosRepository photosRepositoryImpl(Ref ref) =>
    PhotosRepositoryImpl(FirebasePlantPhotoDatasource());

class PhotosRepositoryImpl implements PhotosRepository {
  PhotosRepositoryImpl(this.plantPhotoDatasource);

  final PlantPhotoDatasource plantPhotoDatasource;

  @override
  Future<String> uploadPlantPhoto(String plantId, File imageFile) {
    return plantPhotoDatasource.uploadPlantPhoto(plantId, imageFile);
  }

  @override
  Future<void> deletePlantPhoto(String photoUrl) {
    return plantPhotoDatasource.deletePlantPhoto(photoUrl);
  }
}
