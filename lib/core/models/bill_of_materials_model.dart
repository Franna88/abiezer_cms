import 'material_model.dart';

class BillOfMaterialsModel {
  final String id;
  final String projectId;
  final List<BomItemModel> items;
  final double totalCost;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  BillOfMaterialsModel({
    required this.id,
    required this.projectId,
    required this.items,
    required this.totalCost,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a BOM from JSON data
  factory BillOfMaterialsModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> itemsJson = json['items'] ?? [];

    return BillOfMaterialsModel(
      id: json['id'],
      projectId: json['projectId'],
      items: itemsJson.map((item) => BomItemModel.fromJson(item)).toList(),
      totalCost: json['totalCost']?.toDouble() ?? 0.0,
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert BOM to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalCost': totalCost,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of the BOM with updated fields
  BillOfMaterialsModel copyWith({
    String? id,
    String? projectId,
    List<BomItemModel>? items,
    double? totalCost,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BillOfMaterialsModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      items: items ?? this.items,
      totalCost: totalCost ?? this.totalCost,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Add an item to the BOM
  BillOfMaterialsModel addItem(BomItemModel item) {
    // Check if the material already exists in the BOM
    final existingItemIndex = items.indexWhere(
      (i) => i.material.id == item.material.id,
    );

    if (existingItemIndex != -1) {
      // Update the quantity if the material already exists
      final updatedItems = List<BomItemModel>.from(items);
      updatedItems[existingItemIndex] = updatedItems[existingItemIndex]
          .copyWith(
            quantity: updatedItems[existingItemIndex].quantity + item.quantity,
          );

      // Calculate new total cost
      final newTotalCost = updatedItems.fold(
        0.0,
        (sum, item) => sum + (item.quantity * item.material.unitPrice),
      );

      return copyWith(
        items: updatedItems,
        totalCost: newTotalCost,
        updatedAt: DateTime.now(),
      );
    } else {
      // Add the new material
      final updatedItems = List<BomItemModel>.from(items)..add(item);

      // Calculate new total cost
      final newTotalCost = updatedItems.fold(
        0.0,
        (sum, item) => sum + (item.quantity * item.material.unitPrice),
      );

      return copyWith(
        items: updatedItems,
        totalCost: newTotalCost,
        updatedAt: DateTime.now(),
      );
    }
  }

  // Remove an item from the BOM
  BillOfMaterialsModel removeItem(String materialId) {
    final updatedItems =
        items.where((item) => item.material.id != materialId).toList();

    // Calculate new total cost
    final newTotalCost = updatedItems.fold(
      0.0,
      (sum, item) => sum + (item.quantity * item.material.unitPrice),
    );

    return copyWith(
      items: updatedItems,
      totalCost: newTotalCost,
      updatedAt: DateTime.now(),
    );
  }

  // Update item quantity
  BillOfMaterialsModel updateItemQuantity(String materialId, double quantity) {
    if (quantity <= 0) {
      // If quantity is 0 or negative, remove the item
      return removeItem(materialId);
    }

    final updatedItems = List<BomItemModel>.from(items);
    final itemIndex = updatedItems.indexWhere(
      (item) => item.material.id == materialId,
    );

    if (itemIndex == -1) {
      // Item not found
      return this;
    }

    updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
      quantity: quantity,
    );

    // Calculate new total cost
    final newTotalCost = updatedItems.fold(
      0.0,
      (sum, item) => sum + (item.quantity * item.material.unitPrice),
    );

    return copyWith(
      items: updatedItems,
      totalCost: newTotalCost,
      updatedAt: DateTime.now(),
    );
  }

  // Get item count
  int get itemCount => items.length;

  // Check if the BOM is empty
  bool get isEmpty => items.isEmpty;

  // Get leftover materials after project completion
  List<MaterialModel> getLeftoverMaterials() {
    final leftoverMaterials = <MaterialModel>[];

    for (final item in items) {
      if (item.usedQuantity < item.quantity) {
        // There are leftover materials
        final material = item.material.markAsLeftover(projectId);
        leftoverMaterials.add(material);
      }
    }

    return leftoverMaterials;
  }
}

class BomItemModel {
  final String id;
  final MaterialModel material;
  final double quantity;
  final double usedQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  BomItemModel({
    required this.id,
    required this.material,
    required this.quantity,
    this.usedQuantity = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a BOM item from JSON data
  factory BomItemModel.fromJson(Map<String, dynamic> json) {
    return BomItemModel(
      id: json['id'],
      material: MaterialModel.fromJson(json['material']),
      quantity: json['quantity']?.toDouble() ?? 0.0,
      usedQuantity: json['usedQuantity']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert BOM item to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'material': material.toJson(),
      'quantity': quantity,
      'usedQuantity': usedQuantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of the BOM item with updated fields
  BomItemModel copyWith({
    String? id,
    MaterialModel? material,
    double? quantity,
    double? usedQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BomItemModel(
      id: id ?? this.id,
      material: material ?? this.material,
      quantity: quantity ?? this.quantity,
      usedQuantity: usedQuantity ?? this.usedQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get the remaining quantity
  double get remainingQuantity => quantity - usedQuantity;

  // Get the cost of this item
  double get cost => quantity * material.unitPrice;

  // Get the cost of used materials
  double get usedCost => usedQuantity * material.unitPrice;

  // Get the cost of remaining materials
  double get remainingCost => remainingQuantity * material.unitPrice;

  // Mark material as used
  BomItemModel markUsed(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Amount must be greater than zero');
    }

    if (amount > remainingQuantity) {
      throw ArgumentError('Amount cannot exceed remaining quantity');
    }

    return copyWith(
      usedQuantity: usedQuantity + amount,
      updatedAt: DateTime.now(),
    );
  }

  // Check if there's any remaining quantity
  bool get hasRemainingQuantity => remainingQuantity > 0;

  // Check if the material is leftover from another project
  bool get isLeftoverMaterial => material.isLeftover;
}
