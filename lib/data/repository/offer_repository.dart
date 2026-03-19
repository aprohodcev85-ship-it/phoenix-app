import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/offer_model.dart';

class OfferRepository {
  static const String _keyOffers = 'offers';

  // Сохранить отклик
  Future<void> saveOffer(OfferModel offer) async {
    final prefs = await SharedPreferences.getInstance();
    final offers = await _loadAll();
    offers.add(offer);
    await prefs.setString(_keyOffers, jsonEncode(offers.map((e) => e.toJson()).toList()));
  }

  // Получить отклики для конкретного груза
  Future<List<OfferModel>> getOffersForCargo(String cargoId) async {
    final offers = await _loadAll();
    return offers.where((e) => e.cargoId == cargoId).toList();
  }

  // Получить отклики конкретного перевозчика
  Future<List<OfferModel>> getOffersByCarrier(String carrierPhone) async {
    final offers = await _loadAll();
    return offers.where((e) => e.carrierPhone == carrierPhone).toList();
  }

  // Обновить статус отклика
  Future<void> updateStatus(String id, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final offers = await _loadAll();
    final index = offers.indexWhere((e) => e.id == id);
    
    if (index != -1) {
      final updated = OfferModel(
        id: offers[index].id,
        cargoId: offers[index].cargoId,
        carrierName: offers[index].carrierName,
        carrierPhone: offers[index].carrierPhone,
        price: offers[index].price,
        comment: offers[index].comment,
        status: status,
        createdAt: offers[index].createdAt,
      );
      offers[index] = updated;
      await prefs.setString(_keyOffers, jsonEncode(offers.map((e) => e.toJson()).toList()));
    }
  }

  // Вспомогательный метод
  Future<List<OfferModel>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyOffers);
    if (stored == null || stored.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(stored);
    return decoded.map((json) => OfferModel.fromJson(json)).toList();
  }
}