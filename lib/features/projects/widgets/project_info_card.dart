import 'package:flutter/material.dart';
import '../../../core/models/project_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';
import '../../../widgets/common/status_badge.dart';

class ProjectInfoCard extends StatelessWidget {
  final ProjectModel project;
  final UserModel currentUser;
  final VoidCallback? onStatusUpdate;
  final VoidCallback? onEditDescription;

  const ProjectInfoCard({
    super.key,
    required this.project,
    required this.currentUser,
    this.onStatusUpdate,
    this.onEditDescription,
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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.name, style: AppTextStyles.heading2),
                      const SizedBox(height: 4),
                      Text(
                        project.location,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildProjectMeta(),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildProjectDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    String statusText;
    StatusType statusType;

    switch (project.status) {
      case 'active':
        statusText = 'Active';
        statusType = StatusType.success;
        break;
      case 'completed':
        statusText = 'Completed';
        statusType = StatusType.info;
        break;
      case 'pending':
        statusText = 'Pending';
        statusType = StatusType.pending;
        break;
      case 'canceled':
        statusText = 'Canceled';
        statusType = StatusType.error;
        break;
      default:
        statusText = 'Unknown';
        statusType = StatusType.custom;
    }

    return InkWell(
      onTap: onStatusUpdate,
      borderRadius: BorderRadius.circular(4),
      child: StatusBadge(text: statusText, type: statusType),
    );
  }

  Widget _buildProjectMeta() {
    return Row(
      children: [
        _buildMetaItem(
          icon: Icons.calendar_today,
          label: project.endDate != null ? 'Completed' : 'Started',
          value: Utils.formatDate(project.endDate ?? project.startDate),
        ),
        const SizedBox(width: 24),
        _buildMetaItem(
          icon: Icons.timer_outlined,
          label: 'Duration',
          value: '${project.durationInDays} days',
        ),
        if (project.projectManagerId != null) ...[
          const SizedBox(width: 24),
          _buildMetaItem(
            icon: Icons.person_outline,
            label: 'Manager',
            value:
                project.projectManagerId == currentUser.id ? 'You' : 'Assigned',
          ),
        ],
      ],
    );
  }

  Widget _buildMetaItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyMedium),
      ],
    );
  }

  Widget _buildProjectDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Project Overview', style: AppTextStyles.heading4),
            if (currentUser.isAdmin)
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                tooltip: 'Edit Project Description',
                onPressed: onEditDescription,
                color: AppColors.primary,
                splashRadius: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(project.description, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}
