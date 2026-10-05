/// Used when `AI_MODEL` is not set. A Flash model, because identification from
/// a single photo against a constrained output schema is small and
/// latency-sensitive, and it runs on every photo the user attaches.
const String defaultIdentificationModel = 'gemini-3.7-flash';

const String plantIdentificationPrompt = '''
You are identifying a succulent or cactus plant from a single photo. Propose a likely identity and sensible care defaults for the plant in the photo.

Only return fields the system can store. For each field, omit it if you are not confident rather than guessing.

Permitted fields (all optional):
- commonName: the most common name in English or Spanish, if known
- scientificName: the binomial scientific name, if known
- category: one of "succulents", "cactus", or "lithops" — only use if the plant clearly matches
- wateringIntervalDays: a positive whole number of days between waterings, between 1 and 365 inclusive
- lightLevel: one of "fullSun", "brightIndirect", "partialSun", or "shade" — only use if you can infer it

Instructions:
- Do not invent a field that is not listed above.
- If you are unsure of any field, omit that field entirely.
- Return only values that are plausible for the plant shown.
- Prefer accuracy over completeness. It is better to omit many fields than to guess.
''';

const List<String> plantIdentificationCategoryEnum = [
  'succulents',
  'cactus',
  'lithops',
];

const List<String> plantIdentificationLightLevelEnum = [
  'fullSun',
  'brightIndirect',
  'partialSun',
  'shade',
];
