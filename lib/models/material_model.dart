import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialModel {
  final String id;
  final String name;
  final String category;
  final String unit;
  final double cost;
  final String supplier;
  final double initialStock;
  final DateTime createdAt;
  final DateTime updatedAt;

  MaterialModel({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.cost,
    required this.supplier,
    required this.initialStock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MaterialModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MaterialModel(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      unit: data['unit'] ?? '',
      cost: (data['cost'] ?? 0.0).toDouble(),
      supplier: data['supplier'] ?? '',
      initialStock: (data['initialStock'] ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'unit': unit,
      'cost': cost,
      'supplier': supplier,
      'initialStock': initialStock,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  MaterialModel copyWith({
    String? id,
    String? name,
    String? category,
    String? unit,
    double? cost,
    String? supplier,
    double? initialStock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      cost: cost ?? this.cost,
      supplier: supplier ?? this.supplier,
      initialStock: initialStock ?? this.initialStock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
