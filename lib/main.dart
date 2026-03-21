import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
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
      await Firebase.initializeApp();
    }
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase init error: $e');
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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E3A5F),
        primaryColor: const Color(0xFFFF6B35),
      ),
    );
  }
}
