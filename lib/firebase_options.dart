import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
/// Run `flutterfire configure` to generate project-specific options automatically.
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCbspnA7E1wFxoOPY9wmIyQM8_6OhoGXIs',
    appId: '1:176637569015:web:b81e799c4fe438af8d70f2',
    messagingSenderId: '176637569015',
    projectId: 'unismart-709d2',
    authDomain: 'unismart-709d2.firebaseapp.com',
    databaseURL: 'https://unismart-709d2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'unismart-709d2.firebasestorage.app',
    measurementId: 'G-KRVYWDC5MW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbspnA7E1wFxoOPY9wmIyQM8_6OhoGXIs',
    appId: '1:176637569015:android:4898ae930f1a42a68d70f2',
    messagingSenderId: '176637569015',
    projectId: 'unismart-709d2',
    databaseURL: 'https://unismart-709d2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'unismart-709d2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbspnA7E1wFxoOPY9wmIyQM8_6OhoGXIs',
    appId: '1:176637569015:ios:abcdef123456',
    messagingSenderId: '176637569015',
    projectId: 'unismart-709d2',
    databaseURL: 'https://unismart-709d2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'unismart-709d2.firebasestorage.app',
    iosBundleId: 'com.example.flutterPos',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCbspnA7E1wFxoOPY9wmIyQM8_6OhoGXIs',
    appId: '1:176637569015:ios:abcdef123456',
    messagingSenderId: '176637569015',
    projectId: 'unismart-709d2',
    databaseURL: 'https://unismart-709d2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'unismart-709d2.firebasestorage.app',
    iosBundleId: 'com.example.flutterPos',
  );
}

