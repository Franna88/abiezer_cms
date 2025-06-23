import 'package:abiezer_cms/models/project.dart';
import 'package:abiezer_cms/models/user_model.dart';
import 'package:abiezer_cms/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abiezer_cms/utils/app_theme.dart';

class ManageTeamDialog extends StatefulWidget {
  final Project project;

  const ManageTeamDialog({
    super.key,
    required this.project,
  });

  @override
  State<ManageTeamDialog> createState() => _ManageTeamDialogState();
}

class _ManageTeamDialogState extends State<ManageTeamDialog> {
  final UserService _userService = UserService();
  List<UserModel> _allProjectManagers = [];
  List<UserModel> _filteredProjectManagers = [];
  Set<String> _selectedManagerIds = {};
  bool _isLoading = true;
  bool _isSaving = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedManagerIds = Set<String>.from(widget.project.projectManagerIds);
    _loadAllProjectManagers();

    _searchController.addListener(() {
      _filterManagers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterManagers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProjectManagers = _allProjectManagers.where((manager) {
        final nameLower = manager.name.toLowerCase();
        final emailLower = manager.email.toLowerCase();
        return nameLower.contains(query) || emailLower.contains(query);
      }).toList();
    });
  }

  Future<void> _loadAllProjectManagers() async {
    setState(() => _isLoading = true);
    try {
      final managerData = await _userService.getProjectManagers();
      _allProjectManagers = managerData
          .map((data) => UserModel.fromMap(data, data['id']))
          .toList();
      _filteredProjectManagers = _allProjectManagers;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading managers: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final newManagerIds = _selectedManagerIds.toList();
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.project.id)
          .update({'projectManagerIds': newManagerIds});

      if (mounted) {
        Navigator.pop(context, newManagerIds);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project team updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving changes: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Project Team'),
      content: _buildContent(),
      actions: _buildActions(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const SizedBox(
        width: 400,
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: 400,
      height: 350,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name or email',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredProjectManagers.isEmpty
                ? const Center(child: Text('No managers found.'))
                : ListView.builder(
                    itemCount: _filteredProjectManagers.length,
                    itemBuilder: (context, index) {
                      final manager = _filteredProjectManagers[index];
                      final isSelected =
                          _selectedManagerIds.contains(manager.id);
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        elevation: 0,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: manager.photoUrl.isNotEmpty
                                ? NetworkImage(manager.photoUrl)
                                : null,
                            backgroundColor:
                                AppTheme.primaryColor.withOpacity(0.1),
                            child: manager.photoUrl.isEmpty
                                ? Text(
                                    manager.name.isNotEmpty
                                        ? manager.name[0].toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                                  )
                                : null,
                          ),
                          title: Text(manager.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(manager.email,
                              style: TextStyle(color: Colors.grey.shade600)),
                          trailing: isSelected
                              ? TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedManagerIds.remove(manager.id);
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.red),
                                  child: const Text('Remove'),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedManagerIds.add(manager.id);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Add'),
                                ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      TextButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.pop(context),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: _isSaving ? null : _saveChanges,
        child: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Text('Save'),
      ),
    ];
  }
}
