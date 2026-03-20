import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/models/transport_model.dart';
import '../data/repository/transport_repository.dart';

class TransportSearchScreen extends StatefulWidget {
  const TransportSearchScreen({super.key});

  @override
  State<TransportSearchScreen> createState() => _TransportSearchScreenState();
}

class _TransportSearchScreenState extends State<TransportSearchScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = true;
  bool _showFilters = false;

  List<TransportModel> _allTransport = [];
  String _selectedBodyType = '';
  double _minCapacity = 0;
  bool _onlyVerified = false;

  final List<String> _bodyTypes = [
    'Тент',
    'Рефрижератор',
    'Изотерм',
    'Площадка',
    'Цельнометалл',
    'Контейнер',
    'Цистерна',
  ];

  @override
  void initState() {
    super.initState();
    _loadTransport();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTransport() async {
    setState(() => _isLoading = true);
    final repository = TransportRepository();
    final transport = await repository.getAllTransport();

    if (mounted) {
      setState(() {
        _allTransport = transport;
        _isLoading = false;
      });
    }
  }

  List<TransportModel> get _filteredTransport {
    return _allTransport.where((t) {
      // Поиск по тексту
      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        final cityMatch = t.city.toLowerCase().contains(query);
        final bodyMatch = t.bodyType.toLowerCase().contains(query);
        final ownerMatch = t.ownerName.toLowerCase().contains(query);
        if (!cityMatch && !bodyMatch && !ownerMatch) return false;
      }

      // Фильтр по типу кузова
      if (_selectedBodyType.isNotEmpty && t.bodyType != _selectedBodyType) {
        return false;
      }

      // Фильтр по грузоподъёмности
      if (t.capacity < _minCapacity) {
        return false;
      }

      // Только верифицированные
      if (_onlyVerified && !t.isVerified) {
        return false;
      }

      return true;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedBodyType = '';
      _minCapacity = 0;
      _onlyVerified = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTransport;

    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Поиск транспорта', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
        ],
      ),
      body: Column(
        children: [
          // Поиск
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Город, тип кузова, перевозчик...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Фильтры
          if (_showFilters) _buildFiltersPanel(),

          // Результаты
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Найдено: ${filtered.length}',
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text('Сбросить', style: TextStyle(color: Color(0xFFFF6B35))),
                ),
              ],
            ),
          ),

          // Список
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : filtered.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return _buildTransportCard(filtered[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Тип кузова', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _bodyTypes.map((type) {
              final isSelected = _selectedBodyType == type;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                selectedColor: const Color(0xFFFF6B35),
                onSelected: (selected) {
                  setState(() {
                    _selectedBodyType = selected ? type : '';
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          Text(
            'Мин. грузоподъёмность: ${_minCapacity.toInt()} т',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Slider(
            value: _minCapacity,
            min: 0,
            max: 40,
            divisions: 40,
            activeColor: const Color(0xFFFF6B35),
            onChanged: (v) => setState(() => _minCapacity = v),
          ),

          const SizedBox(height: 8),
          SwitchListTile(
            value: _onlyVerified,
            onChanged: (v) => setState(() => _onlyVerified = v),
            title: const Text('Только верифицированные', style: TextStyle(color: Colors.white)),
            activeColor: const Color(0xFFFF6B35),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping_outlined, size: 64, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('Транспорт не найден', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('Попробуйте изменить фильтры', style: TextStyle(color: Colors.white54, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTransportCard(TransportModel transport) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Город и тип кузова
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Color(0xFF3498DB)),
                        const SizedBox(width: 4),
                        Text(
                          transport.city,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transport.bodyType,
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${transport.capacity.toInt()} т',
                    style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${transport.volume.toInt()} м³',
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Перевозчик
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, size: 16, color: Color(0xFFFF6B35)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transport.ownerName,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.yellow[700]),
                        const SizedBox(width: 4),
                        Text(
                          '${transport.ownerRating} (${transport.ownerDeals} сделок)',
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (transport.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, size: 12, color: Color(0xFF2ECC71)),
                      SizedBox(width: 4),
                      Text('Проверен', style: TextStyle(color: Color(0xFF2ECC71), fontSize: 11)),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Теги
          Row(
            children: [
              _buildTag(Icons.calendar_today, transport.availableFrom.toString().split(' ')[0]),
              const SizedBox(width: 8),
              if (transport.hasTemperatureControl)
                _buildTag(Icons.ac_unit, 'Рефрижератор'),
            ],
          ),

          const SizedBox(height: 12),

          // Кнопка
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Звонок: ${transport.ownerPhone}')),
                );
              },
              icon: const Icon(Icons.phone, size: 18),
              label: const Text('Связаться'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white.withOpacity(0.7)),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
        ],
      ),
    );
  }
}