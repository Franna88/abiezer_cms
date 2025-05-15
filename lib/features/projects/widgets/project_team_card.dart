import 'package:flutter/material.dart';
import '../../../core/models/project_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';

class ProjectTeamCard extends StatelessWidget {
  final ProjectModel project;
  final UserModel currentUser;
  final VoidCallback onAssignTeam;

  const ProjectTeamCard({
    super.key,
    required this.project,
    required this.currentUser,
    required this.onAssignTeam,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Project Team', style: AppTextStyles.heading4),
                if (currentUser.isAdmin)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onAssignTeam,
                    tooltip: 'Assign Team Members',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTeamList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamList() {
    // In a real app, you would fetch user details for each ID
    // For now, we'll use dummy data
    final teamMembers = [
      _TeamMember(
        id: project.projectManagerId ?? '',
        name: 'Project Manager',
        email: 'pm@abiezer.com',
        role: 'Project Manager',
        isCurrentUser: project.projectManagerId == currentUser.id,
      ),
      _TeamMember(
        id: '3',
        name: 'John Smith',
        email: 'john@abiezer.com',
        role: 'Site Supervisor',
        isCurrentUser: '3' == currentUser.id,
      ),
      _TeamMember(
        id: '4',
        name: 'Sarah Johnson',
        email: 'sarah@abiezer.com',
        role: 'Quantity Surveyor',
        isCurrentUser: '4' == currentUser.id,
      ),
    ];

    return Column(
      children:
          teamMembers.map((member) {
            return _buildTeamMemberTile(member);
          }).toList(),
    );
  }

  Widget _buildTeamMemberTile(_TeamMember member) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  member.isCurrentUser
                      ? AppColors.primary
                      : AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getInitials(member.name),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(member.role, style: AppTextStyles.caption),
              ],
            ),
          ),
          if (member.isCurrentUser)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'You',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}';
    } else if (name.isNotEmpty) {
      return name[0];
    }
    return '';
  }
}

class _TeamMember {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isCurrentUser;

  _TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isCurrentUser,
  });
}
