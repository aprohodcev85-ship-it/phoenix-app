import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Найдите груз за минуту',
      'description': 'Тысячи актуальных грузов по всей России. Умный поиск подберёт заказы именно для вас.',
      'icon': Icons.search_rounded,
      'color': Color(0xFF3498DB),
    },
    {
      'title': 'Надёжные партнёры',
      'description': 'Все перевозчики проходят проверку. Рейтинги и отзывы помогут сделать правильный выбор.',
      'icon': Icons.verified_user_rounded,
      'color': Color(0xFF2ECC71),
    },
    {
      'title': 'Отслеживание в реальном времени',
      'description': 'GPS-трекинг груза, уведомления о статусе и прямая связь с водителем.',
      'icon': Icons.location_on_rounded,
      'color': Color(0xFFE74C3C),
    },
    {
      'title': 'Быстрые платежи',
      'description': 'Получайте деньги за рейс в тот же день. Безопасные сделки и электронный документооборот.',
      'icon': Icons.payments_rounded,
      'color': Color(0xFFFF6B35),
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
  print('Онбординг завершён! Переходим к выбору роли...');
  if (context.mounted) {
    context.go('/role-selection');
  }
}

  void _skip() {
    _completeOnboarding();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A5F), Color(0xFF152A45)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Кнопка "Пропустить"
              _buildSkipButton(),

              // Слайды
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Индикатор точек
              _buildPageIndicator(),

              const SizedBox(height: 32),

              // Кнопка "Далее" / "Начать"
              _buildNextButton(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedOpacity(
          opacity: _currentPage < _pages.length - 1 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: TextButton(
            onPressed: _currentPage < _pages.length - 1 ? _skip : null,
            child: const Text(
              'Пропустить',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Иконка
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: (page['color'] as Color).withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: (page['color'] as Color).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              page['icon'] as IconData,
              size: 70,
              color: page['color'] as Color,
            ),
          ),

          const SizedBox(height: 48),

          // Заголовок
          Text(
            page['title'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Описание
          Text(
            page['description'] as String,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 16,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        bool isActive = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFF6B35) : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }

  Widget _buildNextButton() {
    bool isLastPage = _currentPage == _pages.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _nextPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLastPage ? 'Начать' : 'Далее',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              if (!isLastPage) ...[
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 20),
              ],
              if (isLastPage) ...[
                const SizedBox(width: 8),
                const Icon(Icons.rocket_launch_rounded, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}