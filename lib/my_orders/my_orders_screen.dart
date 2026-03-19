import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/models/cargo_model.dart';
import '../data/models/offer_model.dart';
import '../data/repository/cargo_repository.dart';
import '../data/repository/offer_repository.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  String _selectedTab = 'active';
  bool _isLoading = true;

  List<CargoModel> _cargos = [];
  Map<String, List<OfferModel>> _offersMap = {}; // cargoId -> offers

  final String _userRole = 'shipper'; // Для демо: shipper или carrier
  final String _carrierPhone = '+7 (900) 000-00-00';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final cargoRepo = CargoRepository();
    final offerRepo = OfferRepository();

    final cargos = await cargoRepo.getActiveCargos();
    final Map<String, List<OfferModel>> offersMap = {};

    if (_userRole == 'shipper') {
      // Грузовладелец: грузим отклики для каждого груза
      for (var cargo in cargos) {
        final offers = await offerRepo.getOffersForCargo(cargo.id);
        offersMap[cargo.id] = offers;
      }
    }

    if (mounted) {
      setState(() {
        _cargos = cargos;
        _offersMap = offersMap;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCargos = _cargos.where((c) => c.status == _selectedTab).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        title: Text(_userRole == 'shipper' ? 'Мои грузы' : 'Мои заявки', style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loadData),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF1E3A5F),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildTab('active', 'Активные'),
                const SizedBox(width: 12),
                _buildTab('completed', 'Завершённые'),
                const SizedBox(width: 12),
                _buildTab('cancelled', 'Отменённые'),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : filteredCargos.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredCargos.length,
                        itemBuilder: (context, index) {
                          final cargo = filteredCargos[index];
                          return _buildOrderCard(cargo);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tab, String label) {
    final isActive = _selectedTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = tab),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: isActive ? const Color(0xFFFF6B35) : Colors.white70, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400)),
            const SizedBox(height: 8),
            if (isActive) Container(height: 3, width: 40, color: const Color(0xFFFF6B35)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(CargoModel cargo) {
    final offers = _offersMap[cargo.id] ?? [];
    final pendingOffers = offers.where((o) => o.status == 'pending').length;

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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${cargo.fromCity} → ${cargo.toCity}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(cargo.loadingDate.toString().split(' ')[0], style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${cargo.price.toInt()} ₽', style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 18, fontWeight: FontWeight.w700)),
                  Text('${cargo.distance.toInt()} км', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _tag(Icons.scale, '${cargo.weight} т'),
              const SizedBox(width: 8),
              _tag(Icons.local_shipping, cargo.bodyType),
              const Spacer(),
              _statusBadge(cargo.status),
            ],
          ),

          // Блок откликов для грузовладельца
          if (_userRole == 'shipper' && offers.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Отклики: ${offers.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      if (pendingOffers > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFFF6B35), borderRadius: BorderRadius.circular(8)),
                          child: Text('$pendingOffers новых', style: const TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...offers.take(2).map((offer) => _buildOfferRow(offer, cargo)),
                  if (offers.length > 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('и ещё ${offers.length - 2}...', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final repo = CargoRepository();
                    await repo.updateStatus(cargo.id, 'completed');
                    if (mounted) _loadData();
                  },
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white30)),
                  child: const Text('Завершить'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final repo = CargoRepository();
                    await repo.updateStatus(cargo.id, 'cancelled');
                    if (mounted) _loadData();
                  },
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white30)),
                  child: const Text('Отменить'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfferRow(OfferModel offer, CargoModel cargo) {
    final isPending = offer.status == 'pending';
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.carrierName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                Text('${offer.price.toInt()} ₽', style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 13)),
              ],
            ),
          ),
          if (isPending)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Color(0xFF2ECC71), size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _acceptOffer(offer, cargo),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFFE74C3C), size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _rejectOffer(offer),
                ),
              ],
            )
          else
            Text(offer.status == 'accepted' ? 'Принят' : 'Отклонён',
                style: TextStyle(color: offer.status == 'accepted' ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C), fontSize: 11)),
        ],
      ),
    );
  }

  void _acceptOffer(OfferModel offer, CargoModel cargo) async {
    final repo = OfferRepository();
    await repo.updateStatus(offer.id, 'accepted');
    // Можно также обновить статус груза
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Отклик от ${offer.carrierName} принят!')));
      _loadData();
    }
  }

  void _rejectOffer(OfferModel offer) async {
    final repo = OfferRepository();
    await repo.updateStatus(offer.id, 'rejected');
    if (mounted) _loadData();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text('Нет ${_selectedTab == 'active' ? 'активных заявок' : 'заявок'}', style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _tag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 12, color: Colors.white70), const SizedBox(width: 4), Text(text, style: const TextStyle(color: Colors.white70, fontSize: 11))]),
    );
  }

  Widget _statusBadge(String status) {
    final color = status == 'active' ? Colors.green : status == 'completed' ? Colors.grey : Colors.red;
    final label = status == 'active' ? 'Активен' : status == 'completed' ? 'Завершён' : 'Отменён';
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(6)), child: Text(label, style: TextStyle(color: color, fontSize: 11)));
  }
}