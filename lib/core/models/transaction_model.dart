class TransactionModel {
  final String id;
  final String projectId;
  final String materialId;
  final String transactionType; // usage, transfer, return
  final double quantity;
  final String? toProjectId; // For transfers
  final String? reason;
  final String? proofImageUrl;
  final String status; // pending, approved, rejected
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.projectId,
    required this.materialId,
    required this.transactionType,
    required this.quantity,
    this.toProjectId,
    this.reason,
    this.proofImageUrl,
    required this.status,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a transaction from JSON data
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      projectId: json['projectId'],
      materialId: json['materialId'],
      transactionType: json['transactionType'],
      quantity: json['quantity'].toDouble(),
      toProjectId: json['toProjectId'],
      reason: json['reason'],
      proofImageUrl: json['proofImageUrl'],
      status: json['status'],
      approvedBy: json['approvedBy'],
      approvedAt:
          json['approvedAt'] != null
              ? DateTime.parse(json['approvedAt'])
              : null,
      rejectionReason: json['rejectionReason'],
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert transaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'materialId': materialId,
      'transactionType': transactionType,
      'quantity': quantity,
      'toProjectId': toProjectId,
      'reason': reason,
      'proofImageUrl': proofImageUrl,
      'status': status,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of the transaction with updated fields
  TransactionModel copyWith({
    String? id,
    String? projectId,
    String? materialId,
    String? transactionType,
    double? quantity,
    String? toProjectId,
    String? reason,
    String? proofImageUrl,
    String? status,
    String? approvedBy,
    DateTime? approvedAt,
    String? rejectionReason,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      materialId: materialId ?? this.materialId,
      transactionType: transactionType ?? this.transactionType,
      quantity: quantity ?? this.quantity,
      toProjectId: toProjectId ?? this.toProjectId,
      reason: reason ?? this.reason,
      proofImageUrl: proofImageUrl ?? this.proofImageUrl,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Check if transaction is pending approval
  bool get isPending => status == 'pending';

  // Check if transaction is approved
  bool get isApproved => status == 'approved';

  // Check if transaction is rejected
  bool get isRejected => status == 'rejected';

  // Check if transaction is a usage
  bool get isUsage => transactionType == 'usage';

  // Check if transaction is a transfer
  bool get isTransfer => transactionType == 'transfer';

  // Check if transaction is a return
  bool get isReturn => transactionType == 'return';

  // Check if transaction requires proof image
  bool get isProofRequired => isTransfer || isReturn;

  // Check if transaction has valid proof attached when required
  bool get hasValidProof {
    if (isProofRequired) {
      return proofImageUrl != null && proofImageUrl!.isNotEmpty;
    }
    return true;
  }
}
