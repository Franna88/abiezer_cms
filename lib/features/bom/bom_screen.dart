import 'package:flutter/material.dart';
import '../../core/models/bill_of_materials_model.dart';
import '../../core/models/user_model.dart';
import '../../core/theme/color_theme.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utilities/constants.dart';
import '../../core/utilities/utilities.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/responsive_layout.dart';
import '../../widgets/common/section_header.dart';
import 'widgets/material_list_item.dart';
import 'widgets/material_filter_bar.dart';
import 'widgets/material_summary_card.dart';

class BomScreen extends StatefulWidget {
  final String? projectId;
  final UserModel currentUser;

  const BomScreen({super.key, this.projectId, required this.currentUser});

  @override
  State<BomScreen> createState() => _BomScreenState();
}

class _BomScreenState extends State<BomScreen> {
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All Categories';
  String _sortBy = 'Name';
  bool _showLowStockOnly = false;
  bool _showLeftoverOnly = false;
  List<dynamic> _materials = [];

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  Future<void> _loadMaterials() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call to get materials for the project
    await Future.delayed(const Duration(milliseconds: 800));

    // In a real app, this would fetch data from a backend API
    // based on the selected project ID
    setState(() {
      _materials = [
        {
          'id': '1',
          'name': 'Cement',
          'category': 'Cement & Aggregates',
          'unit': 'Bag',
          'totalQuantity': 120,
          'usedQuantity': 68,
          'remainingQuantity': 52,
          'unitPrice': 85.0,
          'isLowStock': false,
          'status': 'new',
        },
        {
          'id': '2',
          'name': 'Hardboard',
          'category': 'Boards & Sheets',
          'unit': 'Sheet',
          'totalQuantity': 50,
          'usedQuantity': 42,
          'remainingQuantity': 8,
          'unitPrice': 145.0,
          'isLowStock': true,
          'status': 'new',
        },
        {
          'id': '3',
          'name': 'Abebond',
          'category': 'Adhesives & Chemicals',
          'unit': 'Liter',
          'totalQuantity': 30,
          'usedQuantity': 22,
          'remainingQuantity': 8,
          'unitPrice': 75.0,
          'isLowStock': false,
          'status': 'new',
        },
        {
          'id': '4',
          'name': 'Brick Force',
          'category': 'Fasteners & Fixings',
          'unit': 'Roll',
          'totalQuantity': 15,
          'usedQuantity': 12,
          'remainingQuantity': 3,
          'unitPrice': 250.0,
          'isLowStock': true,
          'status': 'new',
        },
        {
          'id': '5',
          'name': 'Paint Brushes',
          'category': 'Paint & Finishing',
          'unit': 'Each',
          'totalQuantity': 40,
          'usedQuantity': 18,
          'remainingQuantity': 22,
          'unitPrice': 35.0,
          'isLowStock': false,
          'status': 'leftover',
          'sourceProjectId': '2',
        },
      ];
      _isLoading = false;
    });
  }

  List<dynamic> get _filteredMaterials {
    return _materials.where((material) {
      // Filter by search
      if (_searchQuery.isNotEmpty &&
          !material['name'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          )) {
        return false;
      }

      // Filter by category
      if (_selectedCategory != 'All Categories' &&
          material['category'] != _selectedCategory) {
        return false;
      }

      // Filter by stock status
      if (_showLowStockOnly && !material['isLowStock']) {
        return false;
      }

      // Filter by leftover status
      if (_showLeftoverOnly && material['status'] != 'leftover') {
        return false;
      }

      return true;
    }).toList();
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _handleCategoryFilter(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _handleSortChange(String sortBy) {
    setState(() {
      _sortBy = sortBy;
    });
  }

  void _toggleLowStockFilter() {
    setState(() {
      _showLowStockOnly = !_showLowStockOnly;
    });
  }

  void _toggleLeftoverFilter() {
    setState(() {
      _showLeftoverOnly = !_showLeftoverOnly;
    });
  }

  void _handleAddMaterial() {
    // Check if user has permission to add materials
    if (!widget.currentUser.canCreateBillOfMaterials) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You do not have permission to add materials to the bill.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Navigate to add material screen
  }

  void _handleMarkMaterialUsed(String materialId, double quantity) {
    // Check if user has permission to mark materials as used
    if (!widget.currentUser.canMarkMaterialsUsed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You do not have permission to mark materials as used.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Mark material as used logic
    setState(() {
      final materialIndex = _materials.indexWhere((m) => m['id'] == materialId);
      if (materialIndex != -1) {
        final material = _materials[materialIndex];

        // Ensure we can't mark more than is available
        final availableQuantity =
            material['totalQuantity'] - material['usedQuantity'];
        final usedQuantity =
            quantity > availableQuantity ? availableQuantity : quantity;

        _materials[materialIndex] = {
          ..._materials[materialIndex],
          'usedQuantity': material['usedQuantity'] + usedQuantity,
          'remainingQuantity': material['remainingQuantity'] - usedQuantity,
        };
      }
    });
  }

  void _handleMaterialTap(String materialId) {
    // Navigate to material details
  }

  void _handleRequestMaterial() {
    // Open request material dialog
  }

  void _handleMarkProjectComplete() {
    // Check if user has permission to mark project as complete
    if (!widget.currentUser.canMarkProjectComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You do not have permission to mark the project as complete.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Logic to mark project as complete and identify leftover materials
    // In a real app, this would update the project status and handle leftover materials

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
              ElevatedButton(
                onPressed: () {
                  // Process leftovers and mark as complete
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Project marked as complete. Leftover materials are now available.',
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Project selection check - in a real app this should navigate to a project selection screen
    if (widget.projectId == null) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: AppColors.primary.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Project Selected',
                  style: AppTextStyles.heading3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please select a project from the dropdown in the app bar to view its Bill of Materials.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Check if user has access to this project
    if (!widget.currentUser.hasAccessToProject(widget.projectId!)) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Access Denied',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You do not have permission to access this project.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: null,
      floatingActionButton:
          widget.currentUser.canCreateBillOfMaterials
              ? FloatingActionButton(
                onPressed: _handleAddMaterial,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
              )
              : null,
      body:
          _isLoading
              ? const Center(
                child: LoadingIndicator(message: 'Loading materials...'),
              )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: Utils.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          _buildHeader(),
          const SizedBox(height: 24),

          // Filter section
          MaterialFilterBar(
            onSearch: _handleSearch,
            onCategoryChanged: _handleCategoryFilter,
            onSortChanged: _handleSortChange,
            onToggleLowStockOnly: _toggleLowStockFilter,
            onToggleLeftoverOnly: _toggleLeftoverFilter,
            selectedCategory: _selectedCategory,
            sortBy: _sortBy,
            showLowStockOnly: _showLowStockOnly,
            showLeftoverOnly: _showLeftoverOnly,
            categories: AppConstants.materialCategories,
          ),
          const SizedBox(height: 16),

          // Project manager actions
          if (widget.currentUser.canMarkProjectComplete)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: _handleMarkProjectComplete,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Mark Project Complete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.success,
                      side: BorderSide(color: AppColors.success),
                    ),
                  ),
                ],
              ),
            ),

          // Materials list
          Expanded(child: _buildMaterialsList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final totalMaterials = _materials.length;
    final lowStockCount = _materials.where((m) => m['isLowStock']).length;
    final outOfStockCount =
        _materials.where((m) => m['remainingQuantity'] <= 0).length;
    final leftoverCount =
        _materials.where((m) => m['status'] == 'leftover').length;

    return ResponsiveLayout(
      mobile: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Bill of Materials', hasDivider: false),
          const SizedBox(height: 16),
          MaterialSummaryCard(
            totalMaterials: totalMaterials,
            lowStockCount: lowStockCount,
            outOfStockCount: outOfStockCount,
            leftoverCount: leftoverCount,
            onRequestMaterial: _handleRequestMaterial,
          ),
        ],
      ),
      tablet: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 2,
            child: SectionHeader(title: 'Bill of Materials', hasDivider: false),
          ),
          Expanded(
            flex: 3,
            child: MaterialSummaryCard(
              totalMaterials: totalMaterials,
              lowStockCount: lowStockCount,
              outOfStockCount: outOfStockCount,
              leftoverCount: leftoverCount,
              onRequestMaterial: _handleRequestMaterial,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsList() {
    if (_filteredMaterials.isEmpty) {
      return NoMaterialsFound(
        title: 'No Materials Found',
        message:
            _searchQuery.isNotEmpty
                ? 'No materials match your search criteria. Try adjusting your filters.'
                : 'There are no materials in this project\'s Bill of Materials.',
        buttonText:
            widget.currentUser.canCreateBillOfMaterials
                ? 'Add Material'
                : 'Refresh',
        onButtonPressed:
            widget.currentUser.canCreateBillOfMaterials
                ? _handleAddMaterial
                : () => setState(() {}),
      );
    }

    return ResponsiveLayout(
      mobile: ListView.separated(
        itemCount: _filteredMaterials.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final material = _filteredMaterials[index];
          return MaterialListItem(
            name: material['name'],
            category: material['category'],
            unit: material['unit'],
            totalQuantity: material['totalQuantity'],
            usedQuantity: material['usedQuantity'],
            remainingQuantity: material['remainingQuantity'],
            unitPrice: material['unitPrice'],
            isLowStock: material['isLowStock'],
            isLeftover: material['status'] == 'leftover',
            canMarkAsUsed: widget.currentUser.canMarkMaterialsUsed,
            onTap: () => _handleMaterialTap(material['id']),
            onMarkUsed:
                (quantity) => _handleMarkMaterialUsed(material['id'], quantity),
          );
        },
      ),
      tablet: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredMaterials.length,
        itemBuilder: (context, index) {
          final material = _filteredMaterials[index];
          return MaterialListItem(
            name: material['name'],
            category: material['category'],
            unit: material['unit'],
            totalQuantity: material['totalQuantity'],
            usedQuantity: material['usedQuantity'],
            remainingQuantity: material['remainingQuantity'],
            unitPrice: material['unitPrice'],
            isLowStock: material['isLowStock'],
            isLeftover: material['status'] == 'leftover',
            canMarkAsUsed: widget.currentUser.canMarkMaterialsUsed,
            onTap: () => _handleMaterialTap(material['id']),
            onMarkUsed:
                (quantity) => _handleMarkMaterialUsed(material['id'], quantity),
          );
        },
      ),
      desktop: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredMaterials.length,
        itemBuilder: (context, index) {
          final material = _filteredMaterials[index];
          return MaterialListItem(
            name: material['name'],
            category: material['category'],
            unit: material['unit'],
            totalQuantity: material['totalQuantity'],
            usedQuantity: material['usedQuantity'],
            remainingQuantity: material['remainingQuantity'],
            unitPrice: material['unitPrice'],
            isLowStock: material['isLowStock'],
            isLeftover: material['status'] == 'leftover',
            canMarkAsUsed: widget.currentUser.canMarkMaterialsUsed,
            onTap: () => _handleMaterialTap(material['id']),
            onMarkUsed:
                (quantity) => _handleMarkMaterialUsed(material['id'], quantity),
          );
        },
      ),
    );
  }
}
