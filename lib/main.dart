import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
