class PlantIdentification {
  const PlantIdentification({
    this.commonName,
    this.scientificName,
    this.category,
    this.wateringIntervalDays,
    this.lightLevel,
  });

  final String? commonName;
  final String? scientificName;
  final String? category;
  final int? wateringIntervalDays;
  final String? lightLevel;
}