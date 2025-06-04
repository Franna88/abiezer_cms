import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/projects_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/project.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive.dart';
import 'projects/add_project_dialog.dart';
import '../../services/bom_service.dart';
import '../../services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final BoMService _bomService = BoMService();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    // Load projects when screen initializes
    Future.microtask(() =>
        Provider.of<ProjectsProvider>(context, listen: false).loadProjects());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddProjectDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(
          Responsive.getResponsiveValue(
            context: context,
            mobile: 16.0,
            tablet: 24.0,
            desktop: 32.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Projects',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddProjectDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Project'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSearchAndFilters(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildProjectsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Consumer<ProjectsProvider>(
      builder: (context, projectsProvider, _) => Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search projects...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        projectsProvider.setSearchQuery('');
                      },
                    )
                  : null,
            ),
            onChanged: projectsProvider.setSearchQuery,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  value: projectsProvider.statusFilter.isEmpty
                      ? null
                      : projectsProvider.statusFilter,
                  items: const [
                    DropdownMenuItem(value: '', child: Text('All')),
                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                    DropdownMenuItem(
                        value: 'Completed', child: Text('Completed')),
                    DropdownMenuItem(
                        value: 'Archived', child: Text('Archived')),
                  ],
                  onChanged: (value) =>
                      projectsProvider.setStatusFilter(value ?? ''),
                ),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear Filters'),
                onPressed: () {
                  _searchController.clear();
                  projectsProvider.clearFilters();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList() {
    return Consumer<ProjectsProvider>(
      builder: (context, projectsProvider, _) {
        if (projectsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final projects = projectsProvider.projects;

        if (projects.isEmpty) {
          return const Center(
            child: Text(
              'No projects found',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 380,
            mainAxisExtent: 170,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return _buildProjectCard(project);
          },
        );
      },
    );
  }

  Widget _buildProjectCard(Project project) {
    return FutureBuilder<bool>(
      future: _hasLowStock(project.id),
      builder: (context, snapshot) {
        final hasLowStock = snapshot.data ?? false;
        return FutureBuilder<List<String>>(
          future: _getProjectManagerNames(project.projectManagerIds),
          builder: (context, managerSnapshot) {
            final managerNames = managerSnapshot.data ?? [];
            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/admin/project-details',
                      arguments: project,
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left: Project Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          if (hasLowStock) ...[
                                            const SizedBox(width: 8),
                                            _buildLowStockAlert(),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          _buildInfoRow(Icons.location_on,
                                              project.location),
                                          const SizedBox(width: 16),
                                          _buildInfoRow(
                                            Icons.calendar_today,
                                            '${_formatDate(project.startDate)} - ${_formatDate(project.endDate)}',
                                          ),
                                        ],
                                      ),
                                      if (project.description.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        _buildInfoRow(Icons.description,
                                            project.description,
                                            maxLines: 1),
                                      ],
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.person,
                                              size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              managerNames.isNotEmpty
                                                  ? managerNames.join(', ')
                                                  : 'No Project Manager Assigned',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontStyle: FontStyle.italic),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
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
                                    if (hasLowStock) ...[
                                      const SizedBox(width: 8),
                                      _buildLowStockAlert(),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                    Icons.location_on, project.location),
                                const SizedBox(height: 4),
                                _buildInfoRow(
                                  Icons.calendar_today,
                                  '${_formatDate(project.startDate)} - ${_formatDate(project.endDate)}',
                                ),
                                if (project.description.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  _buildInfoRow(
                                      Icons.description, project.description,
                                      maxLines: 1),
                                ],
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.person,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        managerNames.isNotEmpty
                                            ? managerNames.join(', ')
                                            : 'No Project Manager Assigned',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
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
    return Chip(
      label: Text(
        status,
        style: TextStyle(
          color: _getStatusTextColor(status),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      backgroundColor: _getStatusColor(status),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green.shade100;
      case 'completed':
        return Colors.blue.shade100;
      case 'archived':
        return Colors.grey.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green.shade800;
      case 'completed':
        return Colors.blue.shade800;
      case 'archived':
        return Colors.grey.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  Future<List<String>> _getProjectManagerNames(List<String> managerIds) async {
    // TODO: Optimize with caching if needed
    if (managerIds.isEmpty) return [];
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: managerIds)
        .get();
    return usersSnapshot.docs
        .map((doc) => doc.data()['name'] as String? ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

  Future<bool> _hasLowStock(String projectId) async {
    final bomItems = await _bomService.getProjectBoM(projectId).first;
    return bomItems.any((item) => item.isLowStock);
  }

  Widget _buildLowStockAlert() {
    return Tooltip(
      message: 'Low stock on one or more materials',
      child: Icon(Icons.warning, color: Colors.red.shade700, size: 20),
    );
  }
}
