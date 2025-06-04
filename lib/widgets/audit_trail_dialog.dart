import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/audit_log_model.dart';
import '../services/audit_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class AuditTrailDialog extends StatefulWidget {
  const AuditTrailDialog({Key? key}) : super(key: key);

  @override
  State<AuditTrailDialog> createState() => _AuditTrailDialogState();
}

class _AuditTrailDialogState extends State<AuditTrailDialog> {
  final AuditService _auditService = AuditService();
  final UserService _userService = UserService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String _getActionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'create':
        return '➕';
      case 'update':
        return '✏️';
      case 'delete':
        return '🗑️';
      default:
        return '📝';
    }
  }

  String _formatChanges(Map<String, dynamic> changes) {
    if (changes.isEmpty) return 'No changes recorded';

    final StringBuffer buffer = StringBuffer();
    changes.forEach((key, value) {
      if (value is Map) {
        buffer.writeln('$key:');
        buffer.writeln('  - Old: ${value['old']}');
        buffer.writeln('  - New: ${value['new']}');
      } else {
        buffer.writeln('$key: $value');
      }
    });
    return buffer.toString();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Audit Trail',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search audit logs...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 16),

              // Audit Logs List
              Expanded(
                child: StreamBuilder<List<AuditLogModel>>(
                  stream: _auditService.getAuditLogs(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final logs = snapshot.data ?? [];
                    final filteredLogs = logs.where((log) {
                      final searchString =
                          '${log.action} ${log.performedBy} ${log.targetUserId}'
                              .toLowerCase();
                      return searchString.contains(_searchQuery);
                    }).toList();

                    return ListView.separated(
                      itemCount: filteredLogs.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final log = filteredLogs[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: Text(
                              _getActionIcon(log.action),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          title: StreamBuilder<List<UserModel>>(
                            stream: _userService.getAllUsers(),
                            builder: (context, usersSnapshot) {
                              final users = usersSnapshot.data ?? [];
                              final performer = users.firstWhere(
                                (u) => u.id == log.performedBy,
                                orElse: () => UserModel(
                                  id: '',
                                  name: 'Unknown User',
                                  email: '',
                                  role: '',
                                  photoUrl: '',
                                  assignedProjects: [],
                                ),
                              );
                              final target = users.firstWhere(
                                (u) => u.id == log.targetUserId,
                                orElse: () => UserModel(
                                  id: '',
                                  name: 'Unknown User',
                                  email: '',
                                  role: '',
                                  photoUrl: '',
                                  assignedProjects: [],
                                ),
                              );

                              return RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: performer.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${log.action}d user ',
                                    ),
                                    TextSpan(
                                      text: target.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('MMM d, y HH:mm:ss')
                                    .format(log.timestamp),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Change Details'),
                                content: SingleChildScrollView(
                                  child: Text(_formatChanges(log.changes)),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
