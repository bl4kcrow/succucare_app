import '../models/plant.dart';

const mockPlants = <Plant>[
  Plant(
    id: '1',
    name: 'Luna',
    scientificName: 'Echeveria Elegans',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDI22nCnBKjh3umnQpq8l4i5jGIziuZ71KqzqUU56PSXjEjPklg8paxPB43BtW3U-Kg674Pt5IRhBXk465oVGtvg9rP1Pu-ymwnBR0UyibGTogkWFK7JRU8T8X_jVxOQgYqGeI44pamGFi2Buys8FkMJXhlUN62ds1V6lNzfQnSKcZS1eJj5rGK4YUFDg2mzBoK8JJ7yAH8fzvUHskgIDAjWoeDrx9kOE_mzUGRpNS6ysBWcszwJIdw',
    healthStatus: PlantHealthStatus.needsWater,
    careMetric: PlantCareMetric.moisture,
    careLevel: 0.25,
    categories: {PlantCategory.succulents, PlantCategory.indoor},
  ),
  Plant(
    id: '2',
    name: 'Jade',
    scientificName: 'Crassula Ovata',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA3HC47NTBjlaiCumieOHHK8tMn-lj_V5q5Gyzp9xKpHrGpxgD_8HZtGbal74f8vJvwkQ9gE_WJFPkD5xxmgKaVTshfpPLDEaeaTbrfg0pQihH3iKaSNXMPKBW2uxLEvGCmlWoL7-KJocWVq3ZDePvCSii2RpQhUMtbgcuZPTtUa53rRCWnulOcQmZ5asKwvIW9l-8HedbI4dE06v3N5alr4pOgxsNYtyQj2eG7Et-EG0htpgtS8bLd',
    healthStatus: PlantHealthStatus.thriving,
    careMetric: PlantCareMetric.moisture,
    careLevel: 0.75,
    categories: {
      PlantCategory.succulents,
      PlantCategory.indoor,
      PlantCategory.outdoor,
    },
  ),
  Plant(
    id: '3',
    name: 'Zebra',
    scientificName: 'Haworthia Fasciata',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBhNg2fsiIccN1FIc0ErzPTVGBk_mfl1aHpHzFfqS-JvluLZjBlSAtSAHjJcl3UHKaTTZodRHO6JmZQXFYoy1luZmu-KD7ieRLGslNRwEG3BZdVc4X5q0p1ARFOLNfbvoTxCFONaf2yM4Fls51WVRgnpzq6tw7Ftf8oFNx13crOavWBLsVevxwwIukL3c8l3bYde8lcDBqsZr7XHLbdk1MXJaJI73U-98rqMIGaneY-CScXgUoXIZ2s',
    healthStatus: PlantHealthStatus.needsLight,
    careMetric: PlantCareMetric.lightExposure,
    careLevel: 0.33,
    categories: {PlantCategory.succulents, PlantCategory.indoor},
  ),
  Plant(
    id: '4',
    name: 'Pearls',
    scientificName: 'Senecio Rowleyanus',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC6KMNn4CdZgiIqZTBxNNfseIxsYO6yV4ATRb0z4X3KRJ_g9Gg9RZQjEbzEEMNQZeqw4xLFi26Y4pKryMIAxLCWZn8tALjsMPZEBudJk-6vqjod0utyFb7u7zk0s_7zYolAHIc9ASFcEbQIQ9knALgVj5CdTIbi_RhN_DoH_eWgLjJGMafEEdUTu1sqLnwL69hr_5WnOl7if9BcFAfeqepqmd1GWfrODTtPK_-k07ZbHK_lJutUeieo',
    healthStatus: PlantHealthStatus.thriving,
    careMetric: PlantCareMetric.moisture,
    careLevel: 0.66,
    categories: {PlantCategory.indoor},
  ),
];