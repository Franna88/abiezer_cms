import 'package:flutter/material.dart';
import '../../models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final bool isAssigned;
  final List<String> managerNames;
  final VoidCallback? onViewBOM;

  const ProjectCard({
    Key? key,
    required this.project,
    required this.isAssigned,
    required this.managerNames,
    this.onViewBOM,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(project.status),
                if (!isAssigned) ...[
                  const SizedBox(width: 8),
                  Tooltip(
                    message: 'You are not assigned to this project',
                    child: const Icon(Icons.lock_outline,
                        color: Colors.grey, size: 20),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, project.location),
            const SizedBox(height: 4),
            _buildInfoRow(
              Icons.calendar_today,
              _formatDateRange(project.startDate, project.endDate),
            ),
            if (project.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              _buildInfoRow(Icons.description, project.description,
                  maxLines: 1),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    managerNames.isNotEmpty
                        ? managerNames.join(', ')
                        : 'No Project Manager Assigned',
                    style: const TextStyle(
                        fontSize: 13, fontStyle: FontStyle.italic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isAssigned && onViewBOM != null)
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: onViewBOM,
                  child: const Text('View BOM'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value, {int? maxLines}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
            maxLines: maxLines,
            overflow: maxLines != null ? TextOverflow.ellipsis : null,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;
    switch (status.toLowerCase()) {
      case 'active':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'completed':
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case 'archived':
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
    }
    return Chip(
      label: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      backgroundColor: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _formatDateRange(DateTime start, DateTime? end) {
    String startStr = _formatDate(start);
    String endStr = end != null ? _formatDate(end) : '';
    return endStr.isNotEmpty ? '$startStr - $endStr' : startStr;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
