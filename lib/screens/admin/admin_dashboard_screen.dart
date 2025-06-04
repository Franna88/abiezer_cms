import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../models/project_model.dart';
import '../../models/notification_model.dart';
import '../../providers/project_provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive.dart';
import '../../widgets/navigation/side_nav.dart';
import '../../widgets/dashboard/metric_card.dart';
import '../../widgets/dashboard/project_card.dart';
import '../../widgets/dashboard/pending_action_panel.dart';
import '../../widgets/dashboard/notification_item.dart';
import '../../widgets/dashboard/activity_item.dart';

class AdminDashboardScreen extends StatefulWidget {
  final Function(NavTab)? onTabSelected;

  const AdminDashboardScreen({Key? key, this.onTabSelected}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // This will be called when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );

    // Only fetch if not already loading and there are no projects yet
    if (!projectProvider.isLoading && projectProvider.allProjects.isEmpty) {
      await projectProvider.fetchAllProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: ListView(
          padding: Responsive.getResponsivePadding(context),
          children: [
            // Metrics Section
            _buildMetricsSection(context),

            const SizedBox(height: 24),

            // Projects Section
            _buildProjectsSection(context),

            const SizedBox(height: 24),

            // Pending Actions Section
            _buildPendingActionsSection(context),

            const SizedBox(height: 24),

            // Split Notifications and Activity sections to columns on tablet/desktop
            if (isMobile) ...[
              _buildNotificationsSection(context),
              const SizedBox(height: 24),
              _buildActivityLogSection(context),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildNotificationsSection(context)),
                  const SizedBox(width: 24),
                  Expanded(flex: 2, child: _buildActivityLogSection(context)),
                ],
              ),

            // Add some spacing at the bottom of the page
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsSection(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final isMobile = Responsive.isMobile(context);

    // Get active projects count
    final activeProjects = projectProvider.allProjects
        .where((project) => project.status == 'active')
        .length;

    // Hardcoded low stock count for now
    const lowStockMaterials = 2;

    return isMobile
        ? Column(
            children: [
              MetricCard(
                title: 'Active Projects',
                value: activeProjects.toString(),
                icon: Icons.folder_outlined,
                color: AppTheme.primaryColor,
                onTap: () => _navigateToProjects(filterActive: true),
              ),
              const SizedBox(height: 16),
              MetricCard(
                title: 'Low-Stock Materials',
                value: lowStockMaterials.toString(),
                icon: Icons.warning_amber_outlined,
                color: AppTheme.warningColor,
                onTap: () => _navigateToBoM(filterLowStock: true),
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: 'Active Projects',
                  value: activeProjects.toString(),
                  icon: Icons.folder_outlined,
                  color: AppTheme.primaryColor,
                  onTap: () => _navigateToProjects(filterActive: true),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MetricCard(
                  title: 'Low-Stock Materials',
                  value: lowStockMaterials.toString(),
                  icon: Icons.warning_amber_outlined,
                  color: AppTheme.warningColor,
                  onTap: () => _navigateToBoM(filterLowStock: true),
                ),
              ),
            ],
          );
  }

  Widget _buildProjectsSection(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    // How many columns in the grid
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Projects', style: AppTheme.subheadingStyle),
            TextButton.icon(
              onPressed: () => _navigateToProjects(),
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (projectProvider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (projectProvider.allProjects.isEmpty)
          const Center(
            child: Text(
              'No projects found. Create your first project!',
              style: AppTheme.captionStyle,
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
            ),
            itemCount: projectProvider.allProjects.length > 6
                ? 6 // Show max 6 projects in dashboard
                : projectProvider.allProjects.length,
            itemBuilder: (context, index) {
              final project = projectProvider.allProjects[index];
              return ProjectCard(
                project: project,
                onViewDetails: () => _navigateToProjectDetails(project.id),
              );
            },
          ),
      ],
    );
  }

  Widget _buildPendingActionsSection(BuildContext context) {
    // Hardcoded data for now
    const materialRequestsCount = 3;
    const transfersCount = 1;
    const returnsCount = 0;
    const purchasesCount = 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pending Actions', style: AppTheme.subheadingStyle),
        const SizedBox(height: 16),
        PendingActionPanel(
          title: 'Material Requests',
          count: materialRequestsCount,
          icon: Icons.inventory_outlined,
          onReview: () => _navigateToApprovals(filter: 'material_requests'),
          items: const [
            'Cement (50 bags) - Project X',
            'Sand (20 tons) - Project Y',
            'Steel Bars (15 units) - Project Z',
          ],
        ),
        const SizedBox(height: 8),
        PendingActionPanel(
          title: 'Material Transfers',
          count: transfersCount,
          icon: Icons.swap_horiz_outlined,
          onReview: () => _navigateToApprovals(filter: 'transfers'),
          items: const ['Steel Bars (5 units) from Project X to Project Y'],
        ),
        const SizedBox(height: 8),
        PendingActionPanel(
          title: 'Material Returns',
          count: returnsCount,
          icon: Icons.assignment_return_outlined,
          onReview: () => _navigateToApprovals(filter: 'returns'),
          items: const [],
        ),
        const SizedBox(height: 8),
        PendingActionPanel(
          title: 'Purchase Requests',
          count: purchasesCount,
          icon: Icons.shopping_cart_outlined,
          onReview: () => _navigateToApprovals(filter: 'purchases'),
          items: const [
            'Cement (100 bags) - Vendor: Concrete Solutions Ltd',
            'Scaffolding Equipment - Vendor: Construction Supply Co',
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notifications', style: AppTheme.subheadingStyle),
        const SizedBox(height: 16),

        // Hardcoded notifications for now
        Card(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              NotificationItem(
                title: 'Low Stock Alert',
                message: 'Cement in Project X (10 bags remaining)',
                time: '2 hours ago',
                type: NotificationType.lowStock,
                isRead: false,
                onAction: () => _requestMaterial('Cement', 'Project X'),
                actionLabel: 'Request Material',
              ),
              const Divider(),
              NotificationItem(
                title: 'Material Request',
                message: 'John Doe requested 50 bags of cement for Project X',
                time: '5 hours ago',
                type: NotificationType.materialRequest,
                isRead: false,
                onAction: () =>
                    _navigateToApprovals(filter: 'material_requests'),
                actionLabel: 'Review',
              ),
              const Divider(),
              NotificationItem(
                title: 'Purchase Approved',
                message: 'Your purchase request for sand was approved',
                time: '1 day ago',
                type: NotificationType.purchaseApproval,
                isRead: true,
                onAction: () => _navigateToPurchases(),
                actionLabel: 'View Details',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityLogSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity', style: AppTheme.subheadingStyle),
        const SizedBox(height: 16),

        // Hardcoded activity log for now
        Card(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ActivityItem(
                title: 'Material Usage Logged',
                description:
                    'John Doe logged usage of 10 bags of cement in Project X',
                time: '2 hours ago',
                icon: Icons.assignment_outlined,
                color: AppTheme.primaryColor,
                onTap: () {},
              ),
              const Divider(),
              ActivityItem(
                title: 'Material Request Created',
                description:
                    'Jane Smith requested 20 tons of sand for Project Y',
                time: '5 hours ago',
                icon: Icons.add_shopping_cart_outlined,
                color: AppTheme.accentColor,
                onTap: () {},
              ),
              const Divider(),
              ActivityItem(
                title: 'Project Updated',
                description:
                    'Project Z status changed from "Active" to "Completed"',
                time: '1 day ago',
                icon: Icons.check_circle_outline,
                color: AppTheme.successColor,
                onTap: () {},
              ),
              const Divider(),
              ActivityItem(
                title: 'User Added',
                description:
                    'New Project Manager Mike Johnson added to Project X',
                time: '2 days ago',
                icon: Icons.person_add_outlined,
                color: AppTheme.infoColor,
                onTap: () {},
              ),
              const Divider(),
              ActivityItem(
                title: 'Material Returned',
                description: 'Jane Smith returned 5 steel bars from Project Y',
                time: '3 days ago',
                icon: Icons.assignment_return_outlined,
                color: AppTheme.successColor,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Navigation methods
  void _navigateToProjects({bool filterActive = false}) {
    // Navigate to Projects tab
    _navigateToTab(NavTab.projects);
  }

  void _navigateToBoM({bool filterLowStock = false}) {
    // Navigate to BoM tab
    _navigateToTab(NavTab.bom);
  }

  void _navigateToProjectDetails(String projectId) {
    // Set the selected project and navigate to Projects tab
    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );
    projectProvider.setSelectedProject(projectId);
    _navigateToTab(NavTab.projects);
  }

  void _navigateToApprovals({String? filter}) {
    // Navigate to Approvals tab
    _navigateToTab(NavTab.approvals);
  }

  void _navigateToPurchases() {
    // Navigate to Purchases tab
    _navigateToTab(NavTab.purchases);
  }

  void _requestMaterial(String material, String project) {
    // Navigate to Purchases tab to create a new request
    _navigateToTab(NavTab.purchases);
  }

  void _navigateToTab(NavTab tab) {
    // Use the callback if provided
    if (widget.onTabSelected != null) {
      widget.onTabSelected!(tab);
    }
  }
}
