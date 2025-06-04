import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/project_provider.dart';
import '../../../utils/responsive.dart';
import '../../../utils/app_theme.dart';
import '../widgets/bom_data_table.dart';
import '../widgets/bom_list_view.dart';
import '../widgets/usage_log_form.dart';
import '../widgets/material_request_form.dart';
import '../widgets/no_projects_view.dart';

class PMBoMScreen extends StatefulWidget {
  const PMBoMScreen({Key? key}) : super(key: key);

  @override
  State<PMBoMScreen> createState() => _PMBoMScreenState();
}

class _PMBoMScreenState extends State<PMBoMScreen> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      final projectProvider = Provider.of<ProjectProvider>(
        context,
        listen: false,
      );
      await projectProvider.loadAssignedProjects();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    final currentProject = projectProvider.selectedProject;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Bill of Materials',
              style: isMobile ? AppTheme.titleStyle : AppTheme.headingStyle,
            ),
            const SizedBox(height: 24),

            // Loading State
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Center(
                child: Text(
                  'Error: $_error',
                  style: const TextStyle(color: AppTheme.errorColor),
                ),
              )
            // No Projects State
            else if (projectProvider.assignedProjects.isEmpty)
              const NoProjectsView()
            // Main Content
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Selection
                      if (currentProject != null) ...[
                        Text(
                          'Project: ${currentProject.name}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // BoM Table/List
                        isMobile ? const BoMListView() : const BoMDataTable(),

                        const SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _showUsageLogForm(),
                                icon: const Icon(Icons.edit),
                                label: const Text('Log Usage'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(48),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _showMaterialRequestForm(),
                                icon: const Icon(Icons.add_shopping_cart),
                                label: const Text('Request Material'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(48),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showUsageLogForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const UsageLogForm(),
    );
  }

  void _showMaterialRequestForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const MaterialRequestForm(),
    );
  }
}
