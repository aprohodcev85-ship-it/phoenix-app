import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'splash/splash_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'role_selection/role_selection_screen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'home/home_screen.dart';
import 'search/cargo_search/cargo_search_screen.dart';
import 'cargo/detail/cargo_detail_screen.dart';
import 'my_orders/my_orders_screen.dart';
import 'add_cargo/add_cargo_screen.dart';
import 'profile/profile_screen.dart';
import 'transport/transport_search_screen.dart';
import 'transport/add_transport_screen.dart';
import 'chat/chat_list_screen.dart';
import 'chat/chat_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Splash Screen
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashScreen(),
    ),

    // Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),

    // Выбор роли
    GoRoute(
      path: '/role-selection',
      builder: (_, __) => const RoleSelectionScreen(),
    ),

    // Login с учётом выбранной роли
    GoRoute(
      path: '/login',
      builder: (context, state) {
        final role = state.uri.queryParameters['role'] ?? 'unknown';
        return LoginScreen(selectedRole: role);
      },
    ),

    // Регистрация
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterScreen(),
    ),

    // Главный экран
    GoRoute(
      path: '/home',
      builder: (context, state) {
        // Проверяем, вошел ли пользователь
        if (FirebaseAuth.instance.currentUser == null) {
          // Если нет — перенаправляем на вход
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        return const HomeScreen();
      },
    ),

    // Поиск грузов
    GoRoute(
      path: '/search-cargo',
      builder: (_, __) => const CargoSearchScreen(),
    ),

    // Детальная карточка груза
    GoRoute(
      path: '/cargo/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CargoDetailScreen(cargoId: id);
      },
    ),

    // Мои заявки
    GoRoute(
      path: '/my-orders',
      builder: (_, __) => const MyOrdersScreen(),
    ),

    // Добавление груза
    GoRoute(
      path: '/add-cargo',
      builder: (_, __) => const AddCargoScreen(),
    ),

    GoRoute(
      path: '/profile',
      builder: (_, __) => const ProfileScreen(),
    ),

    GoRoute(
      path: '/search-transport',
      builder: (_, __) => const TransportSearchScreen(),
    ),

    GoRoute(
      path: '/add-transport',
      builder: (_, __) => const AddTransportScreen(),
    ),

    GoRoute(
      path: '/chats',
      builder: (_, __) => const ChatListScreen(),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        final chatId = state.pathParameters['id']!;
        return ChatScreen(chatId: chatId);
      },
    ),
  ],
);
