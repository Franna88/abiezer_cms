import 'package:cloud_firestore/cloud_firestore.dart';

class BillOfMaterials {
  final String projectId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String status;
  final List<BomMaterial> materials;

  BillOfMaterials({
    required this.projectId,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.status,
    required this.materials,
  });

  factory BillOfMaterials.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BillOfMaterials(
      projectId: data['projectId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
      status: data['status'] ?? 'active',
      materials: (data['materials'] as List<dynamic>?)
              ?.map((material) => BomMaterial.fromMap(material))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'status': status,
      'materials': materials.map((material) => material.toMap()).toList(),
    };
  }
}

class BomMaterial {
  final String materialId;
  final String name;
  final double quantity;
  final String unit;
  final double currentStock;
  final double initialQuantity;
  final double unitPrice;
  final double totalCost;

  BomMaterial({
    required this.materialId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.currentStock,
    required this.initialQuantity,
    required this.unitPrice,
    required this.totalCost,
  });

  factory BomMaterial.fromMap(Map<String, dynamic> map) {
    return BomMaterial(
      materialId: map['materialId'] ?? '',
      name: map['name'] ?? '',
      quantity: (map['quantity'] ?? 0.0).toDouble(),
      unit: map['unit'] ?? '',
      currentStock: (map['currentStock'] ?? 0.0).toDouble(),
      initialQuantity: (map['initialQuantity'] ?? 0.0).toDouble(),
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      totalCost: (map['totalCost'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'materialId': materialId,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'currentStock': currentStock,
      'initialQuantity': initialQuantity,
      'unitPrice': unitPrice,
      'totalCost': totalCost,
    };
  }
}
