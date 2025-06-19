import 'package:abiezer_cms/models/project.dart';
import 'package:abiezer_cms/services/user_service.dart';
import 'package:abiezer_cms/widgets/dashboard/activity_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/project_provider.dart';
import '../../../models/project_model.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/responsive.dart';
import '../widgets/no_projects_view.dart';
import '../../../widgets/common/project_card.dart';
import '../../../widgets/common/search_field.dart';

class PMBoMScreen extends StatefulWidget {
  const PMBoMScreen({Key? key}) : super(key: key);

  @override
  State<PMBoMScreen> createState() => _PMBoMScreenState();
}

class _PMBoMScreenState extends State<PMBoMScreen> {
  String? _error;
  int _selectedTabIndex = 0; // 0: Assigned, 1: All
  Project? project;
  bool _isLoading = false;
  bool _hasLoadedData = false; // Flag to prevent multiple loads
  List<String> _projectManagerNames = [];
  List<ActivityItem> _activities = [];
  final UserService _userService = UserService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';
  String? _selectedStatus; // e.g., 'Active', 'Completed', etc.

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);

    if (userProvider.user != null) {
      await projectProvider.fetchUserProjects(userProvider.user!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);
    if (projectProvider.allProjects.isEmpty) {
      projectProvider.fetchAllProjects();
    }
    // Get project from route arguments safely
    if (project == null) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null && arguments is Project) {
        project = arguments;

        // Load data only once and only after project is available
        if (!_hasLoadedData) {
          _hasLoadedData = true;
          _loadData();
        }
      } else {
        // Handle case where no valid project is passed
        print('Warning: No valid Project passed to ProjectDetailsScreen');
      }
    }
  }

  Future<void> _loadData() async {
    if (project == null) return; // Safety check

    setState(() => _isLoading = true);

    // Load project manager names separately with its own error handling
    try {
      // Debug: Print project manager IDs
      print('Project: ${project!.name}');
      print('Project Manager IDs: ${project!.projectManagerIds}');
      print('Number of manager IDs: ${project!.projectManagerIds.length}');

      // Load project manager names
      final managerNames =
          await _userService.getUserNamesByIds(project!.projectManagerIds);
      print('Loaded manager names: $managerNames');
      setState(() => _projectManagerNames = managerNames);
    } catch (e) {
      print('Error loading project manager names: $e');
      if (mounted) {
        setState(() {
          _projectManagerNames = ['Error: Failed to load manager names'];
        });
      }
    }

    // Load recent activities separately with its own error handling
    try {
      final activitiesSnapshot = await _firestore
          .collection('project_activities')
          .where('projectId', isEqualTo: project!.id)
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();

      final activities = activitiesSnapshot.docs.map((doc) {
        final data = doc.data();
        return ActivityItem(
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          time: _formatTimestamp(data['timestamp'] as Timestamp),
          icon: _getActivityIcon(data['type'] ?? ''),
          color: _getActivityColor(data['type'] ?? ''),
        );
      }).toList();

      setState(() => _activities = activities);
    } catch (e) {
      print(
          'Error loading project activities (likely missing Firestore index): $e');
      // Don't override project manager names - just set empty activities
      if (mounted) {
        setState(() {
          _activities = [];
        });
      }
    }

    setState(() => _isLoading = false);
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'material_request':
        return Icons.inventory_2_outlined;
      case 'bom_update':
        return Icons.edit_note;
      case 'status_change':
        return Icons.update;
      case 'manager_assignment':
        return Icons.person_add;
      default:
        return Icons.info_outline;
    }
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'material_request':
        return AppTheme.primaryColor;
      case 'bom_update':
        return AppTheme.infoColor;
      case 'status_change':
        return AppTheme.warningColor;
      case 'manager_assignment':
        return AppTheme.successColor;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: SearchField(
              onChanged: (query) => setState(() => _searchQuery = query),
              hintText: 'Search projects by name or ID...',
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String?>(
            value: _selectedStatus,
            hint: const Text('Status'),
            items: [
              const DropdownMenuItem(value: null, child: Text('All Statuses')),
              ...['Active', 'Completed', 'On-Hold', 'Cancelled'].map(
                (status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _selectedStatus = value),
          ),
        ],
      ),
    );
  }

  List<ProjectModel> _filterProjects(List<ProjectModel> projects) {
    return projects.where((project) {
      final matchesQuery = _searchQuery.isEmpty ||
          project.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          project.id.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == null ||
          project.status.toLowerCase() == _selectedStatus!.toLowerCase();
      return matchesQuery && matchesStatus;
    }).toList();
  }

  Widget _buildQuickActions(ProjectModel project) {
    final isMobile = Responsive.isMobile(context);
    final buttonMinHeight = 44.0;
    final buttonFontSize = 15.0;
    final buttonIconSize = 20.0;
    final buttonSpacing = 8.0;

    String getLabel(String full, String short) =>
        isMobile && full.length > 7 ? short : full;

    final buttons = [
      Expanded(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(
            context,
            '/pm/project-details',
            arguments: project,
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(0, buttonMinHeight),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.list_alt, size: buttonIconSize),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    getLabel('View BoM', 'BoM'),
                    style: TextStyle(fontSize: buttonFontSize),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
          width: isMobile ? 0 : buttonSpacing,
          height: isMobile ? buttonSpacing : 0),
      Expanded(
        child: ElevatedButton(
          onPressed: () {/* TODO: Implement log usage flow */},
          style: ElevatedButton.styleFrom(
            minimumSize: Size(0, buttonMinHeight),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, size: buttonIconSize),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    getLabel('Log Usage', 'Usage'),
                    style: TextStyle(fontSize: buttonFontSize),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
          width: isMobile ? 0 : buttonSpacing,
          height: isMobile ? buttonSpacing : 0),
      Expanded(
        child: ElevatedButton(
          onPressed: () {/* TODO: Implement request material flow */},
          style: ElevatedButton.styleFrom(
            minimumSize: Size(0, buttonMinHeight),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_shopping_cart, size: buttonIconSize),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    getLabel('Request', 'Req'),
                    style: TextStyle(fontSize: buttonFontSize),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buttons,
            )
          : Row(
              children: buttons,
            ),
    );
  }

  Widget _buildLowStockBadge() {
    return const Padding(
      padding: EdgeInsets.only(left: 4.0),
      child: Icon(Icons.warning, color: Colors.red, size: 20),
    );
  }

  Widget _buildProjectGrid(
      List<ProjectModel> projects, List<String> assignedProjectIds) {
    final isMobile = Responsive.isMobile(context);
    final crossAxisCount =
        isMobile ? 1 : (Responsive.isTablet(context) ? 2 : 3);
    final spacing = isMobile ? 8.0 : 16.0;

    final filteredProjects = _filterProjects(projects);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.5,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: filteredProjects.length,
      itemBuilder: (context, index) {
        final project = filteredProjects[index];
        final isAssigned = assignedProjectIds.contains(project.id);
        return ProjectCard(
          project: project,
          isAssigned: isAssigned,
          managerNames: project.projectManagers,
          onTap: isAssigned
              ? () {
                  Navigator.pushNamed(
                    context,
                    '/pm/project-details',
                    arguments: project,
                  );
                }
              : null,
          quickActions: isAssigned ? _buildQuickActions(project) : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);
    final userProvider = Provider.of<UserProvider>(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    final assignedProjects = projectProvider.userProjects;
    final allProjects = projectProvider.allProjects;
    final assignedProjectIds = userProvider.user?.assignedProjects ?? [];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(
          Responsive.getResponsiveValue(
            context: context,
            mobile: 8.0,
            tablet: 24.0,
            desktop: 32.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Bill of Materials',
              style: isMobile ? AppTheme.titleStyle : AppTheme.headingStyle,
            ),
            const SizedBox(height: 16),

            // Tabs for switching between Assigned and All Projects
            Row(
              children: [
                _buildTabButton('View ', 0),
                const SizedBox(width: 8),
                _buildTabButton('View All Projects', 1),
              ],
            ),
            const SizedBox(height: 24),

            // Search/Filter Bar
            _buildSearchBar(),

            // Loading/Error/Content
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Center(
                child: Text(
                  'Error: $_error',
                  style: const TextStyle(color: AppTheme.errorColor),
                ),
              )
            else if (_selectedTabIndex == 0 && assignedProjects.isEmpty)
              const Expanded(child: NoProjectsView())
            else
              Expanded(
                child: _selectedTabIndex == 0
                    ? _buildProjectGrid(assignedProjects, assignedProjectIds)
                    : _buildProjectGrid(allProjects, assignedProjectIds),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppTheme.primaryColor : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        elevation: isSelected ? 2 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(label),
    );
  }
}
