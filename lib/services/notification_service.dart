import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';
import '../utils/dev_data.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final bool _useMockData = true; // Set to false for production

  // Initialize Firestore settings for offline support
  NotificationService() {
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  // Get notifications for a specific user
  Stream<List<NotificationModel>> getNotificationsForUser(String userId) {
    if (_useMockData) {
      // Use mock data for development
      return Stream.value(
        DevData.notifications
            .where((notif) => notif.userId == userId || notif.userId == 'all')
            .toList(),
      );
    }

    return _firestore
        .collection('notifications')
        .where('userId', whereIn: [userId, 'all'])
        .orderBy('timestamp', descending: true)
        .limit(10) // Limit to most recent 10
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => NotificationModel.fromFirestore(doc))
                  .toList(),
        );
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    if (_useMockData) {
      // Update mock data
      final index = DevData.notifications.indexWhere(
        (n) => n.id == notificationId,
      );
      if (index != -1) {
        DevData.notifications[index] = DevData.notifications[index].copyWith(
          isRead: true,
        );
      }
      return;
    }

    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Get unread notifications count
  Future<int> getUnreadCount(String userId) async {
    if (_useMockData) {
      // Use mock data for development
      return DevData.notifications
          .where((n) => (n.userId == userId || n.userId == 'all') && !n.isRead)
          .length;
    }

    try {
      final snapshot =
          await _firestore
              .collection('notifications')
              .where('userId', whereIn: [userId, 'all'])
              .where('isRead', isEqualTo: false)
              .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting unread notifications count: $e');
      return 0;
    }
  }

  // Create a new notification
  Future<void> createNotification({
    required String title,
    required String message,
    required NotificationType type,
    required String userId,
    String? projectId,
    String? actionUrl,
  }) async {
    if (_useMockData) {
      // Add to mock data
      final newNotif = NotificationModel(
        id: 'notif-${DevData.notifications.length + 1}',
        title: title,
        message: message,
        type: type,
        timestamp: DateTime.now(),
        isRead: false,
        userId: userId,
        projectId: projectId,
        actionUrl: actionUrl,
      );
      DevData.notifications.add(newNotif);
      return;
    }

    try {
      final notification = NotificationModel(
        id: '', // Will be set by Firestore
        title: title,
        message: message,
        type: type,
        timestamp: DateTime.now(),
        isRead: false,
        userId: userId,
        projectId: projectId,
        actionUrl: actionUrl,
      );

      await _firestore.collection('notifications').add(notification.toMap());
    } catch (e) {
      print('Error creating notification: $e');
    }
  }
}
