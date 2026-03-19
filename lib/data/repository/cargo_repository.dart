import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cargo_model.dart';

class CargoRepository {
  static const String _keyCargos = 'my_cargos';
  
  // Сохранение груза
  Future<void> saveCargo(CargoModel cargo) async {
    final prefs = await SharedPreferences.getInstance();
    final cargos = await _loadAllCargos();
    
    cargos.add(cargo);
    await prefs.setString(_keyCargos, jsonEncode(cargos.map((c) => c.toJson()).toList()));
  }
  
  // Загрузка всех грузов
  Future<List<CargoModel>> loadCargos(String statusFilter) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyCargos);
    
    if (stored == null || stored.isEmpty) {
      return [];
    }
    
    final List<dynamic> decoded = jsonDecode(stored);
    final cargos = decoded.map((json) => CargoModel.fromJson(json)).toList();
    
    // Фильтрация по статусу
    if (statusFilter.isNotEmpty && statusFilter != 'all') {
      return cargos.where((c) => c.status == statusFilter).toList();
    }
    
    return cargos;
  }
  
  // Получить все грузы без фильтра
  Future<List<CargoModel>> getAllCargos() async {
    return await loadCargos('');
  }
  
  // Загрузить только active грузы
  Future<List<CargoModel>> getActiveCargos() async {
    return await loadCargos('active');
  }
  
  // Загрузить только completed грузы
  Future<List<CargoModel>> getCompletedCargos() async {
    return await loadCargos('completed');
  }
  
  // Удалить груз
  Future<void> deleteCargo(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final cargos = await getAllCargos();
    
    final filtered = cargos.where((c) => c.id != id).toList();
    await prefs.setString(_keyCargos, jsonEncode(filtered.map((c) => c.toJson()).toList()));
  }
  
  // Обновить статус груза
  Future<void> updateStatus(String id, String newStatus) async {
    final cargos = await getAllCargos();
    final cargoIndex = cargos.indexWhere((c) => c.id == id);
    
    if (cargoIndex != -1) {
      final updated = cargos[cargoIndex].copyWith(status: newStatus);
      cargos[cargoIndex] = updated;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyCargos, jsonEncode(cargos.map((c) => c.toJson()).toList()));
    }
  }
  
  // Загрузить все сохранённые cargoes (внутренний метод)
  Future<List<CargoModel>> _loadAllCargos() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyCargos);
    
    if (stored == null || stored.isEmpty) {
      return [];
    }
    
    final List<dynamic> decoded = jsonDecode(stored);
    return decoded.map((json) => CargoModel.fromJson(json)).toList();
  }
}