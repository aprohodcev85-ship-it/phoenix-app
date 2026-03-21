import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final String selectedRole;
  const LoginScreen({super.key, this.selectedRole = 'unknown'});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  String get roleTitle {
    if (widget.selectedRole == 'carrier') return 'Перевозчик';
    if (widget.selectedRole == 'shipper') return 'Грузовладелец';
    return 'Пользователь';
  }

  IconData get roleIcon {
    return widget.selectedRole == 'carrier'
        ? Icons.local_shipping_rounded
        : Icons.inventory_2_rounded;
  }

  Color get roleColor {
    return widget.selectedRole == 'carrier'
        ? const Color(0xFFFF6B35)
        : const Color(0xFF2ECC71);
  }

  void _login() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty)
      return;

    setState(() => _isLoading = true);
    try {
      // Входим по номеру телефона (через виртуальный email)
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "${_phoneController.text.replaceAll('+', '')}@phoenix.com",
        password: _passwordController.text,
      );

      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Неверный телефон или пароль')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _changeRole() {
    context.go('/role-selection');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // Плашка выбранной роли
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: roleColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: roleColor.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Icon(roleIcon, color: roleColor, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Вы выбрали роль',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          Text(
                            roleTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _changeRole,
                      child: const Text(
                        'Сменить',
                        style: TextStyle(color: Color(0xFFFF6B35)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Center(
                child: Column(
                  children: [
                    const Icon(Icons.local_fire_department_rounded,
                        size: 70, color: Color(0xFFFF6B35)),
                    const SizedBox(height: 12),
                    const Text('PHOENIX',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3)),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              const Text('Вход в аккаунт',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Введите данные для входа',
                  style: TextStyle(color: Colors.white70, fontSize: 15)),

              const SizedBox(height: 32),

              // Поля ввода (телефон и пароль)
              const Text('Номер телефона',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '+7 (999) 123-45-67',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.phone, color: Colors.white54),
                ),
              ),

              const SizedBox(height: 20),

              const Text('Пароль',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white54),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white54),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Войти',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600)),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Нет аккаунта?',
                      style: TextStyle(color: Colors.white70)),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    child: const Text('Зарегистрироваться',
                        style: TextStyle(
                            color: Color(0xFFFF6B35),
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
