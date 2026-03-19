class OfferModel {
  final String id;
  final String cargoId;
  final String carrierName;
  final String carrierPhone;
  final double price;
  final String comment;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime createdAt;

  const OfferModel({
    required this.id,
    required this.cargoId,
    required this.carrierName,
    required this.carrierPhone,
    required this.price,
    required this.comment,
    this.status = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'cargo_id': cargoId,
    'carrier_name': carrierName,
    'carrier_phone': carrierPhone,
    'price': price,
    'comment': comment,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
    id: json['id'],
    cargoId: json['cargo_id'],
    carrierName: json['carrier_name'],
    carrierPhone: json['carrier_phone'],
    price: (json['price'] as num).toDouble(),
    comment: json['comment'],
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
  );
}