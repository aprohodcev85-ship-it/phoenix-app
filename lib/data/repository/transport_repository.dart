import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transport_model.dart';

class TransportRepository {
  static const String _keyTransport = 'my_transport';

  // Демо-данные (имитация базы данных)
  final List<TransportModel> _demoTransport = [
    TransportModel(
      id: 'demo_1',
      city: 'Москва',
      bodyType: 'Тент',
      capacity: 20,
      volume: 82,
      ownerName: 'Алексей Смирнов',
      ownerPhone: '+7 (903) 111-22-33',
      ownerRating: 4.9,
      ownerDeals: 156,
      isVerified: true,
      availableFrom: DateTime.now(),
      createdAt: DateTime.now(),
    ),
    TransportModel(
      id: 'demo_2',
      city: 'Санкт-Петербург',
      bodyType: 'Рефрижератор',
      capacity: 15,
      volume: 60,
      ownerName: 'ООО "Холод-Транс"',
      ownerPhone: '+7 (912) 444-55-66',
      ownerRating: 4.7,
      ownerDeals: 89,
      isVerified: true,
      hasTemperatureControl: true,
      availableFrom: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now(),
    ),
    TransportModel(
      id: 'demo_3',
      city: 'Казань',
      bodyType: 'Тент',
      capacity: 10,
      volume: 45,
      ownerName: 'Марат Хасанов',
      ownerPhone: '+7 (917) 777-88-99',
      ownerRating: 4.5,
      ownerDeals: 42,
      isVerified: false,
      availableFrom: DateTime.now(),
      createdAt: DateTime.now(),
    ),
    TransportModel(
      id: 'demo_4',
      city: 'Екатеринбург',
      bodyType: 'Площадка',
      capacity: 25,
      volume: 0,
      ownerName: 'ИП Козлов В.А.',
      ownerPhone: '+7 (922) 333-44-55',
      ownerRating: 4.8,
      ownerDeals: 203,
      isVerified: true,
      availableFrom: DateTime.now().add(const Duration(days: 2)),
      createdAt: DateTime.now(),
    ),
    TransportModel(
      id: 'demo_5',
      city: 'Новосибирск',
      bodyType: 'Изотерм',
      capacity: 18,
      volume: 72,
      ownerName: 'Сергей Петров',
      ownerPhone: '+7 (913) 666-77-88',
      ownerRating: 4.6,
      ownerDeals: 67,
      isVerified: true,
      hasTemperatureControl: true,
      availableFrom: DateTime.now(),
      createdAt: DateTime.now(),
    ),
  ];

  // Получить все машины (демо + сохранённые)
  Future<List<TransportModel>> getAllTransport() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyTransport);

    List<TransportModel> savedTransport = [];
    if (stored != null && stored.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(stored);
      savedTransport = decoded.map((json) => TransportModel.fromJson(json)).toList();
    }

    // Объединяем демо + сохранённые
    return [..._demoTransport, ...savedTransport];
  }

  // Сохранить новую машину
  Future<void> saveTransport(TransportModel transport) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyTransport);

    List<TransportModel> existing = [];
    if (stored != null && stored.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(stored);
      existing = decoded.map((json) => TransportModel.fromJson(json)).toList();
    }

    existing.add(transport);
    await prefs.setString(_keyTransport, jsonEncode(existing.map((t) => t.toJson()).toList()));
  }
}