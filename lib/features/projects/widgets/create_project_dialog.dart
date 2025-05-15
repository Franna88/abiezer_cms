import 'package:flutter/material.dart';
import '../../../core/models/project_model.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/constants.dart';

class CreateProjectDialog extends StatefulWidget {
  const CreateProjectDialog({super.key});

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _clientContactController = TextEditingController();
  DateTime _startDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _clientNameController.dispose();
    _clientContactController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Create a new project
      final newProject = ProjectModel(
        id:
            DateTime.now().millisecondsSinceEpoch
                .toString(), // Generate a unique ID
        name: _nameController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        clientName:
            _clientNameController.text.isEmpty
                ? null
                : _clientNameController.text,
        clientContact:
            _clientContactController.text.isEmpty
                ? null
                : _clientContactController.text,
        startDate: _startDate,
        status: AppConstants.projectStatusPending,
        assignedUsers: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Navigator.of(context).pop(newProject);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create New Project', style: AppTextStyles.heading2),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Project Name *',
                          hintText: 'Enter project name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Project name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description *',
                          hintText: 'Enter project description',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Location
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location *',
                          hintText: 'Enter project location',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Location is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Client Name
                      TextFormField(
                        controller: _clientNameController,
                        decoration: const InputDecoration(
                          labelText: 'Client Name',
                          hintText: 'Enter client name (optional)',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Client Contact
                      TextFormField(
                        controller: _clientContactController,
                        decoration: const InputDecoration(
                          labelText: 'Client Contact',
                          hintText: 'Enter client contact (optional)',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Start Date
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Start Date: ${_startDate.day}/${_startDate.month}/${_startDate.year}',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _selectStartDate(context),
                            child: const Text('Change'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Create Project'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
