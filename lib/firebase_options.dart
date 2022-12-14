// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC5svKDZggTj791tQUD6VVTL3RpPyd6L-0',
    appId: '1:968906186542:web:2b6748a5b7f0169ddaa4bf',
    messagingSenderId: '968906186542',
    projectId: 'handong-real-estate',
    authDomain: 'handong-real-estate.firebaseapp.com',
    storageBucket: 'handong-real-estate.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC08i4ekuz0XViLxsf395iF5wvOtFuztiw',
    appId: '1:968906186542:ios:7550dcd76cdf13f7daa4bf',
    messagingSenderId: '968906186542',
    projectId: 'handong-real-estate',
    storageBucket: 'handong-real-estate.appspot.com',
    iosClientId: '968906186542-09tg4qqjplqvi9m062c9ikjum5fi5qlq.apps.googleusercontent.com',
    iosBundleId: 'com.example.hre.handongRealEstate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC08i4ekuz0XViLxsf395iF5wvOtFuztiw',
    appId: '1:968906186542:ios:7550dcd76cdf13f7daa4bf',
    messagingSenderId: '968906186542',
    projectId: 'handong-real-estate',
    storageBucket: 'handong-real-estate.appspot.com',
    iosClientId: '968906186542-09tg4qqjplqvi9m062c9ikjum5fi5qlq.apps.googleusercontent.com',
    iosBundleId: 'com.example.hre.handongRealEstate',
  );
}
