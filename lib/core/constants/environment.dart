import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  const Environment._({
    required this.firebaseAppIdAndroid,
    required this.firebaseAppIdIos,
    required this.firebaseAppIdWeb,
    required this.firebaseApiKeyAndroid,
    required this.firebaseApiKeyIos,
    required this.firebaseApiKeyWeb,
    required this.firebaseMessagingSenderId,
  });

  final String firebaseAppIdAndroid;
  final String firebaseAppIdIos;
  final String firebaseAppIdWeb;
  final String firebaseApiKeyAndroid;
  final String firebaseApiKeyIos;
  final String firebaseApiKeyWeb;
  final String firebaseMessagingSenderId;

  factory Environment.dev() => Environment._(
    firebaseAppIdAndroid: dotenv.get('FIREBASE_APPID_ANDROID_DEV'),
    firebaseAppIdIos: dotenv.get('FIREBASE_APPID_IOS_DEV'),
    firebaseAppIdWeb: dotenv.get('FIREBASE_APPID_WEB_DEV'),
    firebaseApiKeyAndroid: dotenv.get('FIREBASE_APIKEY_ANDROID_DEV'),
    firebaseApiKeyIos: dotenv.get('FIREBASE_APIKEY_IOS_DEV'),
    firebaseApiKeyWeb: dotenv.get('FIREBASE_APIKEY_WEB_DEV'),
    firebaseMessagingSenderId: dotenv.get('FIREBASE_MESSAGING_SENDER_ID_DEV'),
  );

  factory Environment.prod() => Environment._(
    firebaseAppIdAndroid: dotenv.get('FIREBASE_APPID_ANDROID'),
    firebaseAppIdIos: dotenv.get('FIREBASE_APPID_IOS'),
    firebaseAppIdWeb: dotenv.get('FIREBASE_APPID_WEB'),
    firebaseApiKeyAndroid: dotenv.get('FIREBASE_APIKEY_ANDROID'),
    firebaseApiKeyIos: dotenv.get('FIREBASE_APIKEY_IOS'),
    firebaseApiKeyWeb: dotenv.get('FIREBASE_APIKEY_WEB'),
    firebaseMessagingSenderId: dotenv.get('FIREBASE_MESSAGING_SENDER_ID'),
  );
}
