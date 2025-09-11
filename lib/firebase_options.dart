// File: lib/firebase_options.dart
// AUTO-GENERATED BASED ON google-services.json

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'FirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyD7e5OVs1xzTsIDX5iEkW4Bow4RMnusv7U",
    appId: "1:418811908380:android:a7557769172f388e01ead9",
    messagingSenderId: "418811908380",
    projectId: "rizzbot-e36f8",
    storageBucket: "rizzbot-e36f8.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyD7e5OVs1xzTsIDX5iEkW4Bow4RMnusv7U",
    appId: "1:418811908380:ios:dummyappid", // Eğer iOS için ayrı appId varsa buraya yazılacak
    messagingSenderId: "418811908380",
    projectId: "rizzbot-e36f8",
    storageBucket: "rizzbot-e36f8.firebasestorage.app",
    iosBundleId: "com.rootcrack.rizzbot",
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyD7e5OVs1xzTsIDX5iEkW4Bow4RMnusv7U",
    appId: "1:418811908380:web:dummyappid", // Eğer Web için ayrı appId varsa buraya yazılacak
    messagingSenderId: "418811908380",
    projectId: "rizzbot-e36f8",
    storageBucket: "rizzbot-e36f8.firebasestorage.app",
  );
}
