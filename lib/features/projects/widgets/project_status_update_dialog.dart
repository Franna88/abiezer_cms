import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/constants.dart';

class ProjectStatusUpdateDialog extends StatefulWidget {
  final String currentStatus;

  const ProjectStatusUpdateDialog({super.key, required this.currentStatus});

  @override
  State<ProjectStatusUpdateDialog> createState() =>
      _ProjectStatusUpdateDialogState();
}

class _ProjectStatusUpdateDialogState extends State<ProjectStatusUpdateDialog> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update Project Status', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            Text(
              'Select the new status for this project',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            _buildStatusOptions(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, _selectedStatus),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Update Status'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOptions() {
    return Column(
      children: [
        _buildStatusOption(
          title: 'Active',
          description: 'Project is currently in progress',
          value: AppConstants.projectStatusActive,
        ),
        const SizedBox(height: 12),
        _buildStatusOption(
          title: 'Pending',
          description: 'Project is on hold or not started yet',
          value: AppConstants.projectStatusPending,
        ),
        const SizedBox(height: 12),
        _buildStatusOption(
          title: 'Completed',
          description: 'Project is finished and all work is done',
          value: AppConstants.projectStatusCompleted,
        ),
        const SizedBox(height: 12),
        _buildStatusOption(
          title: 'Canceled',
          description: 'Project has been terminated',
          value: AppConstants.projectStatusCanceled,
        ),
      ],
    );
  }

  Widget _buildStatusOption({
    required String title,
    required String description,
    required String value,
  }) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(description, style: AppTextStyles.bodySmall),
      value: value,
      groupValue: _selectedStatus,
      activeColor: AppColors.primary,
      onChanged: (newValue) {
        if (newValue != null) {
          setState(() {
            _selectedStatus = newValue;
          });
        }
      },
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color:
              _selectedStatus == value ? AppColors.primary : AppColors.border,
          width: _selectedStatus == value ? 2 : 1,
        ),
      ),
    );
  }
}
