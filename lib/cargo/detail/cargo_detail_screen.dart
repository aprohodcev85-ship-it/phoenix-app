import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/offer_model.dart';
import '../../data/repository/offer_repository.dart';
import '../../notifications/notification_service.dart';

class CargoDetailScreen extends StatefulWidget {
  final int cargoId;
  const CargoDetailScreen({super.key, required this.cargoId});

  @override
  State<CargoDetailScreen> createState() => _CargoDetailScreenState();
}

class _CargoDetailScreenState extends State<CargoDetailScreen> {
  Map<String, dynamic>? _cargo;
  bool _isLoading = true;
  final String _userRole = 'carrier';

  final _offerPriceController = TextEditingController();
  final _offerCommentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCargoData();
  }

  @override
  void dispose() {
    _offerPriceController.dispose();
    _offerCommentController.dispose();
    super.dispose();
  }

  Future<void> _loadCargoData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _cargo = {
        'id': widget.cargoId.toString(),
        'title': 'Груз №${widget.cargoId}',
        'from': 'Москва',
        'to': 'Санкт-Петербург',
        'price': '120 000 ₽',
        'distance': '710 км',
        'weight': '20 т',
        'volume': '80 м³',
        'type': 'Тент',
        'loadingDate': '15 мая 2024',
        'description': 'Нужен надежный перевозчик. Погрузка боковая.',
        'ownerName': 'ООО "Стройматериалы"',
        'ownerPhone': '+7 (999) 123-45-67',
        'ownerRating': 4.8,
        'ownerDeals': 127,
        'isVerified': true,
      };
      _isLoading = false;
    });
  }

  void _showOfferDialog() {
    _offerPriceController.text = _cargo?['price']?.replaceAll(' ₽', '') ?? '';
    _offerCommentController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E3A5F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Предложить цену', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _offerPriceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Ваша цена',
                suffixText: '₽',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _offerCommentController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Комментарий',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: _submitOffer,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  void _submitOffer() async {
    final priceText = _offerPriceController.text.trim();
    final price = double.tryParse(priceText);

    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите корректную цену')),
      );
      return;
    }

    Navigator.pop(context);

    final offer = OfferModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cargoId: widget.cargoId.toString(),
      carrierName: 'Иван Иванов',
      carrierPhone: '+7 (900) 000-00-00',
      price: price,
      comment: _offerCommentController.text,
      createdAt: DateTime.now(),
    );

    final repository = OfferRepository();
    await repository.saveOffer(offer);

    // Уведомление
    // NotificationService.showLocalNotification(
      'Новый отклик',
      'Предложена цена ${price.toInt()} ₽ на груз №${widget.cargoId}',
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ваше предложение отправлено!'),
        backgroundColor: Color(0xFF2ECC71),
      ),
    );
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_cargo!['title'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
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
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    _chip(Icons.calendar_today, _cargo!['loadingDate']),
                    _chip(Icons.scale, _cargo!['weight']),
                    _chip(Icons.view_in_ar, _cargo!['volume']),
                    _chip(Icons.local_shipping, _cargo!['type']),
                  ]),
                  const SizedBox(height: 16),
                  const Text('Описание', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(_cargo!['description'], style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15, height: 1.6)),
                  const SizedBox(height: 24),
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
                        Container(width: 50, height: 50, decoration: const BoxDecoration(color: Color(0xFFFF6B35), shape: BoxShape.circle)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_cargo!['ownerName'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.star, size: 16, color: Colors.yellow[700]),
                                  const SizedBox(width: 4),
                                  Text('${_cargo!['ownerRating']} (${_cargo!['ownerDeals']} сделок)', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (_cargo!['isVerified'])
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFF2ECC71).withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
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
                  if (_userRole == 'carrier')
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _showOfferDialog,
                            icon: const Icon(Icons.price_change_outlined),
                            label: const Text('Цена'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B35),
                              minimumSize: const Size(0, 52),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/chat/cargo_${widget.cargoId}'),
                            icon: const Icon(Icons.chat_bubble_outline),
                            label: const Text('Чат'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3498DB),
                              minimumSize: const Size(0, 52),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.phone),
                            label: const Text('Звонок'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white38),
                              minimumSize: const Size(0, 52),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _chip(IconData icon, String text) {
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