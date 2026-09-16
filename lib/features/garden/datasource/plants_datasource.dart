import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:succucare_app/features/garden/mappers/mappers.dart';
import 'package:succucare_app/features/garden/models/models.dart';

abstract class PlantsDatasource {
  Future<PlantPage> loadInitialPlants();
  Future<PlantPage> loadNextPlants(dynamic cursor);
  Future<String> createPlant(Plant plant);
  Future<void> updatePlantPhotoUrl(String url, String plantId);
}

class FirestorePlantsDatasource implements PlantsDatasource {
  final db = FirebaseFirestore.instance;

  static const int _queryLimit = 10;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Query<Map<String, dynamic>> get _plantsQuery => db
      .collection('users')
      .doc('$_uid')
      .collection('plants')
      .orderBy('createdAt', descending: true)
      .orderBy(FieldPath.documentId, descending: true);

  Future<PlantPage> _loadPlants(Query<Map<String, dynamic>> query) async {
    final querySnapshot = await query.limit(_queryLimit).get();

    final plants = querySnapshot.docs.map((documentSnapshot) {
      return PlantMapper.firestorePlantToPlant(
        FirestorePlant.fromSnapshot(documentSnapshot),
      );
    }).toList();

    final hasMore = querySnapshot.docs.length == _queryLimit;
    final cursor = hasMore ? querySnapshot.docs.last : null;

    return PlantPage(plants: plants, nextCursor: cursor);
  }

  @override
  Future<PlantPage> loadInitialPlants() {
    return _loadPlants(_plantsQuery);
  }

  @override
  Future<PlantPage> loadNextPlants(dynamic cursor) {
    if (cursor != null && cursor is DocumentSnapshot) {
      return _loadPlants(_plantsQuery.startAfterDocument(cursor));
    } else {
      return Future.value(const PlantPage(plants: []));
    }
  }

  @override
  Future<String> createPlant(Plant plant) async {
    final firestorePlant = PlantMapper.plantToFirestorePlant(plant);
    final data = firestorePlant.toJson();

    String docId = '';

    final docRef = db
        .collection('users')
        .doc('$_uid')
        .collection('plants')
        .doc();

    data['id'] = docId = docRef.id;

    await docRef.set(data);

    return docId;
  }

  @override
  Future<void> updatePlantPhotoUrl(String url, String plantId) async {
    final docRef = db
        .collection('users')
        .doc('$_uid')
        .collection('plants')
        .doc(plantId);

    await docRef.update({'primaryPhotoUrl': url});
  }
}

class MockPlantsDatasource implements PlantsDatasource {
  @override
  Future<PlantPage> loadInitialPlants() {
    return Future.value(
      PlantPage(
        plants: [
          Plant(
            id: '1',
            commonName: 'Luna',
            scientificName: 'Echeveria Elegans',
            category: Category.succulents,
            primaryPhotoUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDI22nCnBKjh3umnQpq8l4i5jGIziuZ71KqzqUU56PSXjEjPklg8paxPB43BtW3U-Kg674Pt5IRhBXk465oVGtvg9rP1Pu-ymwnBR0UyibGTogkWFK7JRU8T8X_jVxOQgYqGeI44pamGFi2Buys8FkMJXhlUN62ds1V6lNzfQnSKcZS1eJj5rGK4YUFDg2mzBoK8JJ7yAH8fzvUHskgIDAjWoeDrx9kOE_mzUGRpNS6ysBWcszwJIdw',
            healthStatus: HealthStatus.recovering,
            lightingChange: false,
            needsWater: false,
            repotting: true,
            moisture: Moisture(
              level: MoistureLevel.medium,
              source: MoistureSource.manual,
              updatedAt: DateTime(2026, 9, 6, 17, 30),
            ),
            illumination: Illumination(
              current: LightLevel.fullSun,
              target: LightLevel.fullSun,
              updatedAt: DateTime(2026, 9, 6, 17, 30),
            ),
            lastWateredAt: DateTime(2026, 9, 1, 09, 30),
            wateringIntervalDays: 28,
            nextWateringAt: DateTime(2026, 9, 28, 09, 30),
            searchKeywords: ['Luna', 'Echeveria', 'Elegans'],
            notes: 'plant 1',
            createdAt: DateTime(2026, 9, 6, 17, 30),
            updatedAt: DateTime(2026, 9, 6, 17, 30),
          ),
          Plant(
            id: '2',
            commonName: 'Jade',
            scientificName: 'Crassula Ovata',
            category: Category.succulents,
            primaryPhotoUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuA3HC47NTBjlaiCumieOHHK8tMn-lj_V5q5Gyzp9xKpHrGpxgD_8HZtGbal74f8vJvwkQ9gE_WJFPkD5xxmgKaVTshfpPLDEaeaTbrfg0pQihH3iKaSNXMPKBW2uxLEvGCmlWoL7-KJocWVq3ZDePvCSii2RpQhUMtbgcuZPTtUa53rRCWnulOcQmZ5asKwvIW9l-8HedbI4dE06v3N5alr4pOgxsNYtyQj2eG7Et-EG0htpgtS8bLd',
            healthStatus: HealthStatus.healthy,
            lightingChange: false,
            needsWater: false,
            repotting: false,
            moisture: Moisture(
              level: MoistureLevel.optimal,
              source: MoistureSource.manual,
              updatedAt: DateTime(2026, 9, 6, 17, 30),
            ),
            illumination: Illumination(
              current: LightLevel.fullSun,
              target: LightLevel.brightIndirect,
              updatedAt: DateTime(2026, 9, 6, 17, 30),
            ),
            lastWateredAt: DateTime(2026, 9, 2, 10, 10),
            wateringIntervalDays: 14,
            nextWateringAt: DateTime(2026, 9, 16, 10, 10),
            searchKeywords: ['Jade', 'Crassula', 'Ovata'],
            notes: 'plant 2',
            createdAt: DateTime(2026, 9, 6, 17, 30),
            updatedAt: DateTime(2026, 9, 6, 17, 30),
          ),
          Plant(
            id: '3',
            commonName: 'Zebra',
            scientificName: 'Haworthia Fasciata',
            category: Category.succulents,
            primaryPhotoUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBhNg2fsiIccN1FIc0ErzPTVGBk_mfl1aHpHzFfqS-JvluLZjBlSAtSAHjJcl3UHKaTTZodRHO6JmZQXFYoy1luZmu-KD7ieRLGslNRwEG3BZdVc4X5q0p1ARFOLNfbvoTxCFONaf2yM4Fls51WVRgnpzq6tw7Ftf8oFNx13crOavWBLsVevxwwIukL3c8l3bYde8lcDBqsZr7XHLbdk1MXJaJI73U-98rqMIGaneY-CScXgUoXIZ2s',
            healthStatus: HealthStatus.healthy,
            lightingChange: false,
            needsWater: false,
            repotting: false,
            moisture: Moisture(
              level: MoistureLevel.low,
              source: MoistureSource.manual,
              updatedAt: DateTime(2026, 9, 3, 17, 30),
            ),
            illumination: Illumination(
              current: LightLevel.partialSun,
              target: LightLevel.fullSun,
              updatedAt: DateTime(2026, 9, 6, 17, 30),
            ),
            lastWateredAt: DateTime(2026, 9, 2, 10, 10),
            wateringIntervalDays: 14,
            nextWateringAt: DateTime(2026, 9, 16, 10, 10),
            searchKeywords: ['Zebra', 'Haworthia', 'Fasciata'],
            notes: 'plant 3',
            createdAt: DateTime(2026, 9, 6, 17, 30),
            updatedAt: DateTime(2026, 9, 6, 17, 30),
          ),
        ],
      ),
    );
  }

  @override
  Future<PlantPage> loadNextPlants(dynamic cursor) {
    return Future.value(
      PlantPage(
        plants: [
          Plant(
            id: '4',
            commonName: 'Pearls',
            scientificName: 'Senecio Rowleyanus',
            category: Category.succulents,
            primaryPhotoUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuC6KMNn4CdZgiIqZTBxNNfseIxsYO6yV4ATRb0z4X3KRJ_g9Gg9RZQjEbzEEMNQZeqw4xLFi26Y4pKryMIAxLCWZn8tALjsMPZEBudJk-6vqjod0utyFb7u7zk0s_7zYolAHIc9ASFcEbQIQ9knALgVj5CdTIbi_RhN_DoH_eWgLjJGMafEEdUTu1sqLnwL69hr_5WnOl7if9BcFAfeqepqmd1GWfrODTtPK_-k07ZbHK_lJutUeieo',
            healthStatus: HealthStatus.sick,
            lightingChange: true,
            needsWater: false,
            repotting: true,
            moisture: Moisture(
              level: MoistureLevel.low,
              source: MoistureSource.manual,
              updatedAt: DateTime(2026, 9, 3, 17, 30),
            ),
            illumination: Illumination(
              current: LightLevel.fullSun,
              target: LightLevel.fullSun,
              updatedAt: DateTime(2026, 9, 6, 17, 30),
            ),
            lastWateredAt: DateTime(2026, 9, 2, 10, 30),
            wateringIntervalDays: 28,
            nextWateringAt: DateTime(2026, 9, 30, 10, 30),
            searchKeywords: ['Pearls', 'Senecio', 'Rowleyanus'],
            notes: 'plant 4',
            createdAt: DateTime(2026, 9, 6, 17, 30),
            updatedAt: DateTime(2026, 9, 6, 17, 30),
          ),
        ],
      ),
    );
  }

  @override
  Future<String> createPlant(Plant plant) async {
    // Mock implementation: no-op
    return '';
  }

  @override
  Future<void> updatePlantPhotoUrl(String url, String plantId) {
    // TODO: implement updatePlantPhotoUrl
    throw UnimplementedError();
  }
}
