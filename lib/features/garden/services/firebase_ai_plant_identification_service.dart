import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import 'package:succucare_app/core/constants/environment.dart';
import 'package:succucare_app/core/errors/errors.dart';
import 'package:succucare_app/core/constants/plant_identification_ai_constants.dart';
import 'package:succucare_app/features/garden/mappers/mappers.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/services/plant_identification_service.dart';


/// The only seam through which this backend reaches the generative model.
///
/// It exists so the request building, response reading and mapping above it can
/// be exercised against a canned response without a network, and so this file
/// stays the single place that imports `package:firebase_ai`.
abstract interface class PlantIdentificationModel {
  /// Sends [parts] to the model and returns the text it answered with, or
  /// `null` when the model answered with no text.
  Future<String?> generateText(List<Content> parts);
}

class _FirebaseAiModel implements PlantIdentificationModel {
  const _FirebaseAiModel(this._model);

  final GenerativeModel _model;

  @override
  Future<String?> generateText(List<Content> parts) async {
    final response = await _model.generateContent(parts);
    return response.text;
  }
}

/// The response schema for the five permitted values, built once here so that
/// the model name stays the only thing configuration decides about the request.
final Schema _identificationResponseSchema = Schema.object(
  properties: {
    'commonName': Schema.string(
      description: 'Common name in English or Spanish.',
      nullable: true,
    ),
    'scientificName': Schema.string(
      description: 'Binomial scientific name.',
      nullable: true,
    ),
    'category': Schema.enumString(
      enumValues: plantIdentificationCategoryEnum,
      nullable: true,
    ),
    'wateringIntervalDays': Schema.integer(
      description: 'Whole days between waterings.',
      nullable: true,
      minimum: 1,
      maximum: 365,
    ),
    'lightLevel': Schema.enumString(
      enumValues: plantIdentificationLightLevelEnum,
      nullable: true,
    ),
  },
  optionalProperties: [
    'commonName',
    'scientificName',
    'category',
    'wateringIntervalDays',
    'lightLevel',
  ],
);

FirebaseAiPlantIdentificationService buildFirebaseAiPlantIdentificationService() {
  final model = FirebaseAI.googleAI().generativeModel(
    model: Environment.aiModel ?? defaultIdentificationModel,
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
      responseSchema: _identificationResponseSchema,
    ),
  );

  return FirebaseAiPlantIdentificationService(
    model: _FirebaseAiModel(model),
  );
}

class FirebaseAiPlantIdentificationService
    implements PlantIdentificationService {
  const FirebaseAiPlantIdentificationService({required this.model});

  final PlantIdentificationModel model;

  @override
  Future<PlantIdentification> identify(PlantPhotoInput photo) async {
    final String? text;

    try {
      text = await model.generateText([
        Content.text(plantIdentificationPrompt),
        Content.multi([InlineDataPart(photo.mimeType, photo.bytes)]),
      ]);
    } on FirebaseAIException catch (error) {
      debugPrint('Firebase AI rejected the identification request: $error');
      throw AppFailure(_mapAiFailureCode(error), cause: error);
    } catch (error) {
      debugPrint('Could not read the identification response: $error');
      throw AppFailure.from(error);
    }

    if (text == null || text.trim().isEmpty) {
      return const PlantIdentification();
    }

    return _mapResponse(text);
  }

  /// The AI SDK's own failures. These are recognised here rather than in
  /// `mapFirebaseErrorCode` so that no file outside this backend has to import
  /// `package:firebase_ai` to name them.
  AppFailureCode _mapAiFailureCode(FirebaseAIException error) {
    if (error is QuotaExceeded) {
      return AppFailureCode.plantIdentificationRateLimited;
    }

    return AppFailureCode.unavailable;
  }

  PlantIdentification _mapResponse(String text) {
    final Object? decoded;

    try {
      decoded = jsonDecode(text);
    } catch (error) {
      debugPrint('Identification response was not readable JSON: $error');
      return const PlantIdentification();
    }

    if (decoded is! Map) {
      debugPrint(
        'Identification response was not a JSON object: ${decoded.runtimeType}',
      );
      return const PlantIdentification();
    }

    final json = decoded.cast<String, Object?>();

    return PlantIdentification(
      commonName: _readName(json['commonName']),
      scientificName: _readName(json['scientificName']),
      category: mapStringToCategory(_readName(json['category']))?.name,
      wateringIntervalDays: mapStringToWateringIntervalDays(
        json['wateringIntervalDays']?.toString(),
      ),
      lightLevel: mapStringToLightLevel(_readName(json['lightLevel']))?.name,
    );
  }

  String? _readName(Object? value) {
    if (value is! String) return null;

    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}