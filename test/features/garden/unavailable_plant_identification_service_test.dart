import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:succucare_app/core/errors/errors.dart';
import 'package:succucare_app/features/garden/models/plant_photo_input.dart';
import 'package:succucare_app/features/garden/services/unavailable_plant_identification_service.dart';

void main() {
  test('fails with the identification unavailable cause and never performs work', () async {
    const service = UnavailablePlantIdentificationService();
    final photo = PlantPhotoInput(
      bytes: Uint8List.fromList(<int>[1, 2, 3]),
      mimeType: 'image/jpeg',
    );

    expect(
      () async => service.identify(photo),
      throwsA(
        isA<AppFailure>().having(
          (f) => f.code,
          'code',
          AppFailureCode.plantIdentificationUnavailable,
        ),
      ),
    );
  });
}
