import 'package:flutter/material.dart';
import '../../../utils/app_theme.dart';

class UserDetailsModal extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String role;
  final List<String> projects;
  final List<String> permissions;
  final String? photoUrl;

  const UserDetailsModal({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.projects,
    required this.permissions,
    this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = role == 'Admin';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'User Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    color: AppTheme.textSecondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // User info section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Photo
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    backgroundImage:
                        photoUrl != null ? NetworkImage(photoUrl!) : null,
                    child: photoUrl == null
                        ? Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 20),
                  // User Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          phone,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isAdmin
                                ? AppTheme.primaryColor
                                : AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            role,
                            style: TextStyle(
                              color: isAdmin
                                  ? Colors.white
                                  : AppTheme.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Projects section
              if (projects.isNotEmpty) ...[
                Text(
                  'Assigned Projects',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: projects.map((project) {
                    return Chip(
                      label: Text(project),
                      backgroundColor: AppTheme.primaryLightColor,
                      labelStyle: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 14,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],

              // Permissions section
              if (permissions.isNotEmpty) ...[
                Text(
                  'Permissions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: permissions.map((permission) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: AppTheme.successColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            permission,
                            style: TextStyle(
                              color: AppTheme.successColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
