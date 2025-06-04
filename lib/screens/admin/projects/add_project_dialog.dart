import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/projects_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/responsive.dart';
import '../../../models/project.dart';
import '../../../services/user_service.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({super.key});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _userService = UserService();
  DateTime? _startDate;
  DateTime? _endDate;
  String _status = 'Active';
  final List<String> _selectedProjectManagers = [];
  bool _isLoading = false;
  List<Map<String, dynamic>> _projectManagers = [];
  bool _isLoadingManagers = false;

  @override
  void initState() {
    super.initState();
    _loadProjectManagers();
  }

  Future<void> _loadProjectManagers() async {
    setState(() => _isLoadingManagers = true);
    try {
      final managers = await _userService.getProjectManagers();
      setState(() {
        _projectManagers = managers;
        _isLoadingManagers = false;
      });
    } catch (e) {
      setState(() => _isLoadingManagers = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading project managers: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select both start and end dates'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedProjectManagers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one project manager'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        // Check if user is authenticated
        if (userProvider.user == null) {
          throw Exception('You must be logged in to create a project');
        }

        final projectsProvider =
            Provider.of<ProjectsProvider>(context, listen: false);

        // Create project
        await projectsProvider.createProject(
          name: _nameController.text,
          location: _locationController.text,
          description: _descriptionController.text,
          startDate: _startDate!,
          endDate: _endDate!,
          status: _status,
          projectManagerIds: _selectedProjectManagers,
          createdBy: userProvider.user?.id ?? '',
        );

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Project created successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Error creating project';

          // Handle specific error cases
          if (e.toString().contains('must be logged in')) {
            errorMessage = 'You must be logged in to create a project';
          } else {
            errorMessage = 'Error creating project: ${e.toString()}';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: Responsive.getResponsiveValue(
          context: context,
          mobile: double.infinity,
          tablet: 500,
          desktop: 600,
        ),
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create New Project',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Project Name',
                          hintText: 'Enter project name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a project name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          hintText: 'Enter project location',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a location';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter project description',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, true),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Start Date',
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_formatDate(_startDate)),
                                    const Icon(Icons.calendar_today, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, false),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'End Date',
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_formatDate(_endDate)),
                                    const Icon(Icons.calendar_today, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _status,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'Active', child: Text('Active')),
                          DropdownMenuItem(
                              value: 'Pending', child: Text('Pending')),
                          DropdownMenuItem(
                              value: 'On Hold', child: Text('On Hold')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _status = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Project Managers',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_isLoadingManagers)
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ..._projectManagers.map((manager) {
                              final isSelected = _selectedProjectManagers
                                  .contains(manager['id']);
                              return FilterChip(
                                label: Text(manager['name']),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedProjectManagers
                                          .add(manager['id']);
                                    } else {
                                      _selectedProjectManagers
                                          .remove(manager['id']);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      if (_projectManagers.isEmpty && !_isLoadingManagers)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline),
                              SizedBox(width: 8),
                              Text('No project managers available'),
                            ],
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
                            onPressed: _isLoading ? null : _handleSubmit,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Create Project'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
