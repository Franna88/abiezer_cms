import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  materialRequest,
  materialApproval,
  materialTransfer,
  materialReturn,
  purchaseRequest,
  purchaseApproval,
  lowStock,
  system,
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String userId; // 'all' for everyone, or specific userId
  final String? projectId;
  final String? actionUrl; // For deep linking

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    required this.userId,
    this.projectId,
    this.actionUrl,
  });

  // Create from Firestore document
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      type: NotificationType.values.firstWhere(
        (type) => type.toString() == 'NotificationType.${data['type']}',
        orElse: () => NotificationType.system,
      ),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      userId: data['userId'] ?? 'all',
      projectId: data['projectId'],
      actionUrl: data['actionUrl'],
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'userId': userId,
      'projectId': projectId,
      'actionUrl': actionUrl,
    };
  }

  // Create a copy with updated fields
  NotificationModel copyWith({
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? userId,
    String? projectId,
    String? actionUrl,
  }) {
    return NotificationModel(
      id: this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      userId: userId ?? this.userId,
      projectId: projectId ?? this.projectId,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }
}
