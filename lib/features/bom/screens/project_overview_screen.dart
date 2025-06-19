import 'package:flutter/material.dart';
import '../../../models/project_model.dart';
import '../../../widgets/dashboard/metric_card.dart';
import '../../../widgets/common/info_card.dart';
import '../../../widgets/common/activity_timeline.dart';
import '../../../utils/app_theme.dart';

class ProjectOverviewScreen extends StatelessWidget {
  final ProjectModel project;
  const ProjectOverviewScreen({Key? key, required this.project})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final double spacing = isMobile ? 12 : 24;
    final double cardSpacing = isMobile ? 8 : 16;
    final double metricIconSize = isMobile ? 28 : 40;
    final double metricFontSize = isMobile ? 16 : 22;
    final metrics = [
      MetricCard(
        title: isMobile ? '' : 'Total Materials',
        value: '12',
        icon: Icons.inventory,
        color: AppTheme.primaryColor,
      ),
      MetricCard(
        title: isMobile ? '' : 'Low-Stock',
        value: '2',
        icon: Icons.warning,
        color: AppTheme.warningColor,
      ),
      MetricCard(
        title: isMobile ? '' : 'Recent Activity',
        value: '3',
        icon: Icons.history,
        color: AppTheme.infoColor,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Responsive top section
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: metrics,
                        ),
                        SizedBox(height: cardSpacing),
                        _buildProjectDetails(context),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildProjectDetails(context)),
                        SizedBox(width: cardSpacing),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              ...metrics.map((m) => Padding(
                                    padding:
                                        EdgeInsets.only(bottom: cardSpacing),
                                    child: m,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: spacing),
              // Tabs
              _ProjectTabs(project: project),
              SizedBox(height: spacing),
              // Large, prominent BoM button
              Center(
                child: SizedBox(
                  width: isMobile ? double.infinity : 340,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.list_alt, size: 28),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'View Bill of Materials',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    onPressed: () {
                      // TODO: Navigate to BoM page for this project
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectDetails(BuildContext context) {
    // Essentials: name, status, location, description, dates, managers
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    style: AppTheme.headingStyle,
                  ),
                ),
                _buildStatusChip(project.status),
              ],
            ),
            const SizedBox(height: 8),
            _infoRow(Icons.location_on, project.location),
            const SizedBox(height: 4),
            _infoRow(Icons.calendar_today,
                _formatDateRange(project.startDate, project.endDate)),
            if (project.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              _infoRow(Icons.description, project.description, maxLines: 2),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    project.projectManagers.isNotEmpty
                        ? 'Managers: ${project.projectManagers.join(", ")}'
                        : 'No Project Managers Assigned',
                    style: const TextStyle(
                        fontSize: 13, fontStyle: FontStyle.italic),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value, {int? maxLines}) {
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
    Color bgColor;
    Color textColor;
    switch (status.toLowerCase()) {
      case 'active':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'completed':
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case 'archived':
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
    }
    return Chip(
      label: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      backgroundColor: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _formatDateRange(DateTime start, DateTime? end) {
    String startStr = _formatDate(start);
    String endStr = end != null ? _formatDate(end) : '';
    return endStr.isNotEmpty ? '$startStr - $endStr' : startStr;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

// Tabs widget (stubbed for now)
class _ProjectTabs extends StatelessWidget {
  final ProjectModel project;
  const _ProjectTabs({required this.project});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement Team, Timeline, Documents tabs with content
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryColor,
            tabs: const [
              Tab(icon: Icon(Icons.people), text: 'Team'),
              Tab(icon: Icon(Icons.timeline), text: 'Timeline'),
              Tab(icon: Icon(Icons.folder), text: 'Documents'),
            ],
          ),
          SizedBox(
            height: 260, // Adjust as needed
            child: TabBarView(
              children: [
                Center(child: Text('Team tab content here')), // TODO
                Center(child: Text('Timeline tab content here')), // TODO
                Center(child: Text('Documents tab content here')), // TODO
              ],
            ),
          ),
        ],
      ),
    );
  }
}
