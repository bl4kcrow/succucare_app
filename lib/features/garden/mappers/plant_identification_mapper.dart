import 'package:succucare_app/features/garden/models/models.dart';

const int _minWateringIntervalDays = 1;
const int _maxWateringIntervalDays = 365;

Category? mapStringToCategory(String? value) {
  if (value == null) {
    return null;
  }

  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  for (final category in Category.values) {
    if (category.name == trimmed) {
      return category;
    }
  }

  return null;
}

LightLevel? mapStringToLightLevel(String? value) {
  if (value == null) {
    return null;
  }

  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  for (final lightLevel in LightLevel.values) {
    if (lightLevel.name == trimmed) {
      return lightLevel;
    }
  }

  return null;
}

int? mapStringToWateringIntervalDays(String? value) {
  if (value == null) {
    return null;
  }

  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final parsed = int.tryParse(trimmed);
  if (parsed == null) {
    return null;
  }

  if (parsed < _minWateringIntervalDays) {
    return null;
  }

  if (parsed > _maxWateringIntervalDays) {
    return null;
  }

  return parsed;
}

String resolveMimeTypeFromPath(String path) {
  if (path.isEmpty) {
    return 'image/jpeg';
  }

  final extension = path.split('.').last.toLowerCase();
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'heic':
      return 'image/heic';
    default:
      return 'image/jpeg';
  }
}
