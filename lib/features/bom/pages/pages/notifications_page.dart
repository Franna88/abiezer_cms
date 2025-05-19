import 'package:flutter/material.dart';
import '../../../../core/theme/color_theme.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utilities/utilities.dart';
import '../../../../widgets/common/section_header.dart';

class NotificationsPage extends StatefulWidget {
  final String? projectId;

  const NotificationsPage({super.key, this.projectId});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: Utils.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Notifications'),
            const SizedBox(height: 8),
            Text(
              'View alerts and system notifications',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: Utils.spacing_lg),
            _buildNotificationsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildNotificationsHeader(),
          const Divider(height: 1),
          _buildNotificationsTable(),
        ],
      ),
    );
  }

  Widget _buildNotificationsHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('All Notifications', style: AppTextStyles.heading4),
          Row(
            children: [
              _buildFilterButton('All'),
              const SizedBox(width: 8),
              _buildFilterButton('Unread'),
              const SizedBox(width: 8),
              _buildFilterButton('Alerts'),
              const SizedBox(width: 8),
              _buildFilterButton('Updates'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNotificationsTable() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // TODO: Replace with actual data
      itemBuilder: (context, index) {
        return _buildNotificationItem(
          'Low Stock Alert',
          'Cement stock level is below threshold',
          '2024-03-20 14:30',
          Icons.warning_amber_outlined,
          AppColors.warning,
          false,
        );
      },
    );
  }

  Widget _buildNotificationItem(
    String title,
    String message,
    String timestamp,
    IconData icon,
    Color color,
    bool isRead,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isRead ? AppColors.cardBackground : color.withOpacity(0.05),
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timestamp,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isRead ? Icons.mark_email_read : Icons.mark_email_unread,
            color: isRead ? AppColors.textSecondary : color,
          ),
          onPressed: () {
            // TODO: Implement mark as read/unread
          },
        ),
        onTap: () {
          // TODO: Implement notification details view
        },
      ),
    );
  }
}
