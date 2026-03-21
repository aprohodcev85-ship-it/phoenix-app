import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      // Для Web нужны явные параметры
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDC5enK5JH9HtdL0pQO3yzPHZzmEi-dzvA",
          authDomain: "phoenix-logistics-710ad.firebaseapp.com",
          projectId: "phoenix-logistics-710ad",
          storageBucket: "phoenix-logistics-710ad.firebasestorage.app",
          messagingSenderId: "834086078158",
          appId: "1:834086078158:web:3c71652341b9982c86f29f",
        ),
      );
    } else {
      // Для Android/iOS — автоматически через google-services.json
      await Firebase.initializeApp();
    }
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  runApp(const PhoenixApp());
}

class PhoenixApp extends StatelessWidget {
  const PhoenixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Phoenix',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
