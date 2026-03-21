import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cargo_model.dart';

class CargoRepository {
  // Получаем доступ к коллекции 'cargos' в облаке
  final CollectionReference _cargoCollection =
      FirebaseFirestore.instance.collection('cargos');

  // Сохранение груза в облако
  Future<void> saveCargo(CargoModel cargo) async {
    try {
      await _cargoCollection.doc(cargo.id).set(cargo.toJson());
    } catch (e) {
      throw Exception("Ошибка сохранения в облако: $e");
    }
  }

  // Получение всех активных грузов (от всех пользователей!)
  Future<List<CargoModel>> getActiveCargos() async {
    try {
      final snapshot =
          await _cargoCollection.where('status', isEqualTo: 'active').get();

      return snapshot.docs
          .map((doc) => CargoModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Ошибка загрузки из облака: $e");
      return [];
    }
  }

  // Обновление статуса груза (например, когда заказ завершен)
  Future<void> updateStatus(String id, String newStatus) async {
    await _cargoCollection.doc(id).update({'status': newStatus});
  }
}
