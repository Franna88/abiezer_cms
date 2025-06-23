import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/project.dart';
import '../../models/project_bom_model.dart';
import '../../models/user_model.dart';
import '../../utils/responsive.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/activity_timeline.dart';
import '../../widgets/common/info_card.dart';
import '../../services/user_service.dart';
import '../../services/bom_service.dart';
import '../../features/bom/widgets/display_bom_widget.dart';
import 'create_bom_screen.dart';
import 'widgets/manage_team_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/storage_service.dart';
import '../../services/project_service.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen>
    with SingleTickerProviderStateMixin {
  Project? project;
  bool _isLoading = false;
  bool _hasLoadedData = false; // Flag to prevent multiple loads
  List<UserModel> _projectManagers = [];
  List<ActivityItem> _activities = [];
  final UserService _userService = UserService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BoMService _bomService = BoMService();
  final ImagePicker _imagePicker = ImagePicker();
  final StorageService _storageService = StorageService();
  final ProjectService _projectService = ProjectService();
  bool _isUploadingImage = false;

  // Tab controller
  late TabController _tabController;

  // Budget tracking
  double _totalBudget = 0.0;
  double _usedBudget = 0.0;
  List<Map<String, dynamic>> _budgetBreakdown = [];

  // Documents
  List<Map<String, dynamic>> _documents = [];
  bool _isUploadingDocument = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get project from route arguments safely
    if (project == null) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null && arguments is Project) {
        project = arguments;

        // Load data only once and only after project is available
        if (!_hasLoadedData) {
          _hasLoadedData = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadData();
          });
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

    // Load project manager models separately with its own error handling
    try {
      // Debug: Print project manager IDs
      print('Project: ${project!.name}');
      print('Project Manager IDs: ${project!.projectManagerIds}');
      print('Number of manager IDs: ${project!.projectManagerIds.length}');

      // Load project manager models
      final managers =
          await _userService.getUsersByIds(project!.projectManagerIds);
      print('Loaded managers: $managers');
      if (mounted) {
        setState(() => _projectManagers = managers);
      }
    } catch (e) {
      print('Error loading project manager data: $e');
      if (mounted) {
        setState(() {
          _projectManagers = [];
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

      if (mounted) {
        setState(() => _activities = activities);
      }
    } catch (e) {
      print(
          'Error loading project activities (permissions or missing index): $e');
      // Set empty activities and show a helpful message
      if (mounted) {
        setState(() {
          _activities = [];
        });
        // Show a less alarming message to the user
        if (e.toString().contains('permission-denied')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Project activities will be available once permissions are configured.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }

    // Load budget information
    await _loadBudgetData();

    // Load documents
    await _loadDocuments();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadBudgetData() async {
    if (project == null || !mounted) return;

    setState(() {
      _totalBudget = project!.budget ?? 0.0;
    });

    try {
      // Get BOM materials to calculate used budget
      final bomSnapshot = await _firestore
          .collection('projects')
          .doc(project!.id)
          .collection('bom')
          .get();

      double usedBudget = 0.0;
      List<Map<String, dynamic>> breakdown = [];

      for (var doc in bomSnapshot.docs) {
        final bomData = doc.data();
        final materialId = bomData['materialId'];
        final usedQuantity = bomData['usedQuantity'] ?? 0.0;

        // Get material price from materials collection
        final materialDoc =
            await _firestore.collection('materials').doc(materialId).get();

        if (materialDoc.exists) {
          final materialData = materialDoc.data()!;
          final price = materialData['price'] ?? 0.0;
          final materialCost = usedQuantity * price;
          usedBudget += materialCost;

          breakdown.add({
            'materialName': materialData['name'] ?? 'Unknown Material',
            'quantity': usedQuantity,
            'price': price,
            'totalCost': materialCost,
          });
        }
      }

      if (mounted) {
        setState(() {
          _usedBudget = usedBudget;
          _budgetBreakdown = breakdown;
        });
      }
    } catch (e) {
      print('Error loading budget data: $e');
    }
  }

  Future<void> _loadDocuments() async {
    if (project == null || !mounted) return;

    try {
      final documentsSnapshot = await _firestore
          .collection('projects')
          .doc(project!.id)
          .collection('documents')
          .orderBy('uploadedAt', descending: true)
          .get();

      final documents = documentsSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'label': data['label'] ?? '',
          'url': data['url'] ?? '',
          'uploadedAt': data['uploadedAt'] as Timestamp?,
          'uploadedBy': data['uploadedBy'] ?? '',
        };
      }).toList();

      if (mounted) {
        setState(() {
          _documents = documents;
        });
      }
    } catch (e) {
      print('Error loading documents (permissions or missing rules): $e');
      if (mounted) {
        setState(() {
          _documents = [];
        });
        // Show user-friendly message for permission errors
        if (e.toString().contains('permission-denied')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Document access will be available once permissions are configured.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
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
    // Project is now assigned in didChangeDependencies(), so we can safely use it
    if (project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Project Details')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No project data available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Please navigate back and try again',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(project!.name),
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
                  _buildTabbedInterface(),
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
                      project!.name,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildStatusChip(project!.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                project!.location,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProjectImage(),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  icon: Icons.description_outlined,
                  label: 'Description',
                  value: project!.description,
                ),
                const Divider(height: 1),
                _buildDetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Start Date',
                  value: project!.startDate.toString().split(' ')[0],
                ),
                const Divider(height: 1),
                _buildDetailRow(
                  icon: Icons.event_available_outlined,
                  label: 'End Date',
                  value: project!.endDate.toString().split(' ')[0],
                ),
                const Divider(height: 1),
                _buildDetailRow(
                  icon: Icons.person_outline,
                  label: 'Project Managers',
                  value: _projectManagers.isEmpty
                      ? 'Loading...'
                      : _projectManagers.map((m) => m.name).join(', '),
                ),
                const Divider(height: 1),
                if (project!.budget != null)
                  _buildDetailRow(
                    icon: Icons.paid_outlined,
                    label: 'Budget',
                    value:
                        'R ${NumberFormat('#,##0.00', 'en_ZA').format(project!.budget)}',
                  ),
                if (project!.clientName != null &&
                    project!.clientName!.isNotEmpty) ...[
                  const Divider(height: 32, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Client Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ),
                  _buildClientInfoCard(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectImage() {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          if (_isUploadingImage)
            const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (project?.projectImageUrl != null &&
              project!.projectImageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: project!.projectImageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            )
          else
            InkWell(
              onTap: _pickAndUploadImage,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Add Project Image',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClientInfoCard() {
    return Column(
      children: [
        _buildDetailRow(
          icon: Icons.person_pin_outlined,
          label: 'Client Name',
          value: project!.clientName!,
        ),
        if (project!.clientPhone != null)
          _buildDetailRow(
            icon: Icons.phone_outlined,
            label: 'Client Phone',
            value: project!.clientPhone!,
          ),
        if (project!.clientEmail != null)
          _buildDetailRow(
            icon: Icons.email_outlined,
            label: 'Client Email',
            value: project!.clientEmail!,
          ),
      ],
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

  Widget _buildTabbedInterface() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: AppTheme.primaryColor,
            indicatorWeight: 3,
            tabs: const [
              Tab(
                icon: Icon(Icons.inventory_2_outlined),
                text: 'BoM',
              ),
              Tab(
                icon: Icon(Icons.people_outline),
                text: 'Team',
              ),
              Tab(
                icon: Icon(Icons.account_balance_wallet_outlined),
                text: 'Budget',
              ),
              Tab(
                icon: Icon(Icons.folder_outlined),
                text: 'Documents',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Tab Content
        Container(
          height: 600, // Fixed height for tab content
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBomTab(),
              _buildTeamTab(),
              _buildBudgetTab(),
              _buildDocumentsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBomTab() {
    return StreamBuilder<List<ProjectBoMModel>>(
      stream: _bomService.getProjectMaterials(project!.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading Bill of Materials'),
          );
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
                ElevatedButton.icon(
                  onPressed: () => _navigateToCreateBom(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Material'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
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
              Expanded(
                child: DisplayBoMWidget(
                  projectId: project!.id,
                  onBomUpdated: () {
                    setState(() {});
                    _loadBudgetData(); // Refresh budget when BOM changes
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTeamTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Project Team',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
            ),
            ElevatedButton.icon(
              onPressed: _manageProjectManagers,
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Manage'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppTheme.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: const TextStyle(fontSize: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_projectManagers.isEmpty)
          SizedBox(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline,
                      size: 64, color: AppTheme.textLightColor),
                  const SizedBox(height: 16),
                  Text(
                    'No Project Managers Assigned',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Assign project managers to this project',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textLightColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.getResponsiveValue(
                  context: context,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                ).toInt(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _projectManagers.length,
              itemBuilder: (context, index) {
                final manager = _projectManagers[index];
                final projectCount = manager.assignedProjects.length;
                final projectText =
                    '$projectCount ${projectCount == 1 ? 'Project' : 'Projects'}';

                return Card(
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: manager.photoUrl.isNotEmpty
                              ? NetworkImage(manager.photoUrl)
                              : null,
                          backgroundColor:
                              AppTheme.primaryColor.withOpacity(0.1),
                          child: manager.photoUrl.isEmpty
                              ? Text(
                                  manager.name.isNotEmpty
                                      ? manager.name[0].toUpperCase()
                                      : 'U',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          manager.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          manager.email,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          manager.phone ?? 'No phone number',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Project Manager', // Displaying a more readable role
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          projectText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
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
    );
  }

  Widget _buildBudgetTab() {
    final remainingBudget = _totalBudget - _usedBudget;
    final budgetPercentage =
        _totalBudget > 0 ? (_usedBudget / _totalBudget) * 100 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget Overview',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        // Budget Summary Cards
        Row(
          children: [
            Expanded(
              child: _buildBudgetCard(
                'Total Budget',
                'R ${NumberFormat('#,##0.00', 'en_ZA').format(_totalBudget)}',
                Icons.account_balance_wallet,
                AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildBudgetCard(
                'Used Budget',
                'R ${NumberFormat('#,##0.00', 'en_ZA').format(_usedBudget)}',
                Icons.money_off,
                AppTheme.warningColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildBudgetCard(
                'Remaining',
                'R ${NumberFormat('#,##0.00', 'en_ZA').format(remainingBudget)}',
                Icons.savings,
                AppTheme.successColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Budget Progress
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budget Usage',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: budgetPercentage / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    budgetPercentage > 80
                        ? AppTheme.errorColor
                        : budgetPercentage > 60
                            ? AppTheme.warningColor
                            : AppTheme.successColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${budgetPercentage.toStringAsFixed(1)}% used',
                  style: TextStyle(
                    color: budgetPercentage > 80
                        ? AppTheme.errorColor
                        : budgetPercentage > 60
                            ? AppTheme.warningColor
                            : AppTheme.successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Budget Breakdown
        Text(
          'Budget Breakdown',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _budgetBreakdown.isEmpty
              ? const Center(
                  child: Text(
                    'No materials used yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _budgetBreakdown.length,
                  itemBuilder: (context, index) {
                    final item = _budgetBreakdown[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(item['materialName']),
                        subtitle: Text(
                            '${item['quantity']} units × R ${NumberFormat('#,##0.00', 'en_ZA').format(item['price'])}'),
                        trailing: Text(
                          'R ${NumberFormat('#,##0.00', 'en_ZA').format(item['totalCost'])}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildBudgetCard(
      String title, String amount, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Project Documents',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ElevatedButton.icon(
              onPressed: _isUploadingDocument ? null : _uploadDocument,
              icon: _isUploadingDocument
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file),
              label: Text(_isUploadingDocument ? 'Uploading...' : 'Upload'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _documents.isEmpty
              ? const Center(
                  child: Column(
                    children: [
                      Icon(Icons.folder_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No Documents Uploaded',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Upload project documents and files',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _documents.length,
                  itemBuilder: (context, index) {
                    final document = _documents[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.insert_drive_file),
                        title: Text(document['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (document['label'].isNotEmpty)
                              Text(
                                'Label: ${document['label']}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            Text(
                              'Uploaded: ${document['uploadedAt'] != null ? DateFormat('MMM dd, yyyy').format(document['uploadedAt'].toDate()) : 'Unknown'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'download',
                              child: Row(
                                children: [
                                  Icon(Icons.download),
                                  SizedBox(width: 8),
                                  Text('Download'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'download') {
                              // TODO: Implement download
                            } else if (value == 'delete') {
                              _deleteDocument(document['id']);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _uploadDocument() async {
    // TODO: Implement document upload functionality
    // This would involve:
    // 1. File picker
    // 2. Upload to Firebase Storage
    // 3. Save metadata to Firestore
    // 4. Update UI
  }

  Future<void> _deleteDocument(String documentId) async {
    // TODO: Implement document deletion
    // This would involve:
    // 1. Delete from Firebase Storage
    // 2. Delete metadata from Firestore
    // 3. Update UI
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
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

  Future<void> _manageProjectManagers() async {
    if (project == null) return;

    final updatedManagerIds = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return ManageTeamDialog(project: project!);
      },
    );

    if (updatedManagerIds != null && mounted) {
      setState(() {
        project!.projectManagerIds = updatedManagerIds;
      });
      _loadData(); // Reload data to get new manager details
    }
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

  Future<void> _navigateToCreateBom(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateBomScreen(project: project!),
      ),
    );

    if (result == true) {
      // Refresh the project details
      setState(() {});
    }
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null && project != null) {
      setState(() {
        _isUploadingImage = true;
      });

      try {
        final imageUrl = await _storageService.uploadProjectImage(
          image,
          project!.name,
        );

        await _projectService.updateProjectImageUrl(project!.id, imageUrl);

        if (mounted) {
          setState(() {
            project!.projectImageUrl = imageUrl;
            _isUploadingImage = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Project image updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isUploadingImage = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error uploading image: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
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
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
