import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Generated from the "helathcare" Firebase project's Android and Web apps
/// (see android/app/google-services.json and the Firebase console web app
/// config). If iOS support is needed later, add an iOS app in the Firebase
/// console and regenerate this file with `flutterfire configure`.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions have only been configured for Android and Web. '
          'Add an app for this platform in the Firebase console and run '
          '`flutterfire configure`.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4gOMdzIYnysHMqA_F9ogLljOnKv_hkFQ',
    appId: '1:368843270200:android:72441bfbcb08e271d89ecd',
    messagingSenderId: '368843270200',
    projectId: 'helathcare-2b4b9',
    storageBucket: 'helathcare-2b4b9.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC8NsS7yNbxh7qXZGKVIURDOLJ_lrZUpGA',
    appId: '1:368843270200:web:6a55d17a2847f7f3d89ecd',
    messagingSenderId: '368843270200',
    projectId: 'helathcare-2b4b9',
    authDomain: 'helathcare-2b4b9.firebaseapp.com',
    storageBucket: 'helathcare-2b4b9.firebasestorage.app',
    measurementId: 'G-Y0BE4Y5PVL',
  );
}
