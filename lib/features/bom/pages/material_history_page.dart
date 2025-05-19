import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';
import '../../../widgets/common/empty_state.dart';
import '../../../widgets/common/section_header.dart';

class MaterialHistoryPage extends StatefulWidget {
  final String materialId;
  final String materialName;

  const MaterialHistoryPage({
    super.key,
    required this.materialId,
    required this.materialName,
  });

  @override
  State<MaterialHistoryPage> createState() => _MaterialHistoryPageState();
}

class _MaterialHistoryPageState extends State<MaterialHistoryPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  List<Map<String, dynamic>> _historyItems = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMaterialHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMaterialHistory() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data
    setState(() {
      _historyItems = [
        {
          'id': '1',
          'type': 'usage',
          'quantity': 25,
          'unit': 'Bag',
          'project': 'Office Building Phase 1',
          'user': 'John Smith',
          'date': DateTime.now().subtract(const Duration(days: 2)),
          'notes': 'Used for foundation work in Block A',
        },
        {
          'id': '2',
          'type': 'purchase',
          'quantity': 100,
          'unit': 'Bag',
          'supplier': 'ABC Suppliers Ltd',
          'cost': 8500.0,
          'user': 'Sarah Johnson',
          'date': DateTime.now().subtract(const Duration(days: 5)),
          'notes': 'Bulk purchase with 5% discount',
        },
        {
          'id': '3',
          'type': 'usage',
          'quantity': 15,
          'unit': 'Bag',
          'project': 'Residential Complex A',
          'user': 'Mike Thompson',
          'date': DateTime.now().subtract(const Duration(days: 7)),
          'notes': 'Used for repair work',
        },
        {
          'id': '4',
          'type': 'transfer',
          'quantity': 50,
          'unit': 'Bag',
          'fromProject': 'Office Building Phase 1',
          'toProject': 'School Renovation',
          'user': 'Lisa Rogers',
          'date': DateTime.now().subtract(const Duration(days: 10)),
          'notes': 'Transferred due to urgent requirement',
        },
        {
          'id': '5',
          'type': 'purchase',
          'quantity': 200,
          'unit': 'Bag',
          'supplier': 'XYZ Cement Co.',
          'cost': 16000.0,
          'user': 'Admin',
          'date': DateTime.now().subtract(const Duration(days: 15)),
          'notes': 'Initial stock purchase',
        },
      ];
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _usageHistory {
    return _historyItems
        .where((item) => item['type'] == 'usage' || item['type'] == 'transfer')
        .toList();
  }

  List<Map<String, dynamic>> get _purchaseHistory {
    return _historyItems.where((item) => item['type'] == 'purchase').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.materialName} History'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textButton,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'USAGE HISTORY'),
            Tab(text: 'PURCHASE HISTORY'),
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [_buildUsageHistoryTab(), _buildPurchaseHistoryTab()],
              ),
    );
  }

  Widget _buildUsageHistoryTab() {
    if (_usageHistory.isEmpty) {
      return const EmptyState(
        icon: Icons.history_outlined,
        title: 'No Usage History',
        message: 'There is no usage history for this material.',
      );
    }

    return SingleChildScrollView(
      padding: Utils.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Usage History'),
          const SizedBox(height: Utils.spacing_md),
          ..._buildHistoryTimeline(_usageHistory),
        ],
      ),
    );
  }

  Widget _buildPurchaseHistoryTab() {
    if (_purchaseHistory.isEmpty) {
      return const EmptyState(
        icon: Icons.shopping_cart_outlined,
        title: 'No Purchase History',
        message: 'There is no purchase history for this material.',
      );
    }

    return SingleChildScrollView(
      padding: Utils.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Purchase History'),
          const SizedBox(height: Utils.spacing_md),
          ..._buildHistoryTimeline(_purchaseHistory),
        ],
      ),
    );
  }

  List<Widget> _buildHistoryTimeline(List<Map<String, dynamic>> items) {
    final List<Widget> timeline = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      timeline.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimelineIndicator(i == 0),
            const SizedBox(width: Utils.spacing_md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHistoryCard(item),
                  if (i < items.length - 1)
                    const SizedBox(height: Utils.spacing_lg),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return timeline;
  }

  Widget _buildTimelineIndicator(bool isFirst) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cardBackground, width: 3),
          ),
        ),
        if (!isFirst)
          Container(
            width: 2,
            height: 100,
            color: AppColors.border,
            margin: const EdgeInsets.only(top: -6, bottom: -6),
          ),
      ],
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    return Container(
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
          _buildHistoryCardHeader(item),
          Padding(
            padding: Utils.paddingMD,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHistoryCardDetails(item),
                if (item['notes'] != null && item['notes'].isNotEmpty) ...[
                  const SizedBox(height: Utils.spacing_sm),
                  const Divider(),
                  const SizedBox(height: Utils.spacing_sm),
                  Text(
                    'Notes',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(item['notes'], style: AppTextStyles.bodyMedium),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCardHeader(Map<String, dynamic> item) {
    Color headerColor;
    IconData headerIcon;
    String headerText;

    switch (item['type']) {
      case 'usage':
        headerColor = AppColors.warning;
        headerIcon = Icons.remove_circle_outline;
        headerText = 'Used';
        break;
      case 'purchase':
        headerColor = AppColors.success;
        headerIcon = Icons.add_circle_outline;
        headerText = 'Purchased';
        break;
      case 'transfer':
        headerColor = AppColors.info;
        headerIcon = Icons.swap_horiz;
        headerText = 'Transferred';
        break;
      default:
        headerColor = AppColors.textSecondary;
        headerIcon = Icons.circle_outlined;
        headerText = 'Updated';
    }

    return Container(
      padding: Utils.paddingMD,
      decoration: BoxDecoration(
        color: headerColor.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Utils.borderRadiusMD),
          topRight: Radius.circular(Utils.borderRadiusMD),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(headerIcon, color: headerColor, size: 18),
              const SizedBox(width: Utils.spacing_sm),
              Text(
                headerText,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: headerColor,
                ),
              ),
            ],
          ),
          Text(Utils.formatDate(item['date']), style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildHistoryCardDetails(Map<String, dynamic> item) {
    final List<Widget> details = [];

    // Add quantity info for all types
    details.add(
      _buildDetailRow('Quantity', '${item['quantity']} ${item['unit']}'),
    );

    // Add type-specific info
    switch (item['type']) {
      case 'usage':
        details.add(_buildDetailRow('Project', item['project']));
        break;
      case 'purchase':
        details.add(_buildDetailRow('Supplier', item['supplier']));
        details.add(
          _buildDetailRow('Cost', Utils.formatCurrency(item['cost'])),
        );
        break;
      case 'transfer':
        details.add(_buildDetailRow('From', item['fromProject']));
        details.add(_buildDetailRow('To', item['toProject']));
        break;
    }

    // Add user info for all types
    details.add(_buildDetailRow('Recorded by', item['user']));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Utils.spacing_sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
