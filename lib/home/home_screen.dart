import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../profile/profile_screen.dart';
import '../transport/transport_search_screen.dart';
import '../chat/chat_list_screen.dart';
import '../data/repository/user_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await UserRepository().getUserData();
    if (mounted) {
      setState(() {
        _userData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomePage(),
          _buildCargoPage(),
          _buildTransportPage(),
          _buildChatPage(),
          _buildProfilePage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => context.push('/add-cargo'),
              backgroundColor: const Color(0xFFFF6B35),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  // ==================== ГЛАВНАЯ СТРАНИЦА ====================
  Widget _buildHomePage() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildMarketStats(),
            _buildQuickActions(),
            _buildAIBanner(),
            _buildRecentCargos(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Шапка с динамическим именем
  Widget _buildHeader() {
    final userName = _userData?['name'] ?? 'Гость';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A5F), Color(0xFF2E5090)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Привет, $userName! 👋',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'PHOENIX',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Уведомления подключены'),
                      backgroundColor: Color(0xFF2ECC71),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Поиск
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => context.push('/search-cargo'),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(Icons.search_rounded,
                  color: Colors.white.withOpacity(0.6), size: 22),
              const SizedBox(width: 10),
              Text(
                'Найти груз или транспорт...',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 15),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune_rounded,
                    color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Статистика рынка
  Widget _buildMarketStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Рынок сегодня',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('Грузов', '18 492', '+234',
                  Icons.inventory_2_outlined, const Color(0xFF3498DB)),
              const SizedBox(width: 10),
              _buildStatCard('Машин', '9 847', '+89',
                  Icons.local_shipping_outlined, const Color(0xFFFF6B35)),
              const SizedBox(width: 10),
              _buildStatCard('Сделок', '3 201', '+112',
                  Icons.handshake_outlined, const Color(0xFF2ECC71)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String change, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            Text(title,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6), fontSize: 11)),
            const SizedBox(height: 4),
            Text(change,
                style: const TextStyle(
                    color: Color(0xFF2ECC71),
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // Быстрые действия
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Быстрые действия',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickAction('Добавить\nгруз', Icons.add_box_outlined,
                  const Color(0xFF3498DB),
                  onTap: () => context.push('/add-cargo')),
              _buildQuickAction('Добавить\nмашину',
                  Icons.local_shipping_outlined, const Color(0xFFFF6B35),
                  onTap: () => context.push('/add-transport')),
              _buildQuickAction('Мои\nзаявки', Icons.assignment_rounded,
                  const Color(0xFF9B59B6),
                  onTap: () => context.push('/my-orders')),
              _buildQuickAction('Поиск\nгрузов', Icons.search_rounded,
                  const Color(0xFF2ECC71),
                  onTap: () => context.push('/search-cargo')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon, Color color,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 11,
                  height: 1.3)),
        ],
      ),
    );
  }

  // AI Баннер
  Widget _buildAIBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF2E5090), Color(0xFF1E3A5F)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.auto_awesome_rounded,
                color: Color(0xFFFF6B35)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI подобрал для вас',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7), fontSize: 12)),
                const SizedBox(height: 2),
                const Text('3 груза на ваш маршрут МСК → СПБ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(10)),
            child: const Text('Смотреть',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // Последние грузы
  Widget _buildRecentCargos() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Свежие грузы',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              TextButton(
                  onPressed: () => context.push('/search-cargo'),
                  child: const Text('Все →',
                      style: TextStyle(color: Color(0xFFFF6B35)))),
            ],
          ),
          const SizedBox(height: 8),
          _buildCargoCard('Москва', 'Санкт-Петербург', '120 000 ₽', '710 км',
              '20 т', 'Тент'),
          _buildCargoCard('Казань', 'Екатеринбург', '85 000 ₽', '960 км',
              '15 т', 'Рефрижератор'),
          _buildCargoCard(
              'Новосибирск', 'Красноярск', '45 000 ₽', '450 км', '8 т', 'Фура'),
        ],
      ),
    );
  }

  Widget _buildCargoCard(String from, String to, String price, String distance,
      String weight, String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Color(0xFF3498DB), shape: BoxShape.circle)),
                  Container(
                      width: 2,
                      height: 24,
                      color: Colors.white.withOpacity(0.3)),
                  Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Color(0xFFFF6B35), shape: BoxShape.circle)),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(from,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(to,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(price,
                      style: const TextStyle(
                          color: Color(0xFFFF6B35),
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(distance,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.6), fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildCargoTag(Icons.scale, weight),
              const SizedBox(width: 8),
              _buildCargoTag(Icons.local_shipping_outlined, type),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    Icon(Icons.verified, size: 12, color: Color(0xFF2ECC71)),
                    SizedBox(width: 4),
                    Text('Проверен',
                        style: TextStyle(
                            color: Color(0xFF2ECC71),
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCargoTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.white.withOpacity(0.7)),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.7), fontSize: 11)),
        ],
      ),
    );
  }

  // ==================== ДРУГИЕ СТРАНИЦЫ ====================
  Widget _buildCargoPage() => const Center(
      child:
          Text('Грузы', style: TextStyle(color: Colors.white, fontSize: 24)));
  Widget _buildTransportPage() => const TransportSearchScreen();
  Widget _buildChatPage() => const ChatListScreen();
  Widget _buildProfilePage() => const ProfileScreen();

  // ==================== НИЖНЯЯ НАВИГАЦИЯ ====================
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF152A45),
      selectedItemColor: const Color(0xFFFF6B35),
      unselectedItemColor: Colors.white70,
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Грузы'),
        BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping), label: 'Транспорт'),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline), label: 'Чат'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
      ],
    );
  }
}
