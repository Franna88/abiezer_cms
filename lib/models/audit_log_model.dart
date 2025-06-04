class AuditLogModel {
  final String id;
  final String action; // 'create', 'update', 'delete'
  final String userId;
  final String targetUserId;
  final String performedBy;
  final DateTime timestamp;
  final Map<String, dynamic> changes;

  AuditLogModel({
    required this.id,
    required this.action,
    required this.userId,
    required this.targetUserId,
    required this.performedBy,
    required this.timestamp,
    required this.changes,
  });

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'userId': userId,
      'targetUserId': targetUserId,
      'performedBy': performedBy,
      'timestamp': timestamp.toIso8601String(),
      'changes': changes,
    };
  }

  static AuditLogModel fromMap(Map<String, dynamic> map, String docId) {
    return AuditLogModel(
      id: docId,
      action: map['action'] ?? '',
      userId: map['userId'] ?? '',
      targetUserId: map['targetUserId'] ?? '',
      performedBy: map['performedBy'] ?? '',
      timestamp:
          DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      changes: Map<String, dynamic>.from(map['changes'] ?? {}),
    );
  }
}
