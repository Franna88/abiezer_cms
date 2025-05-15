import 'package:flutter/material.dart';
import '../../core/models/project_model.dart';
import '../../core/models/user_model.dart';
import '../../core/theme/color_theme.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utilities/constants.dart';
import '../../core/utilities/utilities.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/responsive_layout.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/status_badge.dart';
import 'project_details_screen.dart';
import 'widgets/project_card.dart';
import 'widgets/project_filter_bar.dart';
import 'widgets/create_project_dialog.dart';

class ProjectsScreen extends StatefulWidget {
  final UserModel currentUser;

  const ProjectsScreen({super.key, required this.currentUser});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  bool _isLoading = false;
  String _searchQuery = '';
  String _statusFilter = 'All';
  String _sortBy = 'Created Date';
  bool _showMyProjectsOnly = false;

  // Dummy data for projects
  final List<ProjectModel> _projects = [
    ProjectModel(
      id: '1',
      name: 'Central Square Development',
      description:
          'Mixed-use development with residential and commercial spaces',
      location: 'Johannesburg CBD',
      clientName: 'Metroplex Developments',
      clientContact: 'contact@metroplex.co.za',
      startDate: DateTime.now().subtract(const Duration(days: 90)),
      status: AppConstants.projectStatusActive,
      assignedUsers: ['2', '3', '4'],
      projectManagerId: '2',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    ProjectModel(
      id: '2',
      name: 'Riverside Apartments',
      description: 'Luxury apartment complex with 120 units',
      location: 'Cape Town',
      clientName: 'Coastal Properties',
      clientContact: 'info@coastalproperties.co.za',
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      status: AppConstants.projectStatusActive,
      assignedUsers: ['2', '5'],
      projectManagerId: '2',
      createdAt: DateTime.now().subtract(const Duration(days: 75)),
      updatedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    ProjectModel(
      id: '3',
      name: 'Greenfields Office Park',
      description: 'Modern office complex with 5 buildings',
      location: 'Pretoria',
      clientName: 'Business Capital Ltd',
      clientContact: 'projects@businesscapital.co.za',
      startDate: DateTime.now().subtract(const Duration(days: 240)),
      endDate: DateTime.now().subtract(const Duration(days: 30)),
      status: AppConstants.projectStatusCompleted,
      assignedUsers: ['3', '6'],
      projectManagerId: '3',
      createdAt: DateTime.now().subtract(const Duration(days: 280)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    ProjectModel(
      id: '4',
      name: 'Mountain View Villas',
      description: 'Exclusive development with 25 luxury villas',
      location: 'Stellenbosch',
      clientName: 'Premier Estates',
      clientContact: 'sales@premierestates.co.za',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      status: AppConstants.projectStatusPending,
      assignedUsers: ['5'],
      projectManagerId: '5',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    ProjectModel(
      id: '5',
      name: 'Downtown Renovation',
      description: 'Restoration of historic building for mixed use',
      location: 'Durban',
      clientName: 'Heritage Group',
      clientContact: 'operations@heritagegroup.co.za',
      startDate: DateTime.now().subtract(const Duration(days: 150)),
      status: AppConstants.projectStatusCanceled,
      assignedUsers: ['4'],
      projectManagerId: '4',
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      updatedAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
  ];

  // Filter projects based on search query, status filter, and user role
  List<ProjectModel> get _filteredProjects {
    // Start with all projects for admin, or only assigned projects for project managers
    List<ProjectModel> filtered =
        widget.currentUser.isAdmin
            ? _projects
            : _projects
                .where(
                  (project) =>
                      project.assignedUsers.contains(widget.currentUser.id) ||
                      project.projectManagerId == widget.currentUser.id,
                )
                .toList();

    // Apply "My Projects Only" filter for admins
    if (widget.currentUser.isAdmin && _showMyProjectsOnly) {
      filtered =
          filtered
              .where(
                (project) =>
                    project.assignedUsers.contains(widget.currentUser.id) ||
                    project.projectManagerId == widget.currentUser.id,
              )
              .toList();
    }

    // Apply status filter
    if (_statusFilter != 'All') {
      filtered =
          filtered
              .where(
                (project) => project.status == _getStatusValue(_statusFilter),
              )
              .toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (project) =>
                    project.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    project.location.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    (project.clientName != null &&
                        project.clientName!.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        )),
              )
              .toList();
    }

    // Apply sorting
    if (_sortBy == 'Name') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortBy == 'Location') {
      filtered.sort((a, b) => a.location.compareTo(b.location));
    } else if (_sortBy == 'Status') {
      filtered.sort((a, b) => a.status.compareTo(b.status));
    } else if (_sortBy == 'Start Date') {
      filtered.sort((a, b) => a.startDate.compareTo(b.startDate));
    } else {
      // Default: Created Date
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return filtered;
  }

  String _getStatusValue(String displayStatus) {
    switch (displayStatus) {
      case 'Active':
        return AppConstants.projectStatusActive;
      case 'Completed':
        return AppConstants.projectStatusCompleted;
      case 'Pending':
        return AppConstants.projectStatusPending;
      case 'Canceled':
        return AppConstants.projectStatusCanceled;
      default:
        return '';
    }
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _handleStatusFilter(String status) {
    setState(() {
      _statusFilter = status;
    });
  }

  void _handleSortChange(String sortBy) {
    setState(() {
      _sortBy = sortBy;
    });
  }

  void _toggleMyProjectsFilter() {
    setState(() {
      _showMyProjectsOnly = !_showMyProjectsOnly;
    });
  }

  Future<void> _showCreateProjectDialog() async {
    if (!widget.currentUser.canCreateProjects) {
      _showPermissionDeniedMessage();
      return;
    }

    final result = await showDialog<ProjectModel>(
      context: context,
      builder: (context) => const CreateProjectDialog(),
    );

    if (result != null) {
      // In a real app, you would create the project in the backend
      // For now, we'll just add it to our list
      setState(() {
        _projects.add(result);
      });
    }
  }

  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You do not have permission to perform this action.'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _viewProjectDetails(String projectId) {
    // Navigate to project details screen using named route
    Navigator.pushNamed(
      context,
      AppConstants.routeProjectDetails,
      arguments: {
        'projectId': projectId,
        'isProjectManager': widget.currentUser.isProjectManager,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        ProjectFilterBar(
          onSearch: _handleSearch,
          onStatusFilterChanged: _handleStatusFilter,
          onSortChanged: _handleSortChange,
          showMyProjectsToggle: widget.currentUser.isAdmin,
          myProjectsOnly: _showMyProjectsOnly,
          onMyProjectsToggled: _toggleMyProjectsFilter,
        ),
        if (widget.currentUser.isAdmin) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _showCreateProjectDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Project'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        Expanded(
          child:
              _isLoading
                  ? const Center(child: LoadingIndicator())
                  : _buildProjectsList(),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DashboardSectionHeader(
                  title: 'Projects',
                  subtitle: 'Manage all construction projects',
                ),
              ),
              if (widget.currentUser.isAdmin)
                ElevatedButton.icon(
                  onPressed: _showCreateProjectDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Project'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ProjectFilterBar(
            onSearch: _handleSearch,
            onStatusFilterChanged: _handleStatusFilter,
            onSortChanged: _handleSortChange,
            showMyProjectsToggle: widget.currentUser.isAdmin,
            myProjectsOnly: _showMyProjectsOnly,
            onMyProjectsToggled: _toggleMyProjectsFilter,
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: LoadingIndicator())
                    : _buildProjectsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DashboardSectionHeader(
                  title: 'Projects',
                  subtitle: 'Manage all construction projects',
                ),
              ),
              if (widget.currentUser.isAdmin)
                ElevatedButton.icon(
                  onPressed: _showCreateProjectDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Project'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          ProjectFilterBar(
            onSearch: _handleSearch,
            onStatusFilterChanged: _handleStatusFilter,
            onSortChanged: _handleSortChange,
            showMyProjectsToggle: widget.currentUser.isAdmin,
            myProjectsOnly: _showMyProjectsOnly,
            onMyProjectsToggled: _toggleMyProjectsFilter,
          ),
          const SizedBox(height: 24),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: LoadingIndicator())
                    : _buildProjectsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList() {
    if (_filteredProjects.isEmpty) {
      return EmptyState(
        icon: Icons.business_outlined,
        title: 'No Projects Found',
        message:
            _searchQuery.isNotEmpty
                ? 'No projects match your search criteria'
                : widget.currentUser.isAdmin
                ? 'Get started by creating your first project'
                : 'You have no assigned projects yet',
        buttonText: widget.currentUser.isAdmin ? 'Create Project' : null,
        onButtonPressed:
            widget.currentUser.isAdmin ? _showCreateProjectDialog : null,
      );
    }

    return ResponsiveLayout(
      mobile: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: _filteredProjects.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ProjectCard(
              project: _filteredProjects[index],
              onTap: () => _viewProjectDetails(_filteredProjects[index].id),
              isAdmin: widget.currentUser.isAdmin,
              isAssigned:
                  _filteredProjects[index].assignedUsers.contains(
                    widget.currentUser.id,
                  ) ||
                  _filteredProjects[index].projectManagerId ==
                      widget.currentUser.id,
            ),
          );
        },
      ),
      tablet: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredProjects.length,
        itemBuilder: (context, index) {
          return ProjectCard(
            project: _filteredProjects[index],
            onTap: () => _viewProjectDetails(_filteredProjects[index].id),
            isAdmin: widget.currentUser.isAdmin,
            isAssigned:
                _filteredProjects[index].assignedUsers.contains(
                  widget.currentUser.id,
                ) ||
                _filteredProjects[index].projectManagerId ==
                    widget.currentUser.id,
          );
        },
      ),
      desktop: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
        ),
        itemCount: _filteredProjects.length,
        itemBuilder: (context, index) {
          return ProjectCard(
            project: _filteredProjects[index],
            onTap: () => _viewProjectDetails(_filteredProjects[index].id),
            isAdmin: widget.currentUser.isAdmin,
            isAssigned:
                _filteredProjects[index].assignedUsers.contains(
                  widget.currentUser.id,
                ) ||
                _filteredProjects[index].projectManagerId ==
                    widget.currentUser.id,
          );
        },
      ),
    );
  }
}
