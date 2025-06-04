import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../../utils/app_theme.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onViewDetails;

  const ProjectCard({
    Key? key,
    required this.project,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(project.status);
    final formattedManager = project.projectManagers.isNotEmpty
        ? project.projectManagers.first // Just display first manager
        : 'No Manager';

    return Card(
      child: InkWell(
        onTap: onViewDetails,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project name and status badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: AppTheme.titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _capitalizeFirstLetter(project.status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Location
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      project.location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Project Manager
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      formattedManager,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              // BoM Status - hardcoded for now, should come from real data
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 16,
                    color: AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'BoM Created', // Hardcoded for now
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // View Details button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onViewDetails,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.successColor;
      case 'completed':
        return AppTheme.primaryColor;
      case 'on-hold':
        return AppTheme.warningColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.textLightColor;
    }
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
