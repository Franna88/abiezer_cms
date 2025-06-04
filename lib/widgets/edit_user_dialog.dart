import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class EditUserDialog extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUserUpdated;

  const EditUserDialog({
    Key? key,
    required this.user,
    required this.onUserUpdated,
  }) : super(key: key);

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();
  final _imagePicker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  late String _selectedRole;
  late List<String> _selectedProjects;
  XFile? _profilePhoto;
  bool _isLoading = false;

  // Empty projects list - will be populated from backend later
  final List<String> _availableProjects = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing user data
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _selectedRole = widget.user.role;
    _selectedProjects = List.from(widget.user.assignedProjects);
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePhoto = image;
      });
    }
  }

  void _toggleProject(String project) {
    setState(() {
      if (_selectedProjects.contains(project)) {
        _selectedProjects.remove(project);
      } else {
        _selectedProjects.add(project);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final updatedUser = await _userService.updateUser(
          userId: widget.user.id,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          role: _selectedRole,
          phone: _phoneController.text.trim(),
          assignedProjects: _selectedRole == 'admin' ? [] : _selectedProjects,
        );

        if (updatedUser != null) {
          widget.onUserUpdated(updatedUser);
          Navigator.of(context).pop();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Padding(
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
                      const Text(
                        'Edit User',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Profile Photo
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade50,
                          child: _profilePhoto == null
                              ? Text(
                                  widget.user.name.isNotEmpty
                                      ? widget.user.name[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue.shade700,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.blue,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt,
                                  size: 16, color: Colors.white),
                              onPressed: _pickImage,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form Fields
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
                  ),
                  const SizedBox(height: 16),

                  // Role Selection
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'admin',
                        child: Text('Admin'),
                      ),
                      DropdownMenuItem(
                        value: 'project_manager',
                        child: Text('Project Manager'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedRole = value;
                          if (value == 'admin') {
                            _selectedProjects.clear();
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Project Selection (only for project managers)
                  if (_selectedRole == 'project_manager') ...[
                    const Text(
                      'Assigned Projects',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
                          onSelected: (_) => _toggleProject(project),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
