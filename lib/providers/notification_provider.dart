import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Fetch notifications for a user
  Future<void> fetchNotifications(String userId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Query notifications that are either for this specific user or for everyone
      final Query query = FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', whereIn: [userId, 'all'])
          .orderBy('timestamp', descending: true)
          .limit(50); // Limit to recent notifications

      final snapshot = await query.get();

      _notifications =
          snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList();
    } catch (e) {
      _error = 'Error fetching notifications: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});

      _notifications =
          _notifications.map((notification) {
            if (notification.id == notificationId) {
              return notification.copyWith(isRead: true);
            }
            return notification;
          }).toList();

      notifyListeners();
    } catch (e) {
      _error = 'Error marking notification as read: ${e.toString()}';
      notifyListeners();
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead(String userId) async {
    try {
      // Get user's unread notifications
      final batch = FirebaseFirestore.instance.batch();
      final unreadDocs =
          await FirebaseFirestore.instance
              .collection('notifications')
              .where('userId', whereIn: [userId, 'all'])
              .where('isRead', isEqualTo: false)
              .get();

      // Batch update all notifications
      for (var doc in unreadDocs.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();

      // Update local notifications
      _notifications =
          _notifications.map((notification) {
            return notification.copyWith(isRead: true);
          }).toList();

      notifyListeners();
    } catch (e) {
      _error = 'Error marking all notifications as read: ${e.toString()}';
      notifyListeners();
    }
  }

  // Stream notifications (for real-time updates)
  Stream<List<NotificationModel>> streamNotifications(String userId) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', whereIn: [userId, 'all'])
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList();
        });
  }

  // Reset error
  void resetError() {
    _error = '';
    notifyListeners();
  }
}
