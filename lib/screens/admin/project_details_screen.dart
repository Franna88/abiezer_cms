import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/project.dart';
import '../../models/project_bom_model.dart';
import '../../providers/projects_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/responsive.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/alert_badge.dart';
import '../../widgets/common/activity_timeline.dart';
import '../../widgets/common/info_card.dart';
import '../../services/user_service.dart';
import '../../services/bom_service.dart';
import '../../features/bom/widgets/create_bom_widget.dart';
import '../../features/bom/widgets/display_bom_widget.dart';
import 'create_bom_screen.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late Project project;
  bool _isLoading = false;
  List<String> _projectManagerNames = [];
  List<ActivityItem> _activities = [];
  final UserService _userService = UserService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BoMService _bomService = BoMService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // Load project manager names
      final managerNames =
          await _userService.getUserNamesByIds(project.projectManagerIds);
      setState(() => _projectManagerNames = managerNames);

      // Load recent activities
      final activitiesSnapshot = await _firestore
          .collection('project_activities')
          .where('projectId', isEqualTo: project.id)
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading project data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
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

  @override
  Widget build(BuildContext context) {
    project = ModalRoute.of(context)!.settings.arguments as Project;

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                  _buildProjectHeader(),
                  const SizedBox(height: 12),
                  _buildActionButtonContainer(),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 900;
                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: _buildProjectDetails(),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: _buildRecentActivityWithAuditLogs(),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildProjectDetails(),
                            const SizedBox(height: 24),
                            _buildRecentActivityWithAuditLogs(),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildBillOfMaterialsButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildProjectHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      project.name,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildStatusChip(project.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                project.location,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
        _buildAlertsRow(),
      ],
    );
  }

  Widget _buildActionButtonContainer() {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: _showEditDialog,
          icon: const Icon(Icons.edit, size: 18),
          label: const Text('Edit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            textStyle: const TextStyle(fontSize: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: _showArchiveDialog,
          icon: const Icon(Icons.archive_outlined, size: 18),
          label: const Text('Archive'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            textStyle: const TextStyle(fontSize: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: _showDeleteDialog,
          icon: const Icon(Icons.delete_outline, size: 18),
          label: const Text('Delete'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.errorColor,
            side: BorderSide(color: AppTheme.errorColor),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            textStyle: const TextStyle(fontSize: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MiniAlert(
          icon: Icons.notifications_active_outlined,
          label: 'Requests',
          count: 5, // TODO: Get actual count from Firestore
          color: AppTheme.warningColor,
        ),
        const SizedBox(width: 12),
        _MiniAlert(
          icon: Icons.warning_amber_rounded,
          label: 'Low-Stock Materials',
          count: 2, // TODO: Get actual count from Firestore
          color: AppTheme.errorColor,
        ),
      ],
    );
  }

  Widget _buildProjectDetails() {
    return InfoCard(
      title: 'Project Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Project Name', project.name),
          _buildInfoRow('Location', project.location),
          _buildInfoRow('Description', project.description),
          _buildInfoRow(
              'Start Date', project.startDate.toString().split(' ')[0]),
          _buildInfoRow('End Date', project.endDate.toString().split(' ')[0]),
          _buildInfoRow('Status', project.status),
          _buildInfoRow(
            'Project Managers',
            _projectManagerNames.join(', '),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityWithAuditLogs() {
    return InfoCard(
      title: 'Recent Activity',
      child: _activities.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No recent activity',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          : ActivityTimeline(activities: _activities),
    );
  }

  Widget _buildBillOfMaterialsButton() {
    return StreamBuilder<List<ProjectBoMModel>>(
      stream: _bomService.getProjectMaterials(project.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final materials = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bill of Materials',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (materials.isEmpty)
              Center(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/empty_bom.png',
                          height: 120,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No Bill of Materials Yet',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Start by creating a Bill of Materials to manage your project's resources efficiently.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _navigateToCreateBom(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Create BOM'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              DisplayBoMWidget(
                projectId: project.id,
                onBomUpdated: () {
                  setState(() {});
                },
              ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToCreateBom(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateBomScreen(project: project),
      ),
    );

    if (result == true) {
      // Refresh the project details
      setState(() {});
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = AppTheme.successColor;
        break;
      case 'completed':
        color = AppTheme.primaryColor;
        break;
      case 'on-hold':
        color = AppTheme.warningColor;
        break;
      case 'cancelled':
        color = AppTheme.errorColor;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEditDialog() {
    // TODO: Implement edit dialog
  }

  void _showArchiveDialog() {
    // TODO: Implement archive dialog
  }

  void _showDeleteDialog() {
    // TODO: Implement delete dialog
  }
}

class _MiniAlert extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _MiniAlert({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
