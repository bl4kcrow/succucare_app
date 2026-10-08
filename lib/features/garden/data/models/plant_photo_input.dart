import 'dart:typed_data';

class PlantPhotoInput {
  const PlantPhotoInput({required this.bytes, required this.mimeType});

  final Uint8List bytes;
  final String mimeType;
}