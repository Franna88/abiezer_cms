import 'package:flutter/material.dart';
import '../../core/models/bill_of_materials_model.dart';
import '../../core/models/project_model.dart';
import '../../core/models/user_model.dart';
import '../../core/models/material_model.dart';
import '../../core/theme/color_theme.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utilities/constants.dart';
import '../../core/utilities/utilities.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/responsive_layout.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/status_badge.dart';
import '../../features/bom/create_bom_screen.dart';
import '../../features/bom/widgets/mark_used_dialog.dart';
import 'widgets/project_action_button.dart';
import 'widgets/project_info_card.dart';
import 'widgets/project_status_update_dialog.dart';
import 'widgets/project_team_card.dart';
import 'widgets/project_tabs.dart';

// Within the file, add Utils class before the class definitions

// Utility class for common formatting functions
class Utils {
  static String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  static String formatCurrency(double amount) {
    return 'R ${amount.toStringAsFixed(2)}';
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }
}

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;
  final UserModel currentUser;

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
    required this.currentUser,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late ProjectModel _project;
  BillOfMaterialsModel? _projectBom;

  @override
  void initState() {
    super.initState();
    _loadProjectDetails();
  }

  Future<void> _loadProjectDetails() async {
    // In a real app, this would fetch the project details from a backend service
    // For now, we'll just simulate a loading delay and use dummy data
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    // Find the project in our dummy data by ID
    _project = _getDummyProject(widget.projectId);

    // Load bill of materials if it exists
    _loadProjectBom();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadProjectBom() async {
    // In a real app, this would fetch the BOM from a backend service
    // For now, we'll just simulate a loading delay and use dummy data
    await Future.delayed(const Duration(milliseconds: 500));

    // Only set BOM for certain projects to simulate that some projects don't have a BOM yet
    if (widget.projectId == '1' || widget.projectId == '2') {
      _projectBom = _getDummyBom(widget.projectId);
    }
  }

  // This would be replaced with a real API call in a production app
  ProjectModel _getDummyProject(String id) {
    return ProjectModel(
      id: id,
      name: 'Central Square Development',
      description:
          'Mixed-use development with residential and commercial spaces in downtown area with high-end finishes. The project includes retail spaces on the ground floor, office spaces on levels 1-3, and residential apartments on the upper floors.',
      location: 'Johannesburg CBD',
      clientName: 'Metroplex Developments',
      clientContact: 'contact@metroplex.co.za',
      startDate: DateTime.now().subtract(const Duration(days: 90)),
      endDate:
          id == '3' ? DateTime.now().subtract(const Duration(days: 30)) : null,
      status:
          id == '3'
              ? AppConstants.projectStatusCompleted
              : id == '4'
              ? AppConstants.projectStatusPending
              : id == '5'
              ? AppConstants.projectStatusCanceled
              : AppConstants.projectStatusActive,
      assignedUsers: ['2', '3', '4'],
      projectManagerId: '2',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  // This would be replaced with a real API call in a production app
  BillOfMaterialsModel _getDummyBom(String projectId) {
    return BillOfMaterialsModel(
      id: 'bom-$projectId',
      projectId: projectId,
      items: [
        BomItemModel(
          id: '1',
          material: MaterialModel(
            id: '1',
            name: 'Cement',
            category: 'Cement & Aggregates',
            unitOfMeasure: 'Bag',
            unitPrice: 85.0,
            isActive: true,
            status: 'new',
            createdAt: DateTime.now().subtract(const Duration(days: 90)),
            updatedAt: DateTime.now().subtract(const Duration(days: 90)),
          ),
          quantity: 120,
          usedQuantity: 68,
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
          updatedAt: DateTime.now().subtract(const Duration(days: 45)),
        ),
        BomItemModel(
          id: '2',
          material: MaterialModel(
            id: '2',
            name: 'Hardboard',
            category: 'Boards & Sheets',
            unitOfMeasure: 'Sheet',
            unitPrice: 145.0,
            isActive: true,
            status: 'new',
            createdAt: DateTime.now().subtract(const Duration(days: 90)),
            updatedAt: DateTime.now().subtract(const Duration(days: 90)),
          ),
          quantity: 50,
          usedQuantity: 42,
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
          updatedAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ],
      totalCost: 120 * 85.0 + 50 * 145.0,
      createdBy: '1', // Admin user ID
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  void _handleStatusUpdate() async {
    // Only admin can update project status
    if (!widget.currentUser.isAdmin) {
      _showPermissionDeniedMessage();
      return;
    }

    final result = await showDialog<String>(
      context: context,
      builder:
          (context) =>
              ProjectStatusUpdateDialog(currentStatus: _project.status),
    );

    if (result != null) {
      // In a real app, this would update the project status on the backend
      setState(() {
        _project = _project.copyWith(status: result);
      });
    }
  }

  void _handleAssignTeam() {
    // Only admin can assign team members
    if (!widget.currentUser.isAdmin) {
      _showPermissionDeniedMessage();
      return;
    }

    // In a real app, this would open a dialog to assign team members
    // For now, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Team assignment functionality will be implemented soon.',
        ),
      ),
    );
  }

  void _handleMarkComplete() {
    if (!widget.currentUser.canMarkProjectComplete) {
      _showPermissionDeniedMessage();
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Mark Project Complete'),
            content: const Text(
              'Are you sure you want to mark this project as complete? '
              'This will identify all remaining materials as leftover and make them '
              'available for other projects.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // In a real app, this would update the project status on the backend
                  Navigator.pop(context);
                  setState(() {
                    _project = _project.copyWith(
                      status: AppConstants.projectStatusCompleted,
                      endDate: DateTime.now(),
                    );

                    // Process leftover materials
                    if (_projectBom != null) {
                      // In a real app, this would:
                      // 1. Get all materials with remaining quantity
                      // 2. Mark them as leftover
                      // 3. Make them available for other projects
                      final leftoverMaterials =
                          _projectBom!.getLeftoverMaterials();
                      print('Leftover materials: ${leftoverMaterials.length}');
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Project marked as complete'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
  }

  void _handleExportReports() {
    // In a real app, this would generate reports for the project
    // For now, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report export functionality will be implemented soon.'),
      ),
    );
  }

  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You do not have permission to perform this action.'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  // Helper method for safe back navigation
  void _navigateBack() {
    // Instead of trying to pop or replace, let's navigate to the dashboard with the projects tab selected
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppConstants.routeDashboard,
      (route) => false, // Remove all previous routes
      arguments: {
        'selectedIndex': 1, // Index of the Projects tab
        'isProjectManager': widget.currentUser.isProjectManager,
      },
    );
  }

  void _navigateToBom() {
    // Instead of navigating to a general BoM route, we'll create a detailed BoM view for this specific project
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => _BillOfMaterialsScreen(
              projectId: widget.projectId,
              project: _project,
              projectBom: _projectBom,
              currentUser: widget.currentUser,
              onBomUpdated: (updatedBom) {
                setState(() {
                  _projectBom = updatedBom;
                });
              },
            ),
      ),
    );
  }

  void _navigateToPurchases() {
    // Navigate to a dedicated purchases screen for this project
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => _PurchasesScreen(
              projectId: widget.projectId,
              project: _project,
              currentUser: widget.currentUser,
            ),
      ),
    );
  }

  void _navigateToHistory() {
    // Navigate to a dedicated history screen for this project
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => _HistoryScreen(
              projectId: widget.projectId,
              project: _project,
              currentUser: widget.currentUser,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Handle system back button/gesture
      onWillPop: () async {
        _navigateBack();
        return false;
      },
      child: Material(
        // Ensure there's always a Material ancestor
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBar(
            title: const Text('Project Details'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back to Projects',
              onPressed: _navigateBack,
              splashRadius: 24,
            ),
          ),
          body:
              _isLoading
                  ? const Center(child: LoadingIndicator())
                  : ResponsiveLayout(
                    mobile: _buildMobileLayout(),
                    tablet: _buildTabletLayout(),
                    desktop: _buildDesktopLayout(),
                  ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildProjectHeader(),
          const SizedBox(height: 16),
          _buildProjectActions(),
          const SizedBox(height: 16),
          _buildNavigationButtons(),
          const SizedBox(height: 16),
          ProjectTeamCard(
            project: _project,
            currentUser: widget.currentUser,
            onAssignTeam: _handleAssignTeam,
          ),
          const SizedBox(height: 16),
          _buildKeyDetailsSection(),
          const SizedBox(height: 32),
          const DashboardSectionHeader(
            title: 'Project Statistics',
            hasDivider: true,
          ),
          const SizedBox(height: 16),
          _buildProjectStatisticsEnhanced(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column - project details
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProjectHeader(),
                    const SizedBox(height: 24),
                    _buildKeyDetailsSection(),
                    const SizedBox(height: 32),
                    const DashboardSectionHeader(
                      title: 'Project Statistics',
                      hasDivider: true,
                    ),
                    const SizedBox(height: 16),
                    _buildProjectStatisticsEnhanced(),
                  ],
                ),
              ),

              // Right column - actions, navigation and team
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildProjectActions(),
                    const SizedBox(height: 24),
                    _buildNavigationButtons(),
                    const SizedBox(height: 24),
                    ProjectTeamCard(
                      project: _project,
                      currentUser: widget.currentUser,
                      onAssignTeam: _handleAssignTeam,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column - project details
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProjectHeader(),
                    const SizedBox(height: 24),
                    _buildKeyDetailsSection(),
                    const SizedBox(height: 32),
                    const DashboardSectionHeader(
                      title: 'Project Statistics',
                      hasDivider: true,
                    ),
                    const SizedBox(height: 16),
                    _buildProjectStatisticsEnhanced(),
                  ],
                ),
              ),

              // Right column - actions, navigation and team
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildProjectActions(),
                    const SizedBox(height: 24),
                    _buildNavigationButtons(),
                    const SizedBox(height: 24),
                    ProjectTeamCard(
                      project: _project,
                      currentUser: widget.currentUser,
                      onAssignTeam: _handleAssignTeam,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project Navigation', style: AppTextStyles.heading4),
            const SizedBox(height: 16),
            Column(
              children: [
                _buildNavigationButton(
                  icon: Icons.inventory_2_outlined,
                  label: 'Bill of Materials',
                  onTap: _navigateToBom,
                  primary: true,
                  fullWidth: true,
                ),
                const SizedBox(height: 12),
                _buildNavigationButton(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Purchases',
                  onTap: _navigateToPurchases,
                  fullWidth: true,
                ),
                const SizedBox(height: 12),
                _buildNavigationButton(
                  icon: Icons.history_outlined,
                  label: 'History',
                  onTap: _navigateToHistory,
                  fullWidth: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool primary = false,
    bool fullWidth = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: primary ? AppColors.primary : AppColors.secondary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: fullWidth ? const Size.fromHeight(48) : null,
      ),
    );
  }

  Widget _buildProjectHeader() {
    return ProjectInfoCard(
      project: _project,
      currentUser: widget.currentUser,
      onStatusUpdate: widget.currentUser.isAdmin ? _handleStatusUpdate : null,
      onEditDescription:
          widget.currentUser.isAdmin ? _handleEditProjectDescription : null,
    );
  }

  Widget _buildProjectActions() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Project Actions', style: AppTextStyles.heading4),
                const Spacer(),
                // Show user role badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        widget.currentUser.isAdmin
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.currentUser.isAdmin ? 'Admin' : 'Project Manager',
                    style: AppTextStyles.caption.copyWith(
                      color:
                          widget.currentUser.isAdmin
                              ? AppColors.primary
                              : AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                // Admin-only actions
                if (widget.currentUser.isAdmin) ...[
                  ProjectActionButton(
                    icon: Icons.group_add,
                    label: 'Assign Team',
                    onTap: _handleAssignTeam,
                    color: AppColors.secondary,
                  ),
                ],

                // General actions for both roles
                ProjectActionButton(
                  icon: Icons.description_outlined,
                  label: 'Export Reports',
                  onTap: _handleExportReports,
                  color: AppColors.info,
                ),
              ],
            ),

            if (_project.isActive && widget.currentUser.canMarkProjectComplete)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ProjectActionButton(
                  icon: Icons.task_alt,
                  label: 'Mark Project as Complete',
                  onTap: _handleMarkComplete,
                  color:
                      widget.currentUser.isProjectManager
                          ? AppColors.primary
                          : AppColors.warning,
                ),
              ),

            if (widget.currentUser.isProjectManager && _project.isActive)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.info, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'As a Project Manager, you can mark materials as used and mark the project as complete when construction is finished.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyDetailsSection() {
    // State variables for inline editing
    bool _isEditing = false;

    // Controllers for editable fields - only initialized when editing begins
    TextEditingController? _locationController;
    TextEditingController? _clientController;
    TextEditingController? _contactController;
    DateTime _startDate = _project.startDate;
    DateTime? _endDate = _project.endDate;

    return StatefulBuilder(
      builder: (context, setState) {
        // Initialize controllers when editing starts
        if (_isEditing && _locationController == null) {
          _locationController = TextEditingController(text: _project.location);
          _clientController = TextEditingController(
            text: _project.clientName ?? '',
          );
          _contactController = TextEditingController(
            text: _project.clientContact ?? '',
          );
          _startDate = _project.startDate;
          _endDate = _project.endDate;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const DashboardSectionHeader(
                  title: 'Key Details',
                  hasDivider: true,
                ),
                if (widget.currentUser.isAdmin)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        if (_isEditing) {
                          // Save changes
                          this.setState(() {
                            _project = _project.copyWith(
                              location: _locationController!.text.trim(),
                              clientName: _clientController!.text.trim(),
                              clientContact: _contactController!.text.trim(),
                              startDate: _startDate,
                              endDate: _endDate,
                              status:
                                  _endDate != null
                                      ? AppConstants.projectStatusCompleted
                                      : _project.status,
                              updatedAt: DateTime.now(),
                            );
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Project details updated successfully',
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }

                        // Toggle editing mode
                        _isEditing = !_isEditing;
                      });
                    },
                    icon: Icon(_isEditing ? Icons.save : Icons.edit, size: 16),
                    label: Text(_isEditing ? 'Save Changes' : 'Edit Details'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 1,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: AppColors.divider.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Location field - editable or read-only
                    _isEditing
                        ? _buildEditableField(
                          label: 'Location',
                          controller: _locationController!,
                          icon: Icons.location_on_outlined,
                        )
                        : _buildKeyDetailRowEnhanced(
                          'Location',
                          _project.location,
                          icon: Icons.location_on_outlined,
                        ),
                    const Divider(height: 24),

                    // Client field - editable or read-only
                    _isEditing
                        ? _buildEditableField(
                          label: 'Client',
                          controller: _clientController!,
                          icon: Icons.business_outlined,
                        )
                        : _project.clientName != null
                        ? _buildKeyDetailRowEnhanced(
                          'Client',
                          _project.clientName!,
                          icon: Icons.business_outlined,
                        )
                        : _buildKeyDetailRowEnhanced(
                          'Client',
                          'Not specified',
                          icon: Icons.business_outlined,
                        ),
                    const Divider(height: 24),

                    // Contact field - editable or read-only
                    _isEditing
                        ? _buildEditableField(
                          label: 'Contact',
                          controller: _contactController!,
                          icon: Icons.email_outlined,
                        )
                        : _project.clientContact != null
                        ? _buildKeyDetailRowEnhanced(
                          'Contact',
                          _project.clientContact!,
                          icon: Icons.email_outlined,
                        )
                        : _buildKeyDetailRowEnhanced(
                          'Contact',
                          'Not specified',
                          icon: Icons.email_outlined,
                        ),
                    const Divider(height: 24),

                    // Start Date field - editable or read-only
                    _isEditing
                        ? _buildDatePickerField(
                          label: 'Start Date',
                          value: _startDate,
                          icon: Icons.calendar_today_outlined,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _startDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              setState(() {
                                _startDate = date;
                              });
                            }
                          },
                        )
                        : _buildKeyDetailRowEnhanced(
                          'Start Date',
                          Utils.formatDate(_project.startDate),
                          icon: Icons.calendar_today_outlined,
                        ),
                    const Divider(height: 24),

                    // End Date field - editable or read-only
                    _isEditing
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.event_available_outlined,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 12),
                                const SizedBox(
                                  width: 120,
                                  child: Text(
                                    'End Date',
                                    style: AppTextStyles.label,
                                  ),
                                ),
                                Checkbox(
                                  value: _endDate != null,
                                  onChanged: (value) {
                                    setState(() {
                                      _endDate = value! ? DateTime.now() : null;
                                    });
                                  },
                                ),
                                Text(
                                  'Project Completed',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                            if (_endDate != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 32.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: _endDate!,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2030),
                                    );
                                    if (date != null) {
                                      setState(() {
                                        _endDate = date;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.divider,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(Utils.formatDate(_endDate!)),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                        : _project.endDate != null
                        ? _buildKeyDetailRowEnhanced(
                          'End Date',
                          Utils.formatDate(_project.endDate!),
                          icon: Icons.event_available_outlined,
                        )
                        : _buildKeyDetailRowEnhanced(
                          'End Date',
                          'Not set',
                          icon: Icons.event_available_outlined,
                        ),
                    const Divider(height: 24),

                    // Created date - always read-only
                    _buildKeyDetailRowEnhanced(
                      'Created',
                      Utils.formatDate(_project.createdAt),
                      icon: Icons.add_circle_outline,
                    ),
                    const Divider(height: 24),

                    // Last Updated date - always read-only
                    _buildKeyDetailRowEnhanced(
                      'Last Updated',
                      Utils.formatDate(_project.updatedAt),
                      icon: Icons.update_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper for editable text fields
  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: AppColors.divider),
              ),
            ),
            style: AppTextStyles.bodyMedium,
            keyboardType: keyboardType,
          ),
        ),
      ],
    );
  }

  // Helper for date picker fields
  Widget _buildDatePickerField({
    required String label,
    required DateTime value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Utils.formatDate(value)),
                  const Icon(Icons.calendar_today, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Enhanced detail row with icon and better layout
  Widget _buildKeyDetailRowEnhanced(
    String label,
    String value, {
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
        ],
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // Enhanced project statistics with improved cards
  Widget _buildProjectStatisticsEnhanced() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: Utils.isMobile(context) ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCardEnhanced(
          title: 'Total Materials',
          value: '45',
          icon: Icons.inventory_2_outlined,
          color: AppColors.primary,
        ),
        _buildStatCardEnhanced(
          title: 'Materials Used',
          value: '28',
          icon: Icons.check_circle_outline,
          color: AppColors.secondary,
        ),
        _buildStatCardEnhanced(
          title: 'Low Stock Items',
          value: '7',
          icon: Icons.warning_amber_outlined,
          color: AppColors.warning,
        ),
        _buildStatCardEnhanced(
          title: 'Total Purchases',
          value: '15',
          icon: Icons.shopping_cart_outlined,
          color: AppColors.info,
        ),
      ],
    );
  }

  // Enhanced stat card with icon and improved layout
  Widget _buildStatCardEnhanced({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: color),
                const Spacer(),
                Text(
                  value,
                  style: AppTextStyles.heading2.copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Handler for editing project description
  void _handleEditProjectDescription() {
    // Only allow admins to edit project description
    if (!widget.currentUser.isAdmin) {
      _showPermissionDeniedMessage();
      return;
    }

    TextEditingController descriptionController = TextEditingController(
      text: _project.description,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Project Description'),
            content: SizedBox(
              width: double.maxFinite,
              child: TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter project description',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // In a real app, this would update the project on the backend
                  setState(() {
                    _project = _project.copyWith(
                      description: descriptionController.text.trim(),
                      updatedAt: DateTime.now(),
                    );
                  });
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Project description updated successfully'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}

// Create a separate screen for Bill of Materials that reuses the previous BoM tab content
class _BillOfMaterialsScreen extends StatefulWidget {
  final String projectId;
  final ProjectModel project;
  final BillOfMaterialsModel? projectBom;
  final UserModel currentUser;
  final Function(BillOfMaterialsModel?) onBomUpdated;

  const _BillOfMaterialsScreen({
    required this.projectId,
    required this.project,
    required this.projectBom,
    required this.currentUser,
    required this.onBomUpdated,
  });

  @override
  State<_BillOfMaterialsScreen> createState() => _BillOfMaterialsScreenState();
}

class _BillOfMaterialsScreenState extends State<_BillOfMaterialsScreen> {
  BillOfMaterialsModel? _projectBom;

  @override
  void initState() {
    super.initState();
    _projectBom = widget.projectBom;
  }

  void _handleCreateBillOfMaterials() async {
    // Check if user has permission to create bill of materials
    if (!widget.currentUser.canCreateBillOfMaterials) {
      _showPermissionDeniedMessage();
      return;
    }

    final result = await Navigator.of(context).push<BillOfMaterialsModel>(
      MaterialPageRoute(
        builder:
            (context) => CreateBomScreen(
              projectId: widget.projectId,
              currentUser: widget.currentUser,
              existingBom: _projectBom,
            ),
        fullscreenDialog: true,
      ),
    );

    if (result != null) {
      setState(() {
        _projectBom = result;
      });
      // Pass the updated BoM back to the parent
      widget.onBomUpdated(result);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bill of Materials saved successfully.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _handleMarkMaterialsUsed() {
    // Check if user has permission to mark materials as used
    if (!widget.currentUser.canMarkMaterialsUsed) {
      _showPermissionDeniedMessage();
      return;
    }

    if (_projectBom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No Bill of Materials found for this project.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Show dialog to select which materials to mark as used
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Mark Materials as Used'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select a material to mark as used:'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _projectBom!.items.length,
                      itemBuilder: (context, index) {
                        final item = _projectBom!.items[index];
                        final material = item.material;

                        // Don't show materials that are completely used
                        if (item.remainingQuantity <= 0) {
                          return const SizedBox.shrink();
                        }

                        return ListTile(
                          title: Text(material.name),
                          subtitle: Text(
                            'Available: ${item.remainingQuantity.toStringAsFixed(2)} ${material.unitOfMeasure}',
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showMarkUsedDialog(item);
                            },
                            child: const Text('Mark Used'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _showMarkUsedDialog(BomItemModel item) async {
    final quantity = await showDialog<double>(
      context: context,
      builder: (context) => MarkUsedDialog(item: item),
    );

    if (quantity != null && quantity > 0) {
      // In a real app, this would update the used quantity on the backend
      setState(() {
        final updatedItems = List<BomItemModel>.from(_projectBom!.items);
        final itemIndex = updatedItems.indexWhere((i) => i.id == item.id);

        if (itemIndex != -1) {
          updatedItems[itemIndex] = updatedItems[itemIndex].markUsed(quantity);

          _projectBom = _projectBom!.copyWith(
            items: updatedItems,
            updatedAt: DateTime.now(),
          );

          // Pass the updated BoM back to the parent
          widget.onBomUpdated(_projectBom);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Marked ${quantity.toStringAsFixed(2)} ${item.material.unitOfMeasure} of ${item.material.name} as used',
          ),
          backgroundColor: AppColors.success,
        ),
      );
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

  Widget _buildBomItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BOM summary
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('BoM Summary', style: AppTextStyles.heading4),
                    Text(
                      'Created: ${Utils.formatDate(_projectBom!.createdAt)}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Items:'),
                    Text(
                      '${_projectBom!.itemCount}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Cost:'),
                    Text(
                      Utils.formatCurrency(_projectBom!.totalCost),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // BOM items list
        const SectionHeader(title: 'Materials'),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _projectBom!.items.length,
          itemBuilder: (context, index) {
            final item = _projectBom!.items[index];
            final material = item.material;
            final isLowStock = item.remainingQuantity / item.quantity <= 0.2;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            material.name,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${material.category} (${material.unitOfMeasure})',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unit Price: ${Utils.formatCurrency(material.unitPrice)}',
                            style: AppTextStyles.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text('Status: '),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isLowStock
                                          ? AppColors.warning.withOpacity(0.1)
                                          : AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  isLowStock ? 'Low Stock' : 'In Stock',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color:
                                        isLowStock
                                            ? AppColors.warning
                                            : AppColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total: ${item.quantity.toStringAsFixed(0)}',
                            style: AppTextStyles.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Used: ${item.usedQuantity.toStringAsFixed(0)}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Left: ${item.remainingQuantity.toStringAsFixed(0)}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  isLowStock
                                      ? AppColors.warning
                                      : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill of Materials: ${widget.project.name}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionHeader(title: 'Bill of Materials'),
                if (widget.project.isActive)
                  Row(
                    children: [
                      if (widget.currentUser.canCreateBillOfMaterials)
                        ElevatedButton.icon(
                          onPressed: _handleCreateBillOfMaterials,
                          icon: Icon(
                            _projectBom == null ? Icons.add : Icons.edit,
                          ),
                          label: Text(
                            _projectBom == null ? 'Create BoM' : 'Edit BoM',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                          ),
                        ),
                      if (widget.currentUser.canMarkMaterialsUsed &&
                          _projectBom != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: ElevatedButton.icon(
                            onPressed: _handleMarkMaterialsUsed,
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Mark Used'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            if (widget.project.status == AppConstants.projectStatusCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This project is marked as completed. Any remaining materials have been marked as leftover and are available for other projects.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            if (_projectBom == null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text('No Bill of Materials', style: AppTextStyles.heading3),
                    const SizedBox(height: 8),
                    Text(
                      widget.currentUser.isAdmin
                          ? 'This project does not have a Bill of Materials yet. Create one by clicking the button above.'
                          : 'This project does not have a Bill of Materials yet. Please ask an admin to create one.',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (widget.currentUser.canCreateBillOfMaterials)
                      ElevatedButton.icon(
                        onPressed: _handleCreateBillOfMaterials,
                        icon: const Icon(Icons.add),
                        label: const Text('Create Bill of Materials'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else
              _buildBomItems(),
          ],
        ),
      ),
    );
  }
}

// Purchases Screen for specific project
class _PurchasesScreen extends StatefulWidget {
  final String projectId;
  final ProjectModel project;
  final UserModel currentUser;

  const _PurchasesScreen({
    required this.projectId,
    required this.project,
    required this.currentUser,
  });

  @override
  State<_PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<_PurchasesScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _purchases = [];

  // Filter variables
  String? _selectedCategory;
  String? _selectedSupplier;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _searchController = TextEditingController();

  // Lists for dropdown options
  final List<String> _categories = [
    'Cement',
    'Steel',
    'Wood',
    'Paint',
    'Tools',
    'Other',
  ];

  final List<String> _suppliers = [
    'BuildIt Supplies',
    'Steel Dynamics',
    'Construction Warehouse',
    'Tools R Us',
    'Paint Masters',
    'Lumber Mill',
  ];

  final List<String> _paymentMethods = [
    'Cash',
    'Credit Card',
    'Bank Transfer',
    'Account',
  ];

  @override
  void initState() {
    super.initState();
    _loadPurchases();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPurchases() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock purchases data
    final List<Map<String, dynamic>> purchases = List.generate(15, (index) {
      final isApproved = index % 3 != 0;
      return {
        'id': 'P${widget.projectId}${index + 100}',
        'date': DateTime.now().subtract(Duration(days: index * 2)),
        'category': _categories[index % _categories.length],
        'product': 'Product ${index + 1}',
        'supplier': _suppliers[index % _suppliers.length],
        'quantity': (index + 1) * 2.5,
        'unit': index % 2 == 0 ? 'Kg' : 'L',
        'price': (index + 1) * 10.5,
        'total': (index + 1) * 10.5 * (index + 1) * 2.5,
        'paymentMethod': _paymentMethods[index % _paymentMethods.length],
        'status': isApproved ? 'Completed' : 'Pending Approval',
        'createdBy': 'John Doe',
        'hasProofOfPayment': isApproved,
      };
    });

    setState(() {
      _purchases = purchases;
      _isLoading = false;
    });
  }

  // Filtered purchases based on current filters
  List<Map<String, dynamic>> get _filteredPurchases {
    return _purchases.where((purchase) {
      // Filter by category if selected
      if (_selectedCategory != null &&
          purchase['category'] != _selectedCategory) {
        return false;
      }

      // Filter by supplier if selected
      if (_selectedSupplier != null &&
          purchase['supplier'] != _selectedSupplier) {
        return false;
      }

      // Filter by date range if set
      if (_startDate != null && purchase['date'].isBefore(_startDate!)) {
        return false;
      }

      if (_endDate != null &&
          purchase['date'].isAfter(_endDate!.add(const Duration(days: 1)))) {
        return false;
      }

      // Filter by search query
      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        return purchase['product'].toLowerCase().contains(query) ||
            purchase['supplier'].toLowerCase().contains(query) ||
            purchase['category'].toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }

  void _showAddPurchaseDialog() {
    showDialog(
      context: context,
      builder:
          (context) => _AddPurchaseDialog(
            categories: _categories,
            suppliers: _suppliers,
            paymentMethods: _paymentMethods,
            onAdd: (purchase) {
              setState(() {
                // Add current date and ID
                purchase['id'] =
                    'P${widget.projectId}${_purchases.length + 100}';
                purchase['date'] = DateTime.now();
                purchase['status'] = 'Pending Approval';
                purchase['createdBy'] = widget.currentUser.name;

                _purchases.insert(0, purchase);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Purchase added and sent for approval'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
    );
  }

  void _showPurchaseDetails(Map<String, dynamic> purchase) {
    showDialog(
      context: context,
      builder: (context) => _PurchaseDetailsDialog(purchase: purchase),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedSupplier = null;
      _startDate = null;
      _endDate = null;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchases for ${widget.project.name}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPurchaseDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildFilters(),
        Expanded(
          child:
              _filteredPurchases.isEmpty
                  ? _buildEmptyState()
                  : _buildPurchasesList(),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filters', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          Row(
            children: [
              // Search field
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search purchases...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Filter dropdown
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                  value: _selectedCategory,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All Categories'),
                    ),
                    ..._categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Supplier dropdown
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Supplier',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                  value: _selectedSupplier,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All Suppliers'),
                    ),
                    ..._suppliers.map((supplier) {
                      return DropdownMenuItem(
                        value: supplier,
                        child: Text(supplier),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSupplier = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Clear filters button
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasesList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.primary.withOpacity(0.05),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Product',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Supplier',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Total',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Date',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Status',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Actions column
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredPurchases.length,
                itemBuilder: (context, index) {
                  final purchase = _filteredPurchases[index];
                  return InkWell(
                    onTap: () => _showPurchaseDetails(purchase),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              '${purchase['product']}',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${purchase['supplier']}',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              Utils.formatCurrency(purchase['total']),
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              Utils.formatDate(purchase['date']),
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  purchase['status'],
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${purchase['status']}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: _getStatusColor(purchase['status']),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 48,
                            child: IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: AppColors.primary,
                              ),
                              onPressed: () => _showPurchaseDetails(purchase),
                              tooltip: 'View Details',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No purchases found', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty ||
                    _selectedCategory != null ||
                    _selectedSupplier != null
                ? 'Try adjusting your filters'
                : 'Add a new purchase to get started',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed:
                _searchController.text.isNotEmpty ||
                        _selectedCategory != null ||
                        _selectedSupplier != null
                    ? _clearFilters
                    : _showAddPurchaseDialog,
            icon: Icon(
              _searchController.text.isNotEmpty ||
                      _selectedCategory != null ||
                      _selectedSupplier != null
                  ? Icons.clear
                  : Icons.add,
            ),
            label: Text(
              _searchController.text.isNotEmpty ||
                      _selectedCategory != null ||
                      _selectedSupplier != null
                  ? 'Clear Filters'
                  : 'Add Purchase',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return AppColors.success;
      case 'Pending Approval':
        return AppColors.warning;
      case 'Denied':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }
}

// History Screen for specific project
class _HistoryScreen extends StatefulWidget {
  final String projectId;
  final ProjectModel project;
  final UserModel currentUser;

  const _HistoryScreen({
    required this.projectId,
    required this.project,
    required this.currentUser,
  });

  @override
  State<_HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<_HistoryScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _transactions = [];

  // Filter variables
  String? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _searchController = TextEditingController();

  // Transaction types for filtering
  final List<String> _transactionTypes = [
    'Purchase',
    'Delivery',
    'Payment',
    'Project Update',
    'User Assignment',
  ];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock transaction data
    final List<Map<String, dynamic>> transactions = [];

    // Add purchase history
    for (int i = 0; i < 5; i++) {
      transactions.add({
        'id': 'T${widget.projectId}${i + 100}',
        'date': DateTime.now().subtract(Duration(days: i * 3)),
        'type': 'Purchase',
        'description': 'Purchased 50kg Cement from Construction Warehouse',
        'amount': 750.00,
        'user': 'John Doe',
        'status': i % 3 == 0 ? 'Pending' : 'Completed',
        'icon': Icons.shopping_cart,
        'color': AppColors.secondary,
      });
    }

    // Add delivery history
    for (int i = 0; i < 3; i++) {
      transactions.add({
        'id': 'T${widget.projectId}${i + 200}',
        'date': DateTime.now().subtract(Duration(days: i * 2 + 1)),
        'type': 'Delivery',
        'description': 'Materials delivered to site',
        'amount': null,
        'user': 'Jane Smith',
        'status': 'Completed',
        'icon': Icons.local_shipping,
        'color': AppColors.info,
      });
    }

    // Add payment history
    for (int i = 0; i < 2; i++) {
      transactions.add({
        'id': 'T${widget.projectId}${i + 300}',
        'date': DateTime.now().subtract(Duration(days: i * 5 + 2)),
        'type': 'Payment',
        'description': 'Invoice payment to supplier',
        'amount': 1250.00,
        'user': 'Admin User',
        'status': 'Completed',
        'icon': Icons.payment,
        'color': AppColors.success,
      });
    }

    // Add project updates
    for (int i = 0; i < 4; i++) {
      transactions.add({
        'id': 'T${widget.projectId}${i + 400}',
        'date': DateTime.now().subtract(Duration(days: i * 4)),
        'type': 'Project Update',
        'description':
            'Project status updated to ${i % 2 == 0 ? "In Progress" : "On Hold"}',
        'amount': null,
        'user': 'Project Manager',
        'status': 'Completed',
        'icon': Icons.update,
        'color': AppColors.primary,
      });
    }

    // Sort by date (newest first)
    transactions.sort((a, b) => b['date'].compareTo(a['date']));

    setState(() {
      _transactions = transactions;
      _isLoading = false;
    });
  }

  // Filtered transactions based on current filters
  List<Map<String, dynamic>> get _filteredTransactions {
    return _transactions.where((transaction) {
      // Filter by type if selected
      if (_selectedType != null && transaction['type'] != _selectedType) {
        return false;
      }

      // Filter by date range if set
      if (_startDate != null && transaction['date'].isBefore(_startDate!)) {
        return false;
      }

      if (_endDate != null &&
          transaction['date'].isAfter(_endDate!.add(const Duration(days: 1)))) {
        return false;
      }

      // Filter by search query
      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        return transaction['description'].toLowerCase().contains(query) ||
            transaction['user'].toLowerCase().contains(query) ||
            transaction['type'].toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _selectedType = null;
      _startDate = null;
      _endDate = null;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History for ${widget.project.name}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildFilters(),
        Expanded(
          child:
              _filteredTransactions.isEmpty
                  ? _buildEmptyState()
                  : _buildTransactionsList(),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filters', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          Row(
            children: [
              // Search field
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search history...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Filter dropdown for transaction type
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                  value: _selectedType,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All Types'),
                    ),
                    ..._transactionTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Clear filters button
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = _filteredTransactions[index];

        // Show date headers when the date changes
        final showDateHeader =
            index == 0 ||
            !_isSameDay(
              transaction['date'],
              _filteredTransactions[index - 1]['date'],
            );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateHeader) _buildDateHeader(transaction['date']),
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: transaction['color'].withOpacity(0.2),
                  child: Icon(transaction['icon'], color: transaction['color']),
                ),
                title: Text(
                  transaction['description'],
                  style: AppTextStyles.bodyMedium,
                ),
                subtitle: Row(
                  children: [
                    Text(
                      transaction['user'],
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.circle,
                      size: 4,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(transaction['date']),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                trailing:
                    transaction['amount'] != null
                        ? Text(
                          Utils.formatCurrency(transaction['amount']),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            transaction['type'],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    String dateText;
    if (_isSameDay(date, now)) {
      dateText = 'Today';
    } else if (_isSameDay(date, yesterday)) {
      dateText = 'Yesterday';
    } else {
      dateText = Utils.formatDate(date);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Row(
        children: [
          Text(dateText, style: AppTextStyles.heading4),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No transactions found', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty || _selectedType != null
                ? 'Try adjusting your filters'
                : 'Project history will appear here',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          if (_searchController.text.isNotEmpty || _selectedType != null)
            ElevatedButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear),
              label: const Text('Clear Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

// Add Purchase Dialog
class _AddPurchaseDialog extends StatefulWidget {
  final List<String> categories;
  final List<String> suppliers;
  final List<String> paymentMethods;
  final Function(Map<String, dynamic>) onAdd;

  const _AddPurchaseDialog({
    required this.categories,
    required this.suppliers,
    required this.paymentMethods,
    required this.onAdd,
  });

  @override
  State<_AddPurchaseDialog> createState() => _AddPurchaseDialogState();
}

class _AddPurchaseDialogState extends State<_AddPurchaseDialog> {
  late String _category;
  late String _supplier;
  late String _paymentMethod;
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  bool _hasProofOfPayment = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _category = widget.categories.first;
    _supplier = widget.suppliers.first;
    _paymentMethod = widget.paymentMethods.first;
  }

  @override
  void dispose() {
    _productController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // Validate form
    if (_productController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _unitController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Check for proof of payment requirements
    if (!_hasProofOfPayment) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _paymentMethod == 'Account'
                ? 'Please upload a delivery note'
                : 'Please upload proof of payment',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Create purchase object
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;

    final purchase = {
      'category': _category,
      'product': _productController.text,
      'supplier': _supplier,
      'quantity': quantity,
      'unit': _unitController.text,
      'price': price,
      'total': quantity * price,
      'paymentMethod': _paymentMethod,
      'hasProofOfPayment': _hasProofOfPayment,
    };

    // Submit purchase
    widget.onAdd(purchase);
    Navigator.pop(context);
  }

  void _handleUpload() {
    setState(() {
      _isUploading = true;
    });

    // Simulate upload delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _hasProofOfPayment = true;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _paymentMethod == 'Account'
                ? 'Delivery note uploaded successfully'
                : 'Proof of payment uploaded successfully',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Purchase'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: _category,
                items:
                    widget.categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _productController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Supplier',
                  border: OutlineInputBorder(),
                ),
                value: _supplier,
                items:
                    widget.suppliers.map((supplier) {
                      return DropdownMenuItem(
                        value: supplier,
                        child: Text(supplier),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _supplier = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price per Unit',
                  border: OutlineInputBorder(),
                  prefixText: 'R ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                value: _paymentMethod,
                items:
                    widget.paymentMethods.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                    // Reset proof of payment when changing method
                    _hasProofOfPayment = false;
                  });
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _paymentMethod == 'Account'
                          ? 'Upload Delivery Note'
                          : 'Upload Proof of Payment',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _paymentMethod == 'Account'
                          ? 'Please upload a photo of the delivery note'
                          : 'Please upload a photo of the receipt',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    if (_hasProofOfPayment)
                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.success.withOpacity(0.3),
                          ),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                                size: 48,
                              ),
                              SizedBox(height: 8),
                              Text('Photo Uploaded'),
                            ],
                          ),
                        ),
                      )
                    else
                      _isUploading
                          ? const Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 8),
                                Text('Uploading...'),
                              ],
                            ),
                          )
                          : ElevatedButton.icon(
                            onPressed: _handleUpload,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Take Photo'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: const Text('Submit for Approval'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

// Purchase Details Dialog
class _PurchaseDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> purchase;

  const _PurchaseDetailsDialog({required this.purchase});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Purchase Details: ${purchase['product']}'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection(
                title: 'Purchase Information',
                items: [
                  _buildInfoItem('Product', purchase['product']),
                  _buildInfoItem('Category', purchase['category']),
                  _buildInfoItem('Supplier', purchase['supplier']),
                  _buildInfoItem(
                    'Quantity',
                    '${purchase['quantity']} ${purchase['unit']}',
                  ),
                  _buildInfoItem(
                    'Unit Price',
                    Utils.formatCurrency(purchase['price']),
                  ),
                  _buildInfoItem(
                    'Total',
                    Utils.formatCurrency(purchase['total']),
                  ),
                  _buildInfoItem('Payment Method', purchase['paymentMethod']),
                  _buildInfoItem('Status', purchase['status'], isStatus: true),
                ],
              ),
              const SizedBox(height: 24),
              _buildInfoSection(
                title: 'Additional Information',
                items: [
                  _buildInfoItem('Date', Utils.formatDate(purchase['date'])),
                  _buildInfoItem('Created By', purchase['createdBy']),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                purchase['paymentMethod'] == 'Account'
                    ? 'Delivery Note'
                    : 'Proof of Payment',
                style: AppTextStyles.heading4,
              ),
              const SizedBox(height: 8),
              if (purchase['hasProofOfPayment'])
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, size: 64, color: Colors.grey),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.warning.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No proof of payment or delivery note uploaded',
                          style: TextStyle(color: AppColors.warning),
                        ),
                      ),
                    ],
                  ),
                ),

              if (purchase['status'] == 'Pending Approval' &&
                  _isUserAdmin(context))
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Purchase approved successfully'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Approve'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Purchase rejected'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Reject'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.heading4),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(children: items.map((item) => item).toList()),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isStatus = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child:
                isStatus
                    ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(value).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        value,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: _getStatusColor(value),
                        ),
                      ),
                    )
                    : Text(value, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return AppColors.success;
      case 'Pending Approval':
        return AppColors.warning;
      case 'Denied':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  // Check if the current user viewing the dialog is an admin
  bool _isUserAdmin(BuildContext context) {
    final purchasesState =
        context.findAncestorStateOfType<_PurchasesScreenState>();
    if (purchasesState != null) {
      return purchasesState.widget.currentUser.isAdmin;
    }
    return false;
  }
}
