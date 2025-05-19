import 'package:flutter/material.dart';
import '../../../../core/theme/color_theme.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utilities/utilities.dart';
import '../../../../widgets/common/section_header.dart';
import '../../../../widgets/common/status_badge.dart';

class MaterialReturnsPage extends StatefulWidget {
  final String? projectId;

  const MaterialReturnsPage({super.key, this.projectId});

  @override
  State<MaterialReturnsPage> createState() => _MaterialReturnsPageState();
}

class _MaterialReturnsPageState extends State<MaterialReturnsPage> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: Utils.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Material Returns'),
            const SizedBox(height: 8),
            Text(
              'Process returned materials and manage inventory',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: Utils.spacing_lg),
            _buildReturnsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new return creation
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildReturnsList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildReturnsHeader(),
          const Divider(height: 1),
          _buildReturnsTable(),
        ],
      ),
    );
  }

  Widget _buildReturnsHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('All Returns', style: AppTextStyles.heading5),
          Row(
            children: [
              _buildFilterButton('All'),
              const SizedBox(width: 8),
              _buildFilterButton('Pending'),
              const SizedBox(width: 8),
              _buildFilterButton('Processed'),
              const SizedBox(width: 8),
              _buildFilterButton('Rejected'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildReturnsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Return ID')),
          DataColumn(label: Text('Project')),
          DataColumn(label: Text('Material')),
          DataColumn(label: Text('Quantity')),
          DataColumn(label: Text('Returned By')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          // Example row - TODO: Replace with dynamic data
          DataRow(
            cells: [
              const DataCell(Text('#RET-001')),
              const DataCell(Text('Project A')),
              const DataCell(Text('Wood Planks')),
              const DataCell(Text('20 units')),
              const DataCell(Text('John Doe')),
              const DataCell(Text('2024-03-20')),
              DataCell(StatusBadge.pending('Pending')),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, size: 20),
                      onPressed: () {
                        _showReturnDetails();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline, size: 20),
                      color: AppColors.success,
                      onPressed: () {
                        _showApproveDialog();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined, size: 20),
                      color: AppColors.error,
                      onPressed: () {
                        _showRejectDialog();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReturnDetails() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Return Details', style: AppTextStyles.heading4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Return ID', '#RET-001'),
                _buildDetailRow('Project', 'Project A'),
                _buildDetailRow('Material', 'Wood Planks'),
                _buildDetailRow('Quantity', '20 units'),
                _buildDetailRow('Returned By', 'John Doe'),
                _buildDetailRow('Date', '2024-03-20'),
                _buildDetailRow('Status', 'Pending'),
                _buildDetailRow('Condition', 'Good'),
                _buildDetailRow(
                  'Reason',
                  'Excess materials from completed work',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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

  void _showApproveDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Process Return', style: AppTextStyles.heading4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to process this return?',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Condition Notes',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Storage Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement processing logic
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                child: const Text('Process'),
              ),
            ],
          ),
    );
  }

  void _showRejectDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Reject Return', style: AppTextStyles.heading4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to reject this return?',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Reason for Rejection',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement rejection logic
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Reject'),
              ),
            ],
          ),
    );
  }
}
