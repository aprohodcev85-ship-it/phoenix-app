class TransportModel {
  final String id;
  final String city;
  final String bodyType;
  final double capacity;
  final double volume;
  final String ownerName;
  final String ownerPhone;
  final double ownerRating;
  final int ownerDeals;
  final bool isVerified;
  final bool hasTemperatureControl;
  final DateTime availableFrom;
  final String status;
  final DateTime createdAt;

  const TransportModel({
    required this.id,
    required this.city,
    required this.bodyType,
    required this.capacity,
    required this.volume,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerRating,
    required this.ownerDeals,
    required this.isVerified,
    this.hasTemperatureControl = false,
    required this.availableFrom,
    this.status = 'active',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'city': city,
    'body_type': bodyType,
    'capacity': capacity,
    'volume': volume,
    'owner_name': ownerName,
    'owner_phone': ownerPhone,
    'owner_rating': ownerRating,
    'owner_deals': ownerDeals,
    'is_verified': isVerified,
    'has_temperature_control': hasTemperatureControl,
    'available_from': availableFrom.toIso8601String(),
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };

  factory TransportModel.fromJson(Map<String, dynamic> json) => TransportModel(
    id: json['id'],
    city: json['city'],
    bodyType: json['body_type'],
    capacity: (json['capacity'] as num).toDouble(),
    volume: (json['volume'] as num).toDouble(),
    ownerName: json['owner_name'],
    ownerPhone: json['owner_phone'],
    ownerRating: (json['owner_rating'] as num).toDouble(),
    ownerDeals: json['owner_deals'],
    isVerified: json['is_verified'],
    hasTemperatureControl: json['has_temperature_control'] ?? false,
    availableFrom: DateTime.parse(json['available_from']),
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
  );
}