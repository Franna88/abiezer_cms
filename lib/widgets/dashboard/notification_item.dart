import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../utils/app_theme.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final bool isRead;
  final VoidCallback? onAction;
  final String? actionLabel;

  const NotificationItem({
    Key? key,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
    this.onAction,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getNotificationColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getNotificationIcon(),
              color: _getNotificationColor(),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with unread indicator
                Row(
                  children: [
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: const BoxDecoration(
                          color: AppTheme.errorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isRead ? FontWeight.normal : FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textLightColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Message
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                // Action button if available
                if (onAction != null && actionLabel != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onAction,
                      style: TextButton.styleFrom(
                        minimumSize: const Size(88, 36),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        backgroundColor: _getNotificationColor().withOpacity(
                          0.1,
                        ),
                      ),
                      child: Text(
                        actionLabel!,
                        style: TextStyle(
                          color: _getNotificationColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon() {
    switch (type) {
      case NotificationType.materialRequest:
        return Icons.inventory_outlined;
      case NotificationType.materialApproval:
        return Icons.thumb_up_outlined;
      case NotificationType.materialTransfer:
        return Icons.swap_horiz_outlined;
      case NotificationType.materialReturn:
        return Icons.assignment_return_outlined;
      case NotificationType.purchaseRequest:
        return Icons.shopping_cart_outlined;
      case NotificationType.purchaseApproval:
        return Icons.check_circle_outline;
      case NotificationType.lowStock:
        return Icons.warning_amber_outlined;
      case NotificationType.system:
        return Icons.info_outline;
      default:
        return Icons.circle_notifications_outlined;
    }
  }

  Color _getNotificationColor() {
    switch (type) {
      case NotificationType.materialRequest:
      case NotificationType.materialApproval:
      case NotificationType.materialTransfer:
      case NotificationType.materialReturn:
        return AppTheme.primaryColor;
      case NotificationType.purchaseRequest:
      case NotificationType.purchaseApproval:
        return AppTheme.accentColor;
      case NotificationType.lowStock:
        return AppTheme.warningColor;
      case NotificationType.system:
        return AppTheme.infoColor;
      default:
        return AppTheme.primaryColor;
    }
  }
}
