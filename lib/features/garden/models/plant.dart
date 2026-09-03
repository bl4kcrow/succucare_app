import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant.freezed.dart';

enum PlantHealthStatus {
  needsWater,
  thriving,
  needsLight,
}

enum PlantCareMetric {
  moisture,
  lightExposure,
}

enum PlantCategory {
  succulents,
  cactus,
  indoor,
  outdoor,
}

enum PlantCategoryFilter {
  all(null),
  succulents(PlantCategory.succulents),
  cactus(PlantCategory.cactus),
  indoor(PlantCategory.indoor),
  outdoor(PlantCategory.outdoor);

  const PlantCategoryFilter(this.category);
  final PlantCategory? category;
}

@freezed
abstract class Plant with _$Plant {
  const factory Plant({
    required String id,
    required String name,
    required String scientificName,
    required String imageUrl,
    required PlantHealthStatus healthStatus,
    required PlantCareMetric careMetric,
    required double careLevel,
    required Set<PlantCategory> categories,
  }) = _Plant;
}