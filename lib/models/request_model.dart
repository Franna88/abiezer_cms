import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String id;
  final String type; // 'material', 'purchase', 'transfer', 'return'
  final String materialId;
  final String materialName;
  final double quantity;
  final String unit;
  final String projectId;
  final String requestedBy;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime timestamp;
  final String approvedBy;
  final DateTime? approvedAt;
  final String? reason;
  final String? photoUrl;
  final String? rejectionReason;

  RequestModel({
    required this.id,
    required this.type,
    required this.materialId,
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.projectId,
    required this.requestedBy,
    required this.status,
    required this.timestamp,
    required this.approvedBy,
    this.approvedAt,
    this.reason,
    this.photoUrl,
    this.rejectionReason,
  });

  // Create from Firestore document
  factory RequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return RequestModel(
      id: doc.id,
      type: data['type'] ?? '',
      materialId: data['materialId'] ?? '',
      materialName: data['materialName'] ?? '',
      quantity: (data['quantity'] ?? 0).toDouble(),
      unit: data['unit'] ?? '',
      projectId: data['projectId'] ?? '',
      requestedBy: data['requestedBy'] ?? '',
      status: data['status'] ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      approvedBy: data['approvedBy'] ?? '',
      approvedAt: (data['approvedAt'] as Timestamp?)?.toDate(),
      reason: data['reason'],
      photoUrl: data['photoUrl'],
      rejectionReason: data['rejectionReason'],
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'materialId': materialId,
      'materialName': materialName,
      'quantity': quantity,
      'unit': unit,
      'projectId': projectId,
      'requestedBy': requestedBy,
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
      'approvedBy': approvedBy,
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
      'reason': reason,
      'photoUrl': photoUrl,
      'rejectionReason': rejectionReason,
    };
  }

  // Create a copy with updated fields
  RequestModel copyWith({
    String? id,
    String? type,
    String? materialId,
    String? materialName,
    double? quantity,
    String? unit,
    String? projectId,
    String? requestedBy,
    String? status,
    DateTime? timestamp,
    String? approvedBy,
    DateTime? approvedAt,
    String? reason,
    String? photoUrl,
    String? rejectionReason,
  }) {
    return RequestModel(
      id: id ?? this.id,
      type: type ?? this.type,
      materialId: materialId ?? this.materialId,
      materialName: materialName ?? this.materialName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      projectId: projectId ?? this.projectId,
      requestedBy: requestedBy ?? this.requestedBy,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      reason: reason ?? this.reason,
      photoUrl: photoUrl ?? this.photoUrl,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
