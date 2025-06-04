import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectBoMModel {
  final String id;
  final String projectId;
  final String materialId;
  final double totalQuantity;
  final double usedQuantity;
  final double threshold;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectBoMModel({
    required this.id,
    required this.projectId,
    required this.materialId,
    required this.totalQuantity,
    required this.usedQuantity,
    required this.threshold,
    required this.createdAt,
    required this.updatedAt,
  });

  double get remainingQuantity => totalQuantity - usedQuantity;
  bool get isLowStock => remainingQuantity <= threshold;

  factory ProjectBoMModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProjectBoMModel(
      id: doc.id,
      projectId: data['projectId'] ?? '',
      materialId: data['materialId'] ?? '',
      totalQuantity: (data['totalQuantity'] ?? 0.0).toDouble(),
      usedQuantity: (data['usedQuantity'] ?? 0.0).toDouble(),
      threshold: (data['threshold'] ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'projectId': projectId,
      'materialId': materialId,
      'totalQuantity': totalQuantity,
      'usedQuantity': usedQuantity,
      'threshold': threshold,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ProjectBoMModel copyWith({
    double? totalQuantity,
    double? usedQuantity,
    double? threshold,
  }) {
    return ProjectBoMModel(
      id: id,
      projectId: projectId,
      materialId: materialId,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      usedQuantity: usedQuantity ?? this.usedQuantity,
      threshold: threshold ?? this.threshold,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
