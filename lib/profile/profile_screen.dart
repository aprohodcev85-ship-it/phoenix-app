import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/repository/user_repository.dart'; // ВАЖНЫЙ ИМПОРТ

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await UserRepository().getUserData();
    if (mounted) {
      setState(() {
        _userData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    // Если пользователь не авторизован (данных нет)
    if (_userData == null) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/login'),
            child: const Text('Войти в аккаунт'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              _userData!['name'] ?? 'Имя не указано',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
            Text(
              _userData!['phone'] ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Здесь будет логика выхода
                context.go('/login');
              },
              child: const Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }
}
