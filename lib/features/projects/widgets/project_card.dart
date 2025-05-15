import 'package:flutter/material.dart';
import '../../../core/models/project_model.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/constants.dart';
import '../../../core/utilities/utilities.dart';
import '../../../widgets/common/status_badge.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;
  final bool isAdmin;
  final bool isAssigned;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    required this.isAdmin,
    required this.isAssigned,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              isAssigned
                  ? AppColors.secondary.withOpacity(0.3)
                  : Colors.transparent,
          width: isAssigned ? 2 : 0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: AppTextStyles.heading3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusBadge(),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                project.location,
                style: AppTextStyles.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                project.description,
                style: AppTextStyles.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Started', style: AppTextStyles.caption),
                      Text(
                        Utils.formatDate(project.startDate),
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  _buildProjectManagerBadge(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    String statusText;
    StatusType statusType;

    switch (project.status) {
      case AppConstants.projectStatusActive:
        statusText = 'Active';
        statusType = StatusType.success;
        break;
      case AppConstants.projectStatusCompleted:
        statusText = 'Completed';
        statusType = StatusType.info;
        break;
      case AppConstants.projectStatusPending:
        statusText = 'Pending';
        statusType = StatusType.pending;
        break;
      case AppConstants.projectStatusCanceled:
        statusText = 'Canceled';
        statusType = StatusType.error;
        break;
      default:
        statusText = 'Unknown';
        statusType = StatusType.custom;
    }

    return StatusBadge(text: statusText, type: statusType);
  }

  Widget _buildProjectManagerBadge() {
    if (project.projectManagerId != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.person, size: 14, color: AppColors.secondary),
            const SizedBox(width: 4),
            Text(
              'Managed',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
