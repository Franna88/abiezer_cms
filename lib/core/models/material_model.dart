class MaterialModel {
  final String id;
  final String name;
  final String category;
  final String unitOfMeasure;
  final double unitPrice;
  final String? description;
  final String? imageUrl;
  final bool isActive;
  final String status; // 'new' or 'leftover'
  final String?
  sourceProjectId; // Only for leftover materials - the project it came from
  final DateTime createdAt;
  final DateTime updatedAt;

  MaterialModel({
    required this.id,
    required this.name,
    required this.category,
    required this.unitOfMeasure,
    required this.unitPrice,
    this.description,
    this.imageUrl,
    required this.isActive,
    required this.status,
    this.sourceProjectId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a material from JSON data
  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      unitOfMeasure: json['unitOfMeasure'],
      unitPrice: json['unitPrice'].toDouble(),
      description: json['description'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? true,
      status: json['status'] ?? 'new',
      sourceProjectId: json['sourceProjectId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert material to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'unitOfMeasure': unitOfMeasure,
      'unitPrice': unitPrice,
      'description': description,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'status': status,
      'sourceProjectId': sourceProjectId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of the material with updated fields
  MaterialModel copyWith({
    String? id,
    String? name,
    String? category,
    String? unitOfMeasure,
    double? unitPrice,
    String? description,
    String? imageUrl,
    bool? isActive,
    String? status,
    String? sourceProjectId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      unitPrice: unitPrice ?? this.unitPrice,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      sourceProjectId: sourceProjectId ?? this.sourceProjectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Check if material is leftover from another project
  bool get isLeftover => status == 'leftover';

  // Create a new material that's marked as leftover from a completed project
  MaterialModel markAsLeftover(String projectId) {
    return copyWith(
      status: 'leftover',
      sourceProjectId: projectId,
      updatedAt: DateTime.now(),
    );
  }
}

// Model for materials in a specific project's bill of materials
class ProjectMaterialModel {
  final String id;
  final String projectId;
  final String materialId;
  final MaterialModel material;
  final double totalQuantity;
  final double usedQuantity;
  final double remainingQuantity;
  final bool isLowStock;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectMaterialModel({
    required this.id,
    required this.projectId,
    required this.materialId,
    required this.material,
    required this.totalQuantity,
    required this.usedQuantity,
    required this.remainingQuantity,
    required this.isLowStock,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a project material from JSON data
  factory ProjectMaterialModel.fromJson(Map<String, dynamic> json) {
    return ProjectMaterialModel(
      id: json['id'],
      projectId: json['projectId'],
      materialId: json['materialId'],
      material: MaterialModel.fromJson(json['material']),
      totalQuantity: json['totalQuantity'].toDouble(),
      usedQuantity: json['usedQuantity'].toDouble(),
      remainingQuantity: json['remainingQuantity'].toDouble(),
      isLowStock: json['isLowStock'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert project material to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'materialId': materialId,
      'material': material.toJson(),
      'totalQuantity': totalQuantity,
      'usedQuantity': usedQuantity,
      'remainingQuantity': remainingQuantity,
      'isLowStock': isLowStock,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of the project material with updated fields
  ProjectMaterialModel copyWith({
    String? id,
    String? projectId,
    String? materialId,
    MaterialModel? material,
    double? totalQuantity,
    double? usedQuantity,
    double? remainingQuantity,
    bool? isLowStock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectMaterialModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      materialId: materialId ?? this.materialId,
      material: material ?? this.material,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      usedQuantity: usedQuantity ?? this.usedQuantity,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
      isLowStock: isLowStock ?? this.isLowStock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Check if the material is out of stock
  bool get isOutOfStock => remainingQuantity <= 0;

  // Calculate the percentage of material used
  double get percentageUsed {
    return totalQuantity > 0 ? (usedQuantity / totalQuantity) * 100 : 0;
  }

  // Calculate the percentage of material remaining
  double get percentageRemaining {
    return totalQuantity > 0 ? (remainingQuantity / totalQuantity) * 100 : 0;
  }

  // Calculate the total cost of this material
  double get totalCost {
    return totalQuantity * material.unitPrice;
  }

  // Calculate the cost of used material
  double get usedCost {
    return usedQuantity * material.unitPrice;
  }

  // Calculate the cost of remaining material
  double get remainingCost {
    return remainingQuantity * material.unitPrice;
  }

  // Mark additional material as used
  ProjectMaterialModel markUsed(double quantity) {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than zero');
    }

    if (quantity > remainingQuantity) {
      throw ArgumentError('Used quantity cannot exceed remaining quantity');
    }

    return copyWith(
      usedQuantity: usedQuantity + quantity,
      remainingQuantity: remainingQuantity - quantity,
      updatedAt: DateTime.now(),
    );
  }
}
