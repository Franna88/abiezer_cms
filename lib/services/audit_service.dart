import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/audit_log_model.dart';
import '../models/user_model.dart';

class AuditService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get audit logs stream
  Stream<List<AuditLogModel>> getAuditLogs() {
    return _firestore
        .collection('audit_logs')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AuditLogModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Log user creation
  Future<void> logUserCreation(UserModel user, String performedBy) async {
    await _createAuditLog(
      action: 'create',
      userId: performedBy,
      targetUserId: user.id,
      performedBy: performedBy,
      changes: user.toMap(),
    );
  }

  // Log user update
  Future<void> logUserUpdate(
    UserModel oldUser,
    UserModel newUser,
    String performedBy,
  ) async {
    final Map<String, dynamic> changes = {};
    final oldData = oldUser.toMap();
    final newData = newUser.toMap();

    // Compare and record only changed fields
    newData.forEach((key, value) {
      if (oldData[key] != value) {
        changes[key] = {
          'old': oldData[key],
          'new': value,
        };
      }
    });

    if (changes.isNotEmpty) {
      await _createAuditLog(
        action: 'update',
        userId: performedBy,
        targetUserId: newUser.id,
        performedBy: performedBy,
        changes: changes,
      );
    }
  }

  // Log user deletion
  Future<void> logUserDeletion(UserModel user, String performedBy) async {
    await _createAuditLog(
      action: 'delete',
      userId: performedBy,
      targetUserId: user.id,
      performedBy: performedBy,
      changes: user.toMap(),
    );
  }

  // Create audit log entry
  Future<void> _createAuditLog({
    required String action,
    required String userId,
    required String targetUserId,
    required String performedBy,
    required Map<String, dynamic> changes,
  }) async {
    try {
      final auditLog = AuditLogModel(
        id: '', // Will be set by Firestore
        action: action,
        userId: userId,
        targetUserId: targetUserId,
        performedBy: performedBy,
        timestamp: DateTime.now(),
        changes: changes,
      );

      await _firestore.collection('audit_logs').add(auditLog.toMap());
    } catch (e) {
      print('Error creating audit log: $e');
      rethrow;
    }
  }
}
