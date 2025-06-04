import 'package:flutter/material.dart';
import 'dart:io';
import '../../../utils/app_theme.dart';
import 'user_details_modal.dart';
import 'edit_user_modal.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String role;
  final List<String> projects;
  final List<String> permissions;
  final String? photoUrl;
  final Function(String name, String email, String phone, String role,
      List<String> projects, List<String> permissions, File? newPhoto) onSave;
  final VoidCallback onDeactivate;

  const UserCard({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.projects,
    required this.permissions,
    this.photoUrl,
    required this.onSave,
    required this.onDeactivate,
  }) : super(key: key);

  void _showEditModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditUserModal(
        name: name,
        email: email,
        phone: phone,
        role: role,
        projects: projects,
        permissions: permissions,
        photoUrl: photoUrl,
        onSave: onSave,
      ),
    );
  }

  void _showUserDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => UserDetailsModal(
        name: name,
        email: email,
        phone: phone,
        role: role,
        projects: projects,
        permissions: permissions,
        photoUrl: photoUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = role == 'Admin';

    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => _showUserDetails(context),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // User Avatar
              CircleAvatar(
                radius: 32,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                backgroundImage:
                    photoUrl != null ? NetworkImage(photoUrl!) : null,
                child: photoUrl == null
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 12),
              // User Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Email
              Text(
                email,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Role Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isAdmin
                      ? AppTheme.primaryColor
                      : AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    color: isAdmin ? Colors.white : AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (!isAdmin && projects.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '${projects.length} Project${projects.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: () => _showEditModal(context),
                    tooltip: 'Edit User',
                    color: AppTheme.primaryColor,
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_off_outlined, size: 20),
                    onPressed: onDeactivate,
                    tooltip: 'Deactivate User',
                    color: AppTheme.errorColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
