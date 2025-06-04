import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/project_model.dart';
import '../../models/notification_model.dart';
import '../../providers/project_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final bool isAdmin;

  const TopBar({Key? key, this.onMenuTap, required this.isAdmin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final isMobile = Responsive.isMobile(context);

    final user = userProvider.user;
    final projects =
        isAdmin ? projectProvider.allProjects : projectProvider.userProjects;

    return AppBar(
      elevation: 1,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leadingWidth: isMobile ? 56 : 0,
      leading: isMobile
          ? IconButton(
              icon: const Icon(Icons.menu, color: AppTheme.textPrimaryColor),
              onPressed: onMenuTap,
            )
          : null,
      title: Row(
        children: [
          if (!isMobile) const SizedBox(width: 16),
          // Project Selector Dropdown
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: _buildProjectSelector(
                context,
                projects,
                projectProvider.selectedProject?.id,
                (String? projectId) {
                  projectProvider.setSelectedProject(projectId);
                },
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Notifications button
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppTheme.textPrimaryColor,
              ),
              onPressed: () {
                _showNotificationsPanel(context, notificationProvider);
              },
              tooltip: 'Notifications',
              padding: const EdgeInsets.all(16),
            ),
            if (notificationProvider.unreadCount > 0)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppTheme.errorColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    notificationProvider.unreadCount > 9
                        ? '9+'
                        : notificationProvider.unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),

        // User profile button
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              // TODO: Show user profile options
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  if (!isMobile) ...[
                    Text(
                      '${user?.name ?? 'User'} - ${user?.role == 'admin' ? 'Admin' : 'Project Manager'}',
                      style: const TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    radius: 18,
                    child: Text(
                      user?.name?.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectSelector(
    BuildContext context,
    List<ProjectModel> projects,
    String? selectedProjectId,
    Function(String?) onChanged,
  ) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedProjectId,
          hint: const Text(
            'Select Project',
            style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          elevation: 2,
          style: const TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 14,
          ),
          onChanged: onChanged,
          items: [
            // Allow selecting no project
            const DropdownMenuItem<String>(
              value: null,
              child: Text('All Projects'),
            ),
            // Project list
            ...projects.map((project) {
              return DropdownMenuItem<String>(
                value: project.id,
                child: Text(project.name, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showNotificationsPanel(
    BuildContext context,
    NotificationProvider notificationProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: Responsive.getResponsiveWidth(
              context,
              percentageMobile: 90,
              percentageDesktop: 30,
            ),
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const Divider(),
                notificationProvider.notifications.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: Text('No notifications')),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: notificationProvider.notifications.length,
                          itemBuilder: (context, index) {
                            final notification =
                                notificationProvider.notifications[index];
                            return ListTile(
                              title: Text(
                                notification.title,
                                style: TextStyle(
                                  fontWeight: notification.isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                notification.message,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: _getNotificationIcon(notification.type),
                              onTap: () {
                                // Mark as read when tapped
                                notificationProvider
                                    .markAsRead(notification.id);
                                // Close dialog
                                Navigator.of(context).pop();
                                // TODO: Navigate to related screen if actionUrl exists
                              },
                            );
                          },
                        ),
                      ),
                if (notificationProvider.notifications.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          if (Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).user?.id !=
                              null) {
                            notificationProvider.markAllAsRead(
                              Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).user!.id,
                            );
                          }
                        },
                        child: const Text('Mark all as read'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getNotificationIcon(NotificationType type) {
    IconData iconData;
    Color color;

    switch (type) {
      case NotificationType.materialRequest:
        iconData = Icons.inventory_2_outlined;
        color = AppTheme.infoColor;
        break;
      case NotificationType.materialApproval:
        iconData = Icons.done_outline;
        color = AppTheme.successColor;
        break;
      case NotificationType.materialTransfer:
        iconData = Icons.swap_horiz;
        color = AppTheme.infoColor;
        break;
      case NotificationType.materialReturn:
        iconData = Icons.assignment_return_outlined;
        color = AppTheme.warningColor;
        break;
      case NotificationType.purchaseRequest:
        iconData = Icons.shopping_cart_outlined;
        color = AppTheme.infoColor;
        break;
      case NotificationType.purchaseApproval:
        iconData = Icons.check_circle_outline;
        color = AppTheme.successColor;
        break;
      case NotificationType.lowStock:
        iconData = Icons.warning_amber_outlined;
        color = AppTheme.errorColor;
        break;
      case NotificationType.system:
      default:
        iconData = Icons.info_outline;
        color = AppTheme.primaryColor;
        break;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(iconData, color: color, size: 20),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
