import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import 'package:succucare_app/core/errors/errors.dart';

abstract class PlantPhotoDatasource {
  Future<String> uploadPlantPhoto(String plantId, File imageFile);
  Future<void> deletePlantPhoto(String photoUrl);
}

class FirebasePlantPhotoDatasource implements PlantPhotoDatasource {
  final _storage = FirebaseStorage.instance;
  final _user = FirebaseAuth.instance.currentUser;

  @override
  Future<String> uploadPlantPhoto(String plantId, File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child(
      'users/${_user?.uid}/plants/$plantId/photos/$fileName.jpg',
    );

    try {
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      debugPrint('Error uploading plant photo: $error');
      throw AppFailure.from(error);
    }
  }

  @override
  Future<void> deletePlantPhoto(String photoUrl) async {
    final uri = Uri.parse(photoUrl);
    final encodedPath = uri.pathSegments.last;
    final storagePath = Uri.decodeComponent(encodedPath);

    try {
      await _storage.ref(storagePath).delete();
    } catch (error) {
      debugPrint('Error deleting plant photo: $error');
      throw AppFailure.from(error);
    }
  }
}
