import 'package:cloud_firestore/cloud_firestore.dart';

enum MovementType {
  add,
  remove,
  use,
}

class MaterialMovement {
  final String movementId;
  final String projectId;
  final String materialId;
  final DateTime timestamp;
  final MovementType actionType;
  final double quantity;
  final double previousQuantity;
  final double newQuantity;
  final String performedBy;
  final String performedByRole;
  final String notes;
  final String? location;
  final String? reference;

  MaterialMovement({
    required this.movementId,
    required this.projectId,
    required this.materialId,
    required this.timestamp,
    required this.actionType,
    required this.quantity,
    required this.previousQuantity,
    required this.newQuantity,
    required this.performedBy,
    required this.performedByRole,
    required this.notes,
    this.location,
    this.reference,
  });

  factory MaterialMovement.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MaterialMovement(
      movementId: doc.id,
      projectId: data['projectId'] ?? '',
      materialId: data['materialId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      actionType: MovementType.values.firstWhere(
        (e) => e.toString() == 'MovementType.${data['actionType']}',
        orElse: () => MovementType.use,
      ),
      quantity: (data['quantity'] ?? 0.0).toDouble(),
      previousQuantity: (data['previousQuantity'] ?? 0.0).toDouble(),
      newQuantity: (data['newQuantity'] ?? 0.0).toDouble(),
      performedBy: data['performedBy'] ?? '',
      performedByRole: data['performedByRole'] ?? '',
      notes: data['notes'] ?? '',
      location: data['location'],
      reference: data['reference'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'materialId': materialId,
      'timestamp': Timestamp.fromDate(timestamp),
      'actionType': actionType.toString().split('.').last,
      'quantity': quantity,
      'previousQuantity': previousQuantity,
      'newQuantity': newQuantity,
      'performedBy': performedBy,
      'performedByRole': performedByRole,
      'notes': notes,
      'location': location,
      'reference': reference,
    };
  }
}
