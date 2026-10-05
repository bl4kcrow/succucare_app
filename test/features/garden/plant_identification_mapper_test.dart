import 'package:flutter_test/flutter_test.dart';
import 'package:succucare_app/features/garden/mappers/mappers.dart';
import 'package:succucare_app/features/garden/models/models.dart';

void main() {
  group('mapStringToCategory', () {
    test('returns the matching category name', () {
      expect(mapStringToCategory('succulents'), Category.succulents);
      expect(mapStringToCategory('cactus'), Category.cactus);
      expect(mapStringToCategory('lithops'), Category.lithops);
    });

    test('returns null when category is out of vocabulary', () {
      expect(mapStringToCategory('aloe'), isNull);
      expect(mapStringToCategory('suculent'), isNull);
    });

    test('returns null when input is null or empty', () {
      expect(mapStringToCategory(null), isNull);
      expect(mapStringToCategory(''), isNull);
      expect(mapStringToCategory('   '), isNull);
    });
  });

  group('mapStringToLightLevel', () {
    test('returns the matching light level', () {
      expect(mapStringToLightLevel('fullSun'), LightLevel.fullSun);
      expect(mapStringToLightLevel('brightIndirect'), LightLevel.brightIndirect);
      expect(mapStringToLightLevel('partialSun'), LightLevel.partialSun);
      expect(mapStringToLightLevel('shade'), LightLevel.shade);
    });

    test('returns null when light level is out of vocabulary', () {
      expect(mapStringToLightLevel('direct'), isNull);
      expect(mapStringToLightLevel('low'), isNull);
    });

    test('returns null when input is null or empty', () {
      expect(mapStringToLightLevel(null), isNull);
      expect(mapStringToLightLevel(''), isNull);
    });
  });

  group('mapStringToWateringIntervalDays', () {
    test('returns a positive whole number within range', () {
      expect(mapStringToWateringIntervalDays('7'), 7);
      expect(mapStringToWateringIntervalDays('14'), 14);
      expect(mapStringToWateringIntervalDays('365'), 365);
      expect(mapStringToWateringIntervalDays('1'), 1);
    });

    test('returns null for zero, negative, or above ceiling', () {
      expect(mapStringToWateringIntervalDays('0'), isNull);
      expect(mapStringToWateringIntervalDays('-3'), isNull);
      expect(mapStringToWateringIntervalDays('366'), isNull);
      expect(mapStringToWateringIntervalDays('1000'), isNull);
    });

    test('returns null for non-integer values', () {
      expect(mapStringToWateringIntervalDays('7.5'), isNull);
      expect(mapStringToWateringIntervalDays('abc'), isNull);
      expect(mapStringToWateringIntervalDays(null), isNull);
      expect(mapStringToWateringIntervalDays(''), isNull);
      expect(mapStringToWateringIntervalDays(' 14 '), 14);
    });
  });

  group('resolveMimeTypeFromPath', () {
    test('derives the type from the file extension and falls back to image/jpeg', () {
      expect(resolveMimeTypeFromPath('photo.jpg'), 'image/jpeg');
      expect(resolveMimeTypeFromPath('photo.jpeg'), 'image/jpeg');
      expect(resolveMimeTypeFromPath('photo.PNG'), 'image/png');
      expect(resolveMimeTypeFromPath('photo.heic'), 'image/heic');
      expect(resolveMimeTypeFromPath('photo.unknown'), 'image/jpeg');
      expect(resolveMimeTypeFromPath(''), 'image/jpeg');
    });
  });
}
