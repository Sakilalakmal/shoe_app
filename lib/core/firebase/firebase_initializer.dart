// lib/core/firebase/firebase_initializer.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseInitializer {
  static Future<void> init() async {
    if (!dotenv.isInitialized) {
      await dotenv.load(fileName: ".env");
    }

    try {
      // If native Android already initialized it, this succeeds.
      Firebase.app();
      return; // Already initialized
    } on FirebaseException catch (e) {
      if (e.code != 'no-app') rethrow; // some other error — surface it
    }

    // Only initialize if no app found
    try {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: dotenv.env['API_KEY']!,
          appId: dotenv.env['APP_ID']!,
          messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
          projectId: dotenv.env['PROJECT_ID']!,
          storageBucket: dotenv.env['STORAGE_BUCKET'],
        ),
      );

      print("Firebase initialized");
    } on FirebaseException catch (e) {
      // If we raced the native init and got duplicate, just use the existing app
      if (e.code == 'duplicate-app') {
        Firebase.app();
      } else {
        rethrow;
      }
    }
  }
}
