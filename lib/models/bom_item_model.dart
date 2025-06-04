import 'package:cloud_firestore/cloud_firestore.dart';

class BoMItemModel {
  final String id;
  final String name;
  final String category;
  final String unit;
  final int total;
  final int used;
  final int remaining;
  final int lowStockThreshold;
  final DateTime lastUpdated;

  BoMItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.total,
    required this.used,
    required this.remaining,
    required this.lowStockThreshold,
    required this.lastUpdated,
  });

  factory BoMItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BoMItemModel(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      unit: data['unit'] ?? '',
      total: data['total'] ?? 0,
      used: data['used'] ?? 0,
      remaining: data['total'] - (data['used'] ?? 0),
      lowStockThreshold: data['lowStockThreshold'] ?? 10,
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'unit': unit,
      'total': total,
      'used': used,
      'lowStockThreshold': lowStockThreshold,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}
