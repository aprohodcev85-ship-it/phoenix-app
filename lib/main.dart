import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  // Убираем всю инициализацию Firebase
  WidgetsFlutterBinding.ensureInitialized();
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
      // Упрощаем тему, чтобы не было зависимостей
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
    );
  }
}
