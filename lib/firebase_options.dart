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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD7uv7DtLW7onYigCYfWZmue4exFCPtk-U',
    appId: '1:354338341734:web:4a6e7243a383a733353ea7',
    messagingSenderId: '354338341734',
    projectId: 'pfa-2023-iit',
    authDomain: 'pfa-2023-iit.firebaseapp.com',
    storageBucket: 'pfa-2023-iit.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCgsCrkcaIoWz7YO_rMgFEsfI4ze-WKDTM',
    appId: '1:354338341734:android:f50b8b5f539477be353ea7',
    messagingSenderId: '354338341734',
    projectId: 'pfa-2023-iit',
    storageBucket: 'pfa-2023-iit.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAGCzEr7FhnPumMfBCgiT6f_3wS1mtJpjU',
    appId: '1:354338341734:ios:484a3598f02eae52353ea7',
    messagingSenderId: '354338341734',
    projectId: 'pfa-2023-iit',
    storageBucket: 'pfa-2023-iit.appspot.com',
    iosClientId: '354338341734-do1ic9fl7ku9j769rkup0fcmb5snlka3.apps.googleusercontent.com',
    iosBundleId: 'com.example.pfa2023Iit',
  );
}
