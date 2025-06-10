import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/project_model.dart';
import '../../models/notification_model.dart';
import '../../models/request_model.dart';
import '../../services/project_service.dart';
import '../../services/notification_service.dart';
import '../../services/request_service.dart';
import '../../widgets/dashboard/metric_card.dart';
import '../../widgets/dashboard/project_card.dart';
import '../../widgets/dashboard/notification_item.dart';
import '../../utils/app_theme.dart';

class PMDashboardScreen extends StatefulWidget {
  const PMDashboardScreen({Key? key}) : super(key: key);

  @override
  State<PMDashboardScreen> createState() => _PMDashboardScreenState();
}

class _PMDashboardScreenState extends State<PMDashboardScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Initialize services
  final ProjectService _projectService = ProjectService();
  final NotificationService _notificationService = NotificationService();
  final RequestService _requestService = RequestService();

  // Metric counters
  int _assignedProjectsCount = 0;
  int _lowStockCount = 0;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    if (currentUserId.isNotEmpty) {
      final projectsCount = await _projectService.getAssignedProjectsCount(
        currentUserId,
      );
      final lowStockCount = await _projectService.getLowStockMaterialsCount(
        currentUserId,
      );

      if (mounted) {
        setState(() {
          _assignedProjectsCount = projectsCount;
          _lowStockCount = lowStockCount;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadMetrics();
              setState(() {});
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadMetrics();
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildMetricsSection(),
            const SizedBox(height: 24),
            _buildProjectsSection(),
            const SizedBox(height: 24),
            _buildPendingRequestsSection(),
            const SizedBox(height: 24),
            _buildNotificationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Metrics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Single column for small screens, two columns for tablets and up
            final isSmallScreen = constraints.maxWidth < 600;

            if (isSmallScreen) {
              return Column(
                children: [
                  MetricCard(
                    title: 'Assigned Projects',
                    value: _assignedProjectsCount.toString(),
                    icon: Icons.folder_outlined,
                    color: AppTheme.primaryColor,
                    onTap: () {
                      // Filter projects or navigate
                    },
                  ),
                  const SizedBox(height: 16),
                  MetricCard(
                    title: 'Low-Stock Materials',
                    value: _lowStockCount.toString(),
                    icon: Icons.warning_amber_outlined,
                    color: AppTheme.warningColor,
                    onTap: () {
                      // Filter to show low stock items
                    },
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: 'Assigned Projects',
                      value: _assignedProjectsCount.toString(),
                      icon: Icons.folder_outlined,
                      color: AppTheme.primaryColor,
                      onTap: () {
                        // Filter projects or navigate
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      title: 'Low-Stock Materials',
                      value: _lowStockCount.toString(),
                      icon: Icons.warning_amber_outlined,
                      color: AppTheme.warningColor,
                      onTap: () {
                        // Filter to show low stock items
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildProjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Assigned Projects',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<ProjectModel>>(
          stream: _projectService.getProjectsForManager(currentUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: AppTheme.errorColor),
                ),
              );
            }

            final projects = snapshot.data ?? [];

            if (projects.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'No projects assigned to you',
                    style: TextStyle(color: AppTheme.textSecondaryColor),
                  ),
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                // Choose layout based on screen size
                final isSmallScreen = constraints.maxWidth < 600;

                if (isSmallScreen) {
                  // Single column for mobile
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: projects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return ProjectCard(
                        project: project,
                        onViewDetails: () {
                          // Navigate to project BoM
                          Navigator.pushNamed(
                            context,
                            '/bom',
                            arguments: project.id,
                          );
                        },
                      );
                    },
                  );
                } else {
                  // Grid for tablet and larger screens
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return ProjectCard(
                        project: project,
                        onViewDetails: () {
                          // Navigate to project BoM
                          Navigator.pushNamed(
                            context,
                            '/bom',
                            arguments: project.id,
                          );
                        },
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPendingRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Pending Requests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<RequestModel>>(
          future: _requestService.getPendingRequestsForUser(currentUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: AppTheme.errorColor),
                ),
              );
            }

            final requests = snapshot.data ?? [];

            if (requests.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'No pending requests',
                    style: TextStyle(color: AppTheme.textSecondaryColor),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${request.type.substring(0, 1).toUpperCase()}${request.type.substring(1)} Request',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.warningColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                request.status.substring(0, 1).toUpperCase() +
                                    request.status.substring(1),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.warningColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${request.materialName} - ${request.quantity} ${request.unit}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Project ID: ${request.projectId}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Requested on: ${_formatDate(request.timestamp)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textLightColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<NotificationModel>>(
          stream: _notificationService.getNotificationsForUser(currentUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: AppTheme.errorColor),
                ),
              );
            }

            final notifications = snapshot.data ?? [];

            if (notifications.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'No notifications',
                    style: TextStyle(color: AppTheme.textSecondaryColor),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return NotificationItem(
                  title: notification.title,
                  message: notification.message,
                  time: _formatTimestamp(notification.timestamp),
                  type: notification.type,
                  isRead: notification.isRead,
                  actionLabel: _getActionLabel(notification.type),
                  onAction: notification.type == NotificationType.lowStock
                      ? () {
                          // Navigate to BoM for the project
                          if (notification.projectId != null) {
                            Navigator.pushNamed(
                              context,
                              '/bom',
                              arguments: notification.projectId,
                            );
                          }
                        }
                      : null,
                );
              },
            );
          },
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String? _getActionLabel(NotificationType type) {
    switch (type) {
      case NotificationType.lowStock:
        return 'Request Material';
      case NotificationType.materialRequest:
      case NotificationType.materialApproval:
      case NotificationType.purchaseRequest:
      case NotificationType.purchaseApproval:
        return 'View Details';
      default:
        return null;
    }
  }
}
