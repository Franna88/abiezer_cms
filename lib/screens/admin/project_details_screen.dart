import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/project.dart';
import '../../providers/projects_provider.dart';
import '../../utils/responsive.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/alert_badge.dart';
import '../../widgets/common/activity_timeline.dart';
import '../../widgets/common/info_card.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late Project project;
  bool _isLoading = false;

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
                            // Project Info (left)
                            Expanded(
                              flex: 3,
                              child: _buildProjectDetails(),
                            ),
                            const SizedBox(width: 24),
                            // Recent Activity (right)
                            Expanded(
                              flex: 2,
                              child: _buildRecentActivityWithAuditLogs(),
                            ),
                          ],
                        );
                      } else {
                        // Stack vertically on small screens
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
          count: 5, // TODO: Get actual count
          color: AppTheme.warningColor,
        ),
        const SizedBox(width: 12),
        _MiniAlert(
          icon: Icons.warning_amber_rounded,
          label: 'Low-Stock Materials',
          count: 2, // TODO: Get actual count
          color: AppTheme.errorColor, // RED for low stock
        ),
      ],
    );
  }

  Widget _buildProjectDetails() {
    return InfoCard(
      title: 'Project Information',
      child: Column(
        children: [
          _buildInfoRow('Start Date', _formatDate(project.startDate)),
          _buildInfoRow('End Date', _formatDate(project.endDate)),
          _buildInfoRow('Status', project.status),
          if (project.description.isNotEmpty)
            _buildInfoRow('Description', project.description),
          _buildInfoRow('Project Managers',
              'John Doe, Jane Smith'), // TODO: Get actual managers
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return InfoCard(
      title: 'Recent Activity',
      child: ActivityTimeline(
        activities: [
          // TODO: Get actual activities from provider
          ActivityItem(
            title: 'Material Request',
            description: 'John Doe requested 50 bags of cement',
            time: '2 hours ago',
            icon: Icons.inventory_2_outlined,
            color: AppTheme.primaryColor,
          ),
          ActivityItem(
            title: 'BoM Updated',
            description: 'Added new materials to Bill of Materials',
            time: '1 day ago',
            icon: Icons.edit_note,
            color: AppTheme.infoColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBillOfMaterialsButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/admin/project-bom',
            arguments: project.id,
          );
        },
        icon: const Icon(Icons.inventory_2),
        label: const Text('View Bill of Materials'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
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

  void _showAuditLogsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: 500,
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Audit Log',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: const [
                    // Placeholder audit log entries
                    ListTile(
                      leading: Icon(Icons.edit, color: Colors.blue),
                      title: Text('Project details updated'),
                      subtitle: Text('by Admin Bob, 2025-05-19 02:55 PM'),
                    ),
                    ListTile(
                      leading: Icon(Icons.inventory_2, color: Colors.orange),
                      title: Text('BoM created'),
                      subtitle: Text('by Admin Alice, 2025-05-01 10:00 AM'),
                    ),
                    ListTile(
                      leading: Icon(Icons.request_page, color: Colors.green),
                      title: Text('Material request approved'),
                      subtitle: Text('by Admin Bob, 2025-05-19 03:00 PM'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityWithAuditLogs() {
    return InfoCard(
      title: 'Recent Activity',
      actions: [
        ElevatedButton.icon(
          onPressed: _showAuditLogsDialog,
          icon: const Icon(Icons.list_alt),
          label: const Text('Audit Logs'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            textStyle: const TextStyle(fontSize: 13),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
        ),
      ],
      child: ActivityTimeline(
        activities: [
          ActivityItem(
            title: 'Material Request',
            description: 'John Doe requested 50 bags of cement',
            time: '2 hours ago',
            icon: Icons.inventory_2_outlined,
            color: AppTheme.primaryColor,
          ),
          ActivityItem(
            title: 'BoM Updated',
            description: 'Added new materials to Bill of Materials',
            time: '1 day ago',
            icon: Icons.edit_note,
            color: AppTheme.infoColor,
          ),
        ],
      ),
    );
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(4),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
