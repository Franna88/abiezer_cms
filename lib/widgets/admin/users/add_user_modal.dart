import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../utils/app_theme.dart';

class AddUserModal extends StatefulWidget {
  final Function(String name, String email, String phone, String role,
      List<String> projects, List<String> permissions, File? photo) onSave;
  final VoidCallback onClose;

  const AddUserModal({
    Key? key,
    required this.onSave,
    required this.onClose,
  }) : super(key: key);

  @override
  State<AddUserModal> createState() => _AddUserModalState();
}

class _AddUserModalState extends State<AddUserModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedRole = 'Project Manager';
  List<String> _selectedProjects = [];
  List<String> _selectedPermissions = [];
  File? _selectedPhoto;
  bool _isAdmin = false;

  // Sample data - replace with actual data from your provider
  final List<String> _availableProjects = ['Project X', 'Project Y'];
  final List<String> _availablePermissions = [
    'BoM Access',
    'Request Submission',
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedPhoto = File(image.path);
      });
    }
  }

  Widget _buildProfilePhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Photo',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                backgroundImage:
                    _selectedPhoto != null ? FileImage(_selectedPhoto!) : null,
                child: _selectedPhoto == null
                    ? Icon(
                        Icons.person_outline,
                        size: 50,
                        color: AppTheme.primaryColor,
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 18),
                    color: Colors.white,
                    onPressed: _pickImage,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add User',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: widget.onClose,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Profile Photo
                _buildProfilePhotoSection(),

                // Form fields
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Role dropdown
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Project Manager',
                      child: Text('Project Manager'),
                    ),
                    DropdownMenuItem(
                      value: 'Admin',
                      child: Text('Admin'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedRole = value;
                        _isAdmin = value == 'Admin';
                        if (_isAdmin) {
                          _selectedProjects = List.from(_availableProjects);
                          _selectedPermissions =
                              List.from(_availablePermissions);
                        }
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Projects section (hidden for admin)
                if (!_isAdmin) ...[
                  Text(
                    'Assigned Projects',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableProjects.map((project) {
                      final isSelected = _selectedProjects.contains(project);
                      return FilterChip(
                        label: Text(project),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedProjects.add(project);
                            } else {
                              _selectedProjects.remove(project);
                            }
                          });
                        },
                        backgroundColor: AppTheme.primaryLightColor,
                        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                        checkmarkColor: AppTheme.primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.textPrimaryColor,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Permissions section (hidden for admin)
                  Text(
                    'Permissions',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availablePermissions.map((permission) {
                      final isSelected =
                          _selectedPermissions.contains(permission);
                      return FilterChip(
                        label: Text(permission),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedPermissions.add(permission);
                            } else {
                              _selectedPermissions.remove(permission);
                            }
                          });
                        },
                        backgroundColor: AppTheme.successColor.withOpacity(0.1),
                        selectedColor: AppTheme.successColor.withOpacity(0.2),
                        checkmarkColor: AppTheme.successColor,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppTheme.successColor
                              : AppTheme.textPrimaryColor,
                        ),
                      );
                    }).toList(),
                  ),
                ] else ...[
                  // Admin info message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Admin users automatically have full access to all projects and permissions.',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: widget.onClose,
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSave(
                            _nameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _selectedRole,
                            _isAdmin ? _availableProjects : _selectedProjects,
                            _isAdmin
                                ? _availablePermissions
                                : _selectedPermissions,
                            _selectedPhoto,
                          );
                          widget.onClose();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add User'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
