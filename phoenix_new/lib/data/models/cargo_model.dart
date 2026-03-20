class CargoModel {
  final String id;
  final String fromCity;
  final String toCity;
  final double price;
  final double distance;
  final double weight;
  final double volume;
  final String bodyType;
  final DateTime loadingDate;
  final String? description;
  final String status; // 'active', 'completed', 'cancelled'
  final DateTime createdAt;

  const CargoModel({
    required this.id,
    required this.fromCity,
    required this.toCity,
    required this.price,
    required this.distance,
    required this.weight,
    required this.volume,
    required this.bodyType,
    required this.loadingDate,
    this.description,
    this.status = 'active',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'from_city': fromCity,
    'to_city': toCity,
    'price': price,
    'distance': distance,
    'weight': weight,
    'volume': volume,
    'body_type': bodyType,
    'loading_date': loadingDate.toIso8601String(),
    'description': description,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };

  factory CargoModel.fromJson(Map<String, dynamic> json) => CargoModel(
    id: json['id'],
    fromCity: json['from_city'],
    toCity: json['to_city'],
    price: (json['price'] as num).toDouble(),
    distance: (json['distance'] as num).toDouble(),
    weight: (json['weight'] as num).toDouble(),
    volume: (json['volume'] as num).toDouble(),
    bodyType: json['body_type'],
    loadingDate: DateTime.parse(json['loading_date']),
    description: json['description'],
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
  );

  CargoModel copyWith({
    String? id,
    String? fromCity,
    String? toCity,
    double? price,
    double? distance,
    double? weight,
    double? volume,
    String? bodyType,
    DateTime? loadingDate,
    String? description,
    String? status,
    DateTime? createdAt,
  }) => CargoModel(
    id: id ?? this.id,
    fromCity: fromCity ?? this.fromCity,
    toCity: toCity ?? this.toCity,
    price: price ?? this.price,
    distance: distance ?? this.distance,
    weight: weight ?? this.weight,
    volume: volume ?? this.volume,
    bodyType: bodyType ?? this.bodyType,
    loadingDate: loadingDate ?? this.loadingDate,
    description: description ?? this.description,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
}