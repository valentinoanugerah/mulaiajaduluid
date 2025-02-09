// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdBpGtn81eitqA5nc6OwI41sjU5FXerCc',
    appId: '1:180933679268:android:c1a85407db635149112e31',
    messagingSenderId: '180933679268',
    projectId: 'test-8c976',
    storageBucket: 'test-8c976.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBaIr2w88f-Av2SFQJGcEeZHFxiRC_giYI',
    appId: '1:180933679268:ios:74ebc5c02b4f1141112e31',
    messagingSenderId: '180933679268',
    projectId: 'test-8c976',
    storageBucket: 'test-8c976.firebasestorage.app',
    androidClientId: '180933679268-1ah9q4tk1hmaik51fgs56gps0bv6h9f1.apps.googleusercontent.com',
    iosClientId: '180933679268-9q5v2kmoukduajro0q6v1pe32te6v721.apps.googleusercontent.com',
    iosBundleId: 'com.mulaiajaduluid.huawei',
  );

}