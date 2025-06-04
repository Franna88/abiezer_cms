import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialHistoryModel {
  final String id;
  final String materialId;
  final String projectId;
  final String projectName;
  final double quantity;
  final DateTime date;
  final String userId;
  final String action; // 'used', 'added', 'transferred', 'returned'

  MaterialHistoryModel({
    required this.id,
    required this.materialId,
    required this.projectId,
    required this.projectName,
    required this.quantity,
    required this.date,
    required this.userId,
    required this.action,
  });

  factory MaterialHistoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MaterialHistoryModel(
      id: doc.id,
      materialId: data['materialId'] ?? '',
      projectId: data['projectId'] ?? '',
      projectName: data['projectName'] ?? '',
      quantity: (data['quantity'] ?? 0.0).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
      action: data['action'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'materialId': materialId,
      'projectId': projectId,
      'projectName': projectName,
      'quantity': quantity,
      'date': Timestamp.fromDate(date),
      'userId': userId,
      'action': action,
    };
  }
}
