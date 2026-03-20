import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CargoDetailScreen extends StatefulWidget {
  final int cargoId;
  const CargoDetailScreen({super.key, required this.cargoId});

  @override
  State<CargoDetailScreen> createState() => _CargoDetailScreenState();
}

class _CargoDetailScreenState extends State<CargoDetailScreen> {
  // Модель данных для груза (в реальном приложении будет загружаться с сервера)
  Map<String, dynamic>? _cargo;

  @override
  void initState() {
    super.initState();
    _loadCargoData();
  }

  // Имитация загрузки данных
  Future<void> _loadCargoData() async {
    // Симулируем задержку сети
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _cargo = {
        'id': widget.cargoId,
        'title': 'Груз №${widget.cargoId}',
        'from': 'Москва',
        'to': 'Санкт-Петербург',
        'price': '120 000 ₽',
        'distance': '710 км',
        'weight': '20 т',
        'volume': '80 м³',
        'type': 'Тент',
        'loadingDate': '15 мая 2024',
        'deliveryDate': '18 мая 2024',
        'description': 'Нужен надежный перевозчик для доставки строительных материалов. Требуется тентованный полуприцеп. Погрузка/разгрузка с боковой стороны.',
        'ownerName': 'ООО "Стройматериалы"',
        'ownerPhone': '+7 (999) 123-45-67',
        'ownerRating': 4.8,
        'ownerDeals': 127,
        'isVerified': true,
        'photos': [
          'https://via.placeholder.com/300x200?text=Фото+1',
          'https://via.placeholder.com/300x200?text=Фото+2',
          'https://via.placeholder.com/300x200?text=Фото+3',
        ],
        'status': 'active', // new, active, in_progress, completed, cancelled
      };
      
      // Для разных ID делаем разные данные
      if (widget.cargoId == 2) {
        _cargo = {
          ..._cargo!,
          'from': 'Казань',
          'to': 'Екатеринбург',
          'price': '85 000 ₽',
          'weight': '15 т',
          'volume': '60 м³',
          'type': 'Рефрижератор',
          'description': 'Перевозка продуктов питания. Температурный режим +2°C. Требуется рефрижератор.',
          'ownerName': 'ООО "Продукты"',
          'ownerRating': 4.9,
          'ownerDeals': 89,
        };
      } else if (widget.cargoId == 3) {
        _cargo = {
          ..._cargo!,
          'from': 'Новосибирск',
          'to': 'Красноярск',
          'price': '45 000 ₽',
          'weight': '8 т',
          'volume': '35 м³',
          'type': 'Фура',
          'description': 'Доставка бытовой техники. Требуется фура с полной растентовкой.',
          'ownerName': 'ИП Петров А.В.',
          'ownerRating': 4.6,
          'ownerDeals': 54,
        };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Детали груза', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _cargo == null
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Фотографии груза
                  if (_cargo!['photos'] != null && (_cargo!['photos'] as List).isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        itemCount: (_cargo!['photos'] as List).length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            (_cargo!['photos'] as List)[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),

                  // Основная информация
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Название груза
                        Text(
                          _cargo!['title'],
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),

                        // Маршрут
                        Row(
                          children: [
                            Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF3498DB), shape: BoxShape.circle)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_cargo!['from'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8),
                                  Text(_cargo!['to'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(_cargo!['price'], style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 20, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Text(_cargo!['distance'], style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Характеристики
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildInfoChip(Icons.calendar_today, _cargo!['loadingDate']),
                            _buildInfoChip(Icons.scale, _cargo!['weight']),
                            _buildInfoChip(Icons.view_in_ar, _cargo!['volume']),
                            _buildInfoChip(Icons.local_shipping, _cargo!['type']),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Описание
                        const Text('Описание', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(
                          _cargo!['description'],
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15, height: 1.6),
                        ),
                        const SizedBox(height: 24),

                        // Информация о грузовладельце
                        const Text('Грузовладелец', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF6B35),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.person, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _cargo!['ownerName'],
                                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.star, size: 16, color: Colors.yellow[700]),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${_cargo!['ownerRating']} (${_cargo!['ownerDeals']} сделок)',
                                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (_cargo!['isVerified'])
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2ECC71).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.verified, size: 14, color: Color(0xFF2ECC71)),
                                      SizedBox(width: 4),
                                      Text('Проверен', style: TextStyle(color: Color(0xFF2ECC71), fontSize: 12)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Кнопки действий
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Позвонить грузовладельцу
                                  print('Звонок на ${_cargo!['ownerPhone']}');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6B35),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 52),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.phone, size: 20),
                                    const SizedBox(width: 8),
                                    const Text('Позвонить'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // Предложить цену
                                  print('Предложить цену на груз ${_cargo!['id']}');
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white),
                                  minimumSize: const Size(double.infinity, 52),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Предложить цену'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white.withOpacity(0.7)),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
        ],
      ),
    );
  }
}