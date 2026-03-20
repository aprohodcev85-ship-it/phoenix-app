import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  // ИНИЦИАЛИЗАЦИЯ FIREBASE УДАЛЕНА ДЛЯ ТЕСТА
  // await Firebase.initializeApp();

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
      theme: ThemeData.dark(), // Темная тема по умолчанию для красоты
    );
  }
}
