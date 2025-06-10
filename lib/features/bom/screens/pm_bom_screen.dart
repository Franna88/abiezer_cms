import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/project_provider.dart';
import '../../../models/project_model.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/responsive.dart';
import '../widgets/no_projects_view.dart';
import '../../../widgets/common/project_card.dart';

class PMBoMScreen extends StatefulWidget {
  const PMBoMScreen({Key? key}) : super(key: key);

  @override
  State<PMBoMScreen> createState() => _PMBoMScreenState();
}

class _PMBoMScreenState extends State<PMBoMScreen> {
  bool _isLoading = true;
  String? _error;
  int _selectedTabIndex = 0; // 0: Assigned, 1: All

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final projectProvider =
          Provider.of<ProjectProvider>(context, listen: false);
      if (userProvider.user != null) {
        await projectProvider.fetchUserProjects(userProvider.user!);
        await projectProvider.fetchAllProjects();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
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
                _buildTabButton('Projects Assigned to Me', 0),
                const SizedBox(width: 8),
                _buildTabButton('All Projects', 1),
              ],
            ),
            const SizedBox(height: 24),

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
      child: Text(label,
          style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
    );
  }

  Widget _buildProjectGrid(
      List<ProjectModel> projects, List<String> assignedProjectIds) {
    if (projects.isEmpty) {
      return Center(
        child: Text(
          'No projects found.',
          style:
              const TextStyle(fontSize: 16, color: AppTheme.textSecondaryColor),
        ),
      );
    }
    final isMobile = Responsive.isMobile(context);
    final crossAxisCount = isMobile ? 1 : 3;
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 170,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        final isAssigned = assignedProjectIds.contains(project.id);
        // For demo, just use projectManagers as names (in real app, fetch names)
        final managerNames = project.projectManagers;
        return ProjectCard(
          project: project,
          isAssigned: isAssigned,
          managerNames: managerNames,
          onViewBOM: isAssigned
              ? () {
                  // TODO: Navigate to BOM details for this project
                }
              : null,
        );
      },
    );
  }
}
