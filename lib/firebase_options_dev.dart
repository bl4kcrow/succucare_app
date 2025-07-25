// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'core/constants/environment.dart';

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static final Environment _environment = Environment.dev();
  
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static final FirebaseOptions web = FirebaseOptions(
    apiKey: _environment.firebaseApiKeyWeb,
    appId: _environment.firebaseAppIdWeb,
    messagingSenderId: _environment.firebaseMessagingSenderId,
    projectId: 'succucare-db-dev',
    authDomain: 'succucare-db-dev.firebaseapp.com',
    storageBucket: 'succucare-db-dev.firebasestorage.app',
    measurementId: 'G-H723ZH2Z01',
  );

  static final FirebaseOptions android = FirebaseOptions(
    apiKey: _environment.firebaseApiKeyAndroid,
    appId: _environment.firebaseAppIdAndroid,
    messagingSenderId: _environment.firebaseMessagingSenderId,
    projectId: 'succucare-db-dev',
    storageBucket: 'succucare-db-dev.firebasestorage.app',
  );

  static final FirebaseOptions ios = FirebaseOptions(
    apiKey: _environment.firebaseApiKeyIos,
    appId: _environment.firebaseAppIdIos,
    messagingSenderId: _environment.firebaseMessagingSenderId,
    projectId: 'succucare-db-dev',
    storageBucket: 'succucare-db-dev.firebasestorage.app',
    iosBundleId: 'com.bl4kcrow.succucare',
  );
}
