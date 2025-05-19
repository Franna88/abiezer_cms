import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';
import '../../../widgets/common/empty_state.dart';
import '../../../widgets/common/section_header.dart';

class LowStockPage extends StatefulWidget {
  final String? projectId;

  const LowStockPage({super.key, this.projectId});

  @override
  State<LowStockPage> createState() => _LowStockPageState();
}

class _LowStockPageState extends State<LowStockPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  List<Map<String, dynamic>> _lowStockItems = [];
  late TabController _tabController;
  final Set<String> _selectedItems = <String>{};
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLowStockItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLowStockItems() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data
    setState(() {
      _lowStockItems = [
        {
          'id': '1',
          'name': 'Cement',
          'category': 'Cement & Aggregates',
          'unit': 'Bag',
          'remainingQuantity': 25,
          'threshold': 50,
          'unitPrice': 85.0,
          'status': 'low',
          'projects': ['Office Building Phase 1', 'Residential Complex A'],
        },
        {
          'id': '2',
          'name': 'Paint',
          'category': 'Paint & Finishing',
          'unit': 'Bucket',
          'remainingQuantity': 2,
          'threshold': 10,
          'unitPrice': 350.0,
          'status': 'low',
          'projects': ['School Renovation'],
        },
        {
          'id': '3',
          'name': 'Bricks',
          'category': 'Masonry',
          'unit': 'Each',
          'remainingQuantity': 500,
          'threshold': 1000,
          'unitPrice': 5.0,
          'status': 'low',
          'projects': ['Residential Complex A', 'Office Building Phase 1'],
        },
        {
          'id': '4',
          'name': 'Electrical Wires',
          'category': 'Electrical',
          'unit': 'Roll',
          'remainingQuantity': 0,
          'threshold': 5,
          'unitPrice': 1200.0,
          'status': 'out',
          'projects': ['Bridge Construction'],
        },
        {
          'id': '5',
          'name': 'PVC Pipes',
          'category': 'Plumbing',
          'unit': 'Length',
          'remainingQuantity': 0,
          'threshold': 20,
          'unitPrice': 75.0,
          'status': 'out',
          'projects': ['Residential Complex A'],
        },
      ];
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _lowStockMaterials {
    return _lowStockItems.where((item) => item['status'] == 'low').toList();
  }

  List<Map<String, dynamic>> get _outOfStockMaterials {
    return _lowStockItems.where((item) => item['status'] == 'out').toList();
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;

      final currentTabIndex = _tabController.index;
      final currentList =
          currentTabIndex == 0 ? _lowStockMaterials : _outOfStockMaterials;

      if (_selectAll) {
        _selectedItems.clear();
        for (var item in currentList) {
          _selectedItems.add(item['id']);
        }
      } else {
        _selectedItems.clear();
      }
    });
  }

  void _toggleSelectItem(String id) {
    setState(() {
      if (_selectedItems.contains(id)) {
        _selectedItems.remove(id);
        _selectAll = false;
      } else {
        _selectedItems.add(id);

        final currentTabIndex = _tabController.index;
        final currentList =
            currentTabIndex == 0 ? _lowStockMaterials : _outOfStockMaterials;

        if (_selectedItems.length == currentList.length) {
          _selectAll = true;
        }
      }
    });
  }

  void _addToShoppingList() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select items to add to shopping list'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // In a real app, this would add items to the shopping list
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedItems.length} items added to shopping list'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'VIEW LIST',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to shopping list
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Low & Out of Stock'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textButton,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [Tab(text: 'LOW STOCK'), Tab(text: 'OUT OF STOCK')],
          onTap: (_) {
            // Reset selections when changing tabs
            setState(() {
              _selectedItems.clear();
              _selectAll = false;
            });
          },
        ),
      ),
      backgroundColor: AppColors.background,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [_buildLowStockTab(), _buildOutOfStockTab()],
                    ),
                  ),
                  if (_selectedItems.isNotEmpty) _buildBottomBar(),
                ],
              ),
    );
  }

  Widget _buildLowStockTab() {
    if (_lowStockMaterials.isEmpty) {
      return const EmptyState(
        icon: Icons.check_circle_outline,
        title: 'No Low Stock Items',
        message: 'All materials are above their minimum threshold levels.',
      );
    }

    return SingleChildScrollView(
      padding: Utils.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Low Stock Items', _lowStockMaterials.length),
          const SizedBox(height: Utils.spacing_lg),
          ..._buildMaterialsList(_lowStockMaterials),
        ],
      ),
    );
  }

  Widget _buildOutOfStockTab() {
    if (_outOfStockMaterials.isEmpty) {
      return const EmptyState(
        icon: Icons.check_circle_outline,
        title: 'No Out of Stock Items',
        message: 'All materials have inventory available.',
      );
    }

    return SingleChildScrollView(
      padding: Utils.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Out of Stock Items', _outOfStockMaterials.length),
          const SizedBox(height: Utils.spacing_lg),
          ..._buildMaterialsList(_outOfStockMaterials),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        const SizedBox(height: Utils.spacing_sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$count items found', style: AppTextStyles.bodyMedium),
            Row(
              children: [
                Checkbox(
                  value: _selectAll,
                  onChanged: (_) => _toggleSelectAll(),
                  activeColor: AppColors.primary,
                ),
                GestureDetector(
                  onTap: _toggleSelectAll,
                  child: Text(
                    _selectAll ? 'Deselect All' : 'Select All',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildMaterialsList(List<Map<String, dynamic>> items) {
    return items.map((item) {
      final bool isSelected = _selectedItems.contains(item['id']);
      final bool isOutOfStock = item['status'] == 'out';
      final Color statusColor =
          isOutOfStock ? AppColors.error : AppColors.warning;

      return Container(
        margin: const EdgeInsets.only(bottom: Utils.spacing_md),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: Utils.borderMD,
          border:
              isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
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
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Utils.borderRadiusMD),
                  topRight: Radius.circular(Utils.borderRadiusMD),
                ),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleSelectItem(item['id']),
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name'], style: AppTextStyles.heading4),
                        const SizedBox(height: 4),
                        Text(item['category'], style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Utils.spacing_sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: Utils.borderSM,
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      isOutOfStock ? 'OUT OF STOCK' : 'LOW STOCK',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: Utils.paddingMD,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoColumn(
                          'Current Stock',
                          '${item['remainingQuantity']} ${item['unit']}',
                          isOutOfStock ? AppColors.error : AppColors.warning,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoColumn(
                          'Threshold',
                          '${item['threshold']} ${item['unit']}',
                          AppColors.textSecondary,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoColumn(
                          'Unit Price',
                          Utils.formatCurrency(item['unitPrice']),
                          AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Utils.spacing_md),
                  const Divider(),
                  const SizedBox(height: Utils.spacing_sm),
                  Text(
                    'Required for:',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: Utils.spacing_sm,
                    runSpacing: 4,
                    children:
                        (item['projects'] as List<dynamic>).map<Widget>((
                          project,
                        ) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: Utils.borderSM,
                            ),
                            child: Text(
                              project,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildInfoColumn(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
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

  Widget _buildBottomBar() {
    return Container(
      padding: Utils.paddingMD,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${_selectedItems.length} items selected',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _addToShoppingList,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: Utils.spacing_md,
                vertical: Utils.spacing_sm,
              ),
            ),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('ADD TO SHOPPING LIST'),
          ),
        ],
      ),
    );
  }
}
