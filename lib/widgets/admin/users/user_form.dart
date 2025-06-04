import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  final VoidCallback onClose;
  final Map<String, dynamic>? initialData;

  const UserForm({
    Key? key,
    required this.onClose,
    this.initialData,
  }) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String _selectedRole = 'Project Manager';
  List<String> _selectedProjects = [];
  Map<String, bool> _permissions = {
    'BoM Access': false,
    'Request Submission': false,
  };

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialData?['name'] ?? '');
    _emailController =
        TextEditingController(text: widget.initialData?['email'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initialData == null ? 'Add User' : 'Edit User',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Projects',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Project X'),
                    selected: _selectedProjects.contains('Project X'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedProjects.add('Project X');
                        } else {
                          _selectedProjects.remove('Project X');
                        }
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Project Y'),
                    selected: _selectedProjects.contains('Project Y'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedProjects.add('Project Y');
                        } else {
                          _selectedProjects.remove('Project Y');
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Permissions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ..._permissions.entries.map(
                (entry) => CheckboxListTile(
                  title: Text(entry.key),
                  value: entry.value,
                  onChanged: (value) {
                    setState(() {
                      _permissions[entry.key] = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                      widget.onClose();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.initialData == null ? 'Add User' : 'Save Changes',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
