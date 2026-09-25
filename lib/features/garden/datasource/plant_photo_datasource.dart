import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

    await ref.putFile(imageFile);
    return ref.getDownloadURL();
  }

  @override
  Future<void> deletePlantPhoto(String photoUrl) async {
    final uri = Uri.parse(photoUrl);
    final encodedPath = uri.pathSegments.last;
    final storagePath = Uri.decodeComponent(encodedPath);
    await _storage.ref(storagePath).delete();
  }
}
