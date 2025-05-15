class PurchaseModel {
  final String id;
  final String projectId;
  final String materialId;
  final String supplierName;
  final double quantity;
  final double unitPrice;
  final double totalPrice;
  final String paymentMethod; // Card, Account, Cash
  final String? receiptImageUrl;
  final String status; // pending, approved, rejected
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  PurchaseModel({
    required this.id,
    required this.projectId,
    required this.materialId,
    required this.supplierName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.paymentMethod,
    this.receiptImageUrl,
    required this.status,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a purchase from JSON data
  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'],
      projectId: json['projectId'],
      materialId: json['materialId'],
      supplierName: json['supplierName'],
      quantity: json['quantity'].toDouble(),
      unitPrice: json['unitPrice'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
      paymentMethod: json['paymentMethod'],
      receiptImageUrl: json['receiptImageUrl'],
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

  // Convert purchase to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'materialId': materialId,
      'supplierName': supplierName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'receiptImageUrl': receiptImageUrl,
      'status': status,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of the purchase with updated fields
  PurchaseModel copyWith({
    String? id,
    String? projectId,
    String? materialId,
    String? supplierName,
    double? quantity,
    double? unitPrice,
    double? totalPrice,
    String? paymentMethod,
    String? receiptImageUrl,
    String? status,
    String? approvedBy,
    DateTime? approvedAt,
    String? rejectionReason,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PurchaseModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      materialId: materialId ?? this.materialId,
      supplierName: supplierName ?? this.supplierName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Check if purchase is pending approval
  bool get isPending => status == 'pending';

  // Check if purchase is approved
  bool get isApproved => status == 'approved';

  // Check if purchase is rejected
  bool get isRejected => status == 'rejected';

  // Check if receipt image is required based on payment method
  bool get isReceiptRequired =>
      paymentMethod == 'Card' || paymentMethod == 'Cash';

  // Check if delivery note is required based on payment method
  bool get isDeliveryNoteRequired => paymentMethod == 'Account';

  // Check if purchase has valid proof attached
  bool get hasValidProof {
    if (isReceiptRequired || isDeliveryNoteRequired) {
      return receiptImageUrl != null && receiptImageUrl!.isNotEmpty;
    }
    return true;
  }
}
