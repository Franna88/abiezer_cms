import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../utils/app_theme.dart';

class EditUserModal extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String role;
  final List<String> projects;
  final List<String> permissions;
  final String? photoUrl;
  final Function(String name, String email, String phone, String role,
      List<String> projects, List<String> permissions, File? newPhoto) onSave;

  const EditUserModal({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.projects,
    required this.permissions,
    this.photoUrl,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditUserModal> createState() => _EditUserModalState();
}

class _EditUserModalState extends State<EditUserModal> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late String _selectedRole;
  late List<String> _selectedProjects;
  late List<String> _selectedPermissions;
  File? _selectedPhoto;
  bool _isAdmin = false;

  // Sample data - replace with actual data from your provider
  final List<String> _availableRoles = ['Admin', 'Project Manager'];
  final List<String> _availableProjects = [
    'Project X',
    'Project Y',
    'Project Z'
  ];
  final List<String> _availablePermissions = [
    'BoM Access',
    'Request Submission',
    'Full Access'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _selectedRole = widget.role;
    _isAdmin = widget.role == 'Admin';
    _selectedProjects =
        _isAdmin ? _availableProjects : List.from(widget.projects);
    _selectedPermissions =
        _isAdmin ? _availablePermissions : List.from(widget.permissions);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
                backgroundImage: _selectedPhoto != null
                    ? FileImage(_selectedPhoto!)
                    : widget.photoUrl != null
                        ? NetworkImage(widget.photoUrl!) as ImageProvider
                        : null,
                child: (_selectedPhoto == null && widget.photoUrl == null)
                    ? Text(
                        widget.name.isNotEmpty
                            ? widget.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit User',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    color: AppTheme.textSecondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Profile Photo
              _buildProfilePhotoSection(),

              // Form fields
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Role dropdown
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: _availableRoles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRole = value;
                      _isAdmin = value == 'Admin';
                      if (_isAdmin) {
                        _selectedProjects = List.from(_availableProjects);
                        _selectedPermissions = List.from(_availablePermissions);
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
                      onSelected: _isAdmin
                          ? null
                          : (selected) {
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
              ],

              // Permissions section (hidden for admin)
              if (!_isAdmin) ...[
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
                      onSelected: _isAdmin
                          ? null
                          : (selected) {
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
              ],
              const SizedBox(height: 32),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      widget.onSave(
                        _nameController.text,
                        _emailController.text,
                        _phoneController.text,
                        _selectedRole,
                        _isAdmin ? _availableProjects : _selectedProjects,
                        _isAdmin ? _availablePermissions : _selectedPermissions,
                        _selectedPhoto,
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save Changes'),
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
