import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';
import '../../../widgets/common/empty_state.dart';
import '../../../widgets/common/section_header.dart';

class ShoppingListPage extends StatefulWidget {
  final String? projectId;

  const ShoppingListPage({super.key, this.projectId});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _shoppingItems = [];
  final Set<String> _selectedItems = <String>{};
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  Future<void> _loadShoppingList() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data
    setState(() {
      _shoppingItems = [
        {
          'id': '1',
          'material': 'Cement',
          'category': 'Cement & Aggregates',
          'quantity': 50,
          'unit': 'Bag',
          'unitPrice': 85.0,
          'totalPrice': 4250.0,
          'projects': ['Office Building Phase 1', 'Residential Complex B'],
          'priority': 'high',
        },
        {
          'id': '2',
          'material': 'Sand',
          'category': 'Cement & Aggregates',
          'quantity': 30,
          'unit': 'Ton',
          'unitPrice': 120.0,
          'totalPrice': 3600.0,
          'projects': ['Office Building Phase 1'],
          'priority': 'medium',
        },
        {
          'id': '3',
          'material': 'Bricks',
          'category': 'Masonry',
          'quantity': 2000,
          'unit': 'Each',
          'unitPrice': 5.0,
          'totalPrice': 10000.0,
          'projects': ['Residential Complex A', 'School Renovation'],
          'priority': 'high',
        },
        {
          'id': '4',
          'material': 'Paint',
          'category': 'Paint & Finishing',
          'quantity': 25,
          'unit': 'Bucket',
          'unitPrice': 350.0,
          'totalPrice': 8750.0,
          'projects': ['School Renovation'],
          'priority': 'low',
        },
        {
          'id': '5',
          'material': 'Tiles',
          'category': 'Flooring & Tiling',
          'quantity': 500,
          'unit': 'Sq.m',
          'unitPrice': 45.0,
          'totalPrice': 22500.0,
          'projects': ['Office Building Phase 1', 'Residential Complex A'],
          'priority': 'medium',
        },
      ];
      _isLoading = false;
    });
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      if (_selectAll) {
        _selectedItems.clear();
        for (var item in _shoppingItems) {
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
        if (_selectedItems.length == _shoppingItems.length) {
          _selectAll = true;
        }
      }
    });
  }

  void _addToCart() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select items to add to cart'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // In a real app, this would send the selected items to a cart service
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedItems.length} items added to cart'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }

  double get _totalSelected {
    double total = 0;
    for (var item in _shoppingItems) {
      if (_selectedItems.contains(item['id'])) {
        total += item['totalPrice'];
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textButton,
      ),
      backgroundColor: AppColors.background,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _shoppingItems.isEmpty
              ? const EmptyState(
                icon: Icons.shopping_bag_outlined,
                title: 'Shopping List Empty',
                message: 'No materials need to be purchased at this time.',
              )
              : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: Utils.pagePadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: Utils.spacing_lg),
                          ..._buildShoppingList(),
                        ],
                      ),
                    ),
                  ),
                  if (_selectedItems.isNotEmpty) _buildBottomBar(),
                ],
              ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Shopping List'),
        const SizedBox(height: Utils.spacing_sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_shoppingItems.length} materials to purchase',
              style: AppTextStyles.bodyMedium,
            ),
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

  List<Widget> _buildShoppingList() {
    return _shoppingItems.map((item) {
      final bool isSelected = _selectedItems.contains(item['id']);

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
            Padding(
              padding: Utils.paddingMD,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['material'],
                                    style: AppTextStyles.heading4,
                                  ),
                                  const SizedBox(height: Utils.spacing_xs),
                                  Text(
                                    item['category'],
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            _buildPriorityBadge(item['priority']),
                          ],
                        ),
                        const SizedBox(height: Utils.spacing_md),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoColumn(
                                'Quantity',
                                '${item['quantity']} ${item['unit']}',
                              ),
                            ),
                            Expanded(
                              child: _buildInfoColumn(
                                'Unit Price',
                                Utils.formatCurrency(item['unitPrice']),
                              ),
                            ),
                            Expanded(
                              child: _buildInfoColumn(
                                'Total',
                                Utils.formatCurrency(item['totalPrice']),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Utils.spacing_md),
                        _buildProjectsList(item['projects']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildPriorityBadge(String priority) {
    Color color;
    String text;

    switch (priority) {
      case 'high':
        color = AppColors.error;
        text = 'High Priority';
        break;
      case 'medium':
        color = AppColors.warning;
        text = 'Medium Priority';
        break;
      case 'low':
        color = AppColors.success;
        text = 'Low Priority';
        break;
      default:
        color = AppColors.textSecondary;
        text = 'Normal Priority';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Utils.spacing_sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: Utils.borderSM,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
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
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildProjectsList(List<dynamic> projects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Required for:',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: Utils.spacing_sm,
          runSpacing: 4,
          children:
              projects.map<Widget>((project) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_selectedItems.length} items selected',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  'Total: ${Utils.formatCurrency(_totalSelected)}',
                  style: AppTextStyles.heading4,
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: Utils.spacing_md,
                vertical: Utils.spacing_sm,
              ),
            ),
            icon: const Icon(Icons.shopping_cart),
            label: const Text('ADD TO CART'),
          ),
        ],
      ),
    );
  }
}
