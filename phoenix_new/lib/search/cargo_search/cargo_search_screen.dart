import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/cargo_model.dart';
import '../../data/repository/cargo_repository.dart';

class CargoSearchScreen extends StatefulWidget {
  const CargoSearchScreen({super.key});

  @override
  State<CargoSearchScreen> createState() => _CargoSearchScreenState();
}

class _CargoSearchScreenState extends State<CargoSearchScreen> {
  String _searchQuery = '';
  List<CargoModel> _allCargos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCargos();
  }

  Future<void> _loadCargos() async {
    setState(() => _isLoading = true);
    final repository = CargoRepository();
    // Загружаем только активные грузы (и свои, и чужие)
    final cargos = await repository.getActiveCargos();
    
    if (mounted) {
      setState(() {
        _allCargos = cargos;
        _isLoading = false;
      });
    }
  }

  List<CargoModel> get _filteredCargos {
    if (_searchQuery.isEmpty) {
      return _allCargos;
    }
    
    final query = _searchQuery.toLowerCase();
    return _allCargos.where((cargo) {
      final from = cargo.fromCity.toLowerCase();
      final to = cargo.toCity.toLowerCase();
      final body = cargo.bodyType.toLowerCase();
      
      return from.contains(query) || 
             to.contains(query) || 
             body.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        title: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Поиск по маршруту, городу, типу кузова...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white54),
            suffixIcon: Icon(Icons.clear, color: Colors.white54),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _filteredCargos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_outlined,
                        size: 64,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchQuery.isEmpty 
                            ? 'Активных грузов пока нет' 
                            : 'Ничего не найдено',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      if (_searchQuery.isEmpty) ...[
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/add-cargo'),
                          icon: const Icon(Icons.add),
                          label: const Text('Добавить первый груз'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredCargos.length,
                  itemBuilder: (context, index) {
                    final cargo = _filteredCargos[index];
                    return _buildCargoCard(cargo);
                  },
                ),
    );
  }

  Widget _buildCargoCard(CargoModel cargo) {
    return GestureDetector(
      onTap: () => context.push('/cargo/${cargo.id}'),
      child: Container(
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
            // Маршрут
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16, color: Colors.white.withOpacity(0.6)),
                          const SizedBox(width: 4),
                          Text(
                            '${cargo.fromCity} → ${cargo.toCity}',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cargo.loadingDate.toString().split(' ')[0],
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${cargo.price.toInt()} ₽',
                      style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${cargo.distance.toInt()} км',
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Теги
            Row(
              children: [
                _buildTag(Icons.scale, '${cargo.weight} т'),
                const SizedBox(width: 8),
                _buildTag(Icons.view_in_ar, '${cargo.volume} м³'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Активен',
                    style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
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