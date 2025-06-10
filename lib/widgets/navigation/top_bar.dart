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

        // User profile button with menu
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Theme(
            data: Theme.of(context).copyWith(
              cardColor: const Color(0xFFF7F8FA),
              shadowColor: Colors.black.withOpacity(0.10),
              popupMenuTheme: PopupMenuThemeData(
                color: const Color(0xFFF7F8FA),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF222B45),
                ),
              ),
            ),
            child: PopupMenuButton<String>(
              offset: const Offset(0, 48),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              itemBuilder: (context) => [
                _buildMenuItem(
                  context,
                  value: 'profile',
                  icon: Icons.person_outline,
                  label: 'Profile',
                ),
                _buildMenuItem(
                  context,
                  value: 'settings',
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                ),
                const PopupMenuDivider(),
                _buildMenuItem(
                  context,
                  value: 'logout',
                  icon: Icons.logout,
                  label: 'Logout',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                ),
              ],
              onSelected: (value) async {
                switch (value) {
                  case 'profile':
                    // TODO: Navigate to profile screen
                    break;
                  case 'settings':
                    // TODO: Navigate to settings screen
                    break;
                  case 'logout':
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.errorColor,
                            ),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && context.mounted) {
                      await userProvider.signOut();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    }
                    break;
                }
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
                child: Text(project.name),
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
    // TODO: Implement notifications panel
  }

  PopupMenuItem<String> _buildMenuItem(
    BuildContext context, {
    required String value,
    required IconData icon,
    required String label,
    Color? iconColor,
    Color? textColor,
  }) {
    return PopupMenuItem<String>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: iconColor ?? const Color(0xFF222B45)),
          const SizedBox(width: 14),
          Text(
            label,
            style: TextStyle(
              color: textColor ?? const Color(0xFF222B45),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
