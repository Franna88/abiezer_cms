import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';
import '../../../widgets/common/empty_state.dart';
import '../../../widgets/common/responsive_layout.dart';
import '../../../widgets/common/section_header.dart';
import 'material_history_page.dart';

class MaterialInventoryPage extends StatefulWidget {
  final String? projectId;

  const MaterialInventoryPage({super.key, this.projectId});

  @override
  State<MaterialInventoryPage> createState() => _MaterialInventoryPageState();
}

class _MaterialInventoryPageState extends State<MaterialInventoryPage> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _materials = [];
  String _searchQuery = '';
  String _selectedCategory = 'All Categories';
  final List<String> _categories = [
    'All Categories',
    'Cement & Aggregates',
    'Masonry',
    'Metals & Steel',
    'Boards & Sheets',
    'Paint & Finishing',
    'Flooring & Tiling',
    'Hardware & Fixings',
    'Electrical',
    'Plumbing',
  ];

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  Future<void> _loadMaterials() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data
    setState(() {
      _materials = [
        {
          'id': '1',
          'name': 'Cement',
          'category': 'Cement & Aggregates',
          'unit': 'Bag',
          'totalQuantity': 500,
          'usedQuantity': 275,
          'remainingQuantity': 225,
          'unitPrice': 85.0,
          'status': 'normal',
          'isLowStock': false,
        },
        {
          'id': '2',
          'name': 'Sand',
          'category': 'Cement & Aggregates',
          'unit': 'Ton',
          'totalQuantity': 100,
          'usedQuantity': 65,
          'remainingQuantity': 35,
          'unitPrice': 120.0,
          'status': 'normal',
          'isLowStock': false,
        },
        {
          'id': '3',
          'name': 'Bricks',
          'category': 'Masonry',
          'unit': 'Each',
          'totalQuantity': 10000,
          'usedQuantity': 9500,
          'remainingQuantity': 500,
          'unitPrice': 5.0,
          'status': 'low',
          'isLowStock': true,
        },
        {
          'id': '4',
          'name': 'Steel Bars',
          'category': 'Metals & Steel',
          'unit': 'Kg',
          'totalQuantity': 2000,
          'usedQuantity': 1200,
          'remainingQuantity': 800,
          'unitPrice': 25.0,
          'status': 'normal',
          'isLowStock': false,
        },
        {
          'id': '5',
          'name': 'Tiles',
          'category': 'Flooring & Tiling',
          'unit': 'Sq.m',
          'totalQuantity': 500,
          'usedQuantity': 350,
          'remainingQuantity': 150,
          'unitPrice': 45.0,
          'status': 'normal',
          'isLowStock': false,
        },
        {
          'id': '6',
          'name': 'Paint',
          'category': 'Paint & Finishing',
          'unit': 'Bucket',
          'totalQuantity': 50,
          'usedQuantity': 48,
          'remainingQuantity': 2,
          'unitPrice': 350.0,
          'status': 'low',
          'isLowStock': true,
        },
        {
          'id': '7',
          'name': 'Electrical Wires',
          'category': 'Electrical',
          'unit': 'Roll',
          'totalQuantity': 25,
          'usedQuantity': 25,
          'remainingQuantity': 0,
          'unitPrice': 1200.0,
          'status': 'out',
          'isLowStock': true,
        },
        {
          'id': '8',
          'name': 'PVC Pipes',
          'category': 'Plumbing',
          'unit': 'Length',
          'totalQuantity': 200,
          'usedQuantity': 180,
          'remainingQuantity': 20,
          'unitPrice': 75.0,
          'status': 'low',
          'isLowStock': true,
        },
      ];
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredMaterials {
    return _materials.where((material) {
      // Filter by search query
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

      return true;
    }).toList();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _updateSelectedCategory(String? category) {
    if (category != null) {
      setState(() {
        _selectedCategory = category;
      });
    }
  }

  void _viewMaterialHistory(Map<String, dynamic> material) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MaterialHistoryPage(
              materialId: material['id'],
              materialName: material['name'],
            ),
      ),
    );
  }

  void _addNewMaterial() {
    // In a real app, this would navigate to a form to add a new material
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add new material functionality coming soon'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Inventory'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textButton,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewMaterial,
            tooltip: 'Add New Material',
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _materials.isEmpty
              ? const EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'No Materials',
                message: 'There are no materials in the inventory.',
              )
              : Column(
                children: [
                  _buildFilters(),
                  Expanded(
                    child:
                        _filteredMaterials.isEmpty
                            ? const Center(
                              child: Text('No materials match your filters'),
                            )
                            : SingleChildScrollView(
                              padding: Utils.pagePadding,
                              child: ResponsiveLayout(
                                mobile: _buildMaterialGrid(context, 1),
                                tablet: _buildMaterialGrid(context, 2),
                                desktop: _buildMaterialGrid(context, 3),
                              ),
                            ),
                  ),
                ],
              ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: Utils.paddingMD,
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search materials...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  onChanged: _updateSearchQuery,
                ),
              ),
              const SizedBox(width: Utils.spacing_md),
              DropdownButton<String>(
                value: _selectedCategory,
                hint: const Text('Category'),
                onChanged: _updateSelectedCategory,
                items:
                    _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
              ),
            ],
          ),
          const SizedBox(height: Utils.spacing_sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${_filteredMaterials.length} materials',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialGrid(BuildContext context, int crossAxisCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: Utils.spacing_md,
        mainAxisSpacing: Utils.spacing_md,
        childAspectRatio: 1,
      ),
      itemCount: _filteredMaterials.length,
      itemBuilder: (context, index) {
        final material = _filteredMaterials[index];
        return _buildMaterialCard(material);
      },
    );
  }

  Widget _buildMaterialCard(Map<String, dynamic> material) {
    final double usagePercentage =
        material['totalQuantity'] > 0
            ? material['usedQuantity'] / material['totalQuantity']
            : 0;

    Color statusColor;
    switch (material['status']) {
      case 'low':
        statusColor = AppColors.warning;
        break;
      case 'out':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.success;
    }

    return GestureDetector(
      onTap: () => _viewMaterialHistory(material),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: Utils.borderMD,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: Utils.paddingMD,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Utils.borderRadiusMD),
                  topRight: Radius.circular(Utils.borderRadiusMD),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          material['name'],
                          style: AppTextStyles.heading4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          material['category'],
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: Utils.paddingMD,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuantityInfo(
                      'Remaining',
                      '${material['remainingQuantity']} ${material['unit']}',
                      statusColor,
                    ),
                    const SizedBox(height: Utils.spacing_sm),
                    _buildQuantityInfo(
                      'Used',
                      '${material['usedQuantity']} ${material['unit']}',
                      AppColors.textSecondary,
                    ),
                    const SizedBox(height: Utils.spacing_md),
                    _buildProgressBar(usagePercentage, statusColor),
                    const SizedBox(height: Utils.spacing_sm),
                    Text(
                      'Unit Cost: ${Utils.formatCurrency(material['unitPrice'])}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => _viewMaterialHistory(material),
              child: Container(
                width: double.infinity,
                padding: Utils.paddingSM,
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Center(
                  child: Text(
                    'View History',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityInfo(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double percentage, Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Usage', style: AppTextStyles.bodySmall),
        const SizedBox(height: 4),
        Stack(
          children: [
            // Background
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.progressBackground,
                borderRadius: Utils.borderSM,
              ),
            ),
            // Progress
            Container(
              height: 8,
              width: percentage * MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: Utils.borderSM,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${(percentage * 100).toInt()}%',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
