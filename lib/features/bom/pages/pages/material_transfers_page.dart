import 'package:flutter/material.dart';
import '../../../../core/theme/color_theme.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utilities/utilities.dart';
import '../../../../widgets/common/section_header.dart';
import '../../../../widgets/common/status_badge.dart';

class MaterialTransfersPage extends StatefulWidget {
  final String? projectId;

  const MaterialTransfersPage({super.key, this.projectId});

  @override
  State<MaterialTransfersPage> createState() => _MaterialTransfersPageState();
}

class _MaterialTransfersPageState extends State<MaterialTransfersPage> {
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
            const SectionHeader(title: 'Material Transfers'),
            const SizedBox(height: 8),
            Text(
              'Manage material transfers between projects',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: Utils.spacing_lg),
            _buildTransfersList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new transfer creation
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTransfersList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildTransfersHeader(),
          const Divider(height: 1),
          _buildTransfersTable(),
        ],
      ),
    );
  }

  Widget _buildTransfersHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('All Transfers', style: AppTextStyles.heading5),
          Row(
            children: [
              _buildFilterButton('All'),
              const SizedBox(width: 8),
              _buildFilterButton('In Progress'),
              const SizedBox(width: 8),
              _buildFilterButton('Completed'),
              const SizedBox(width: 8),
              _buildFilterButton('Cancelled'),
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

  Widget _buildTransfersTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Transfer ID')),
          DataColumn(label: Text('From Project')),
          DataColumn(label: Text('To Project')),
          DataColumn(label: Text('Material')),
          DataColumn(label: Text('Quantity')),
          DataColumn(label: Text('Requested By')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          // Example row - TODO: Replace with dynamic data
          DataRow(
            cells: [
              const DataCell(Text('#TRF-001')),
              const DataCell(Text('Project A')),
              const DataCell(Text('Project B')),
              const DataCell(Text('Steel Beams')),
              const DataCell(Text('10 units')),
              const DataCell(Text('John Doe')),
              const DataCell(Text('2024-03-20')),
              DataCell(StatusBadge.pending('In Progress')),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, size: 20),
                      onPressed: () {
                        _showTransferDetails();
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

  void _showTransferDetails() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Transfer Details', style: AppTextStyles.heading4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Transfer ID', '#TRF-001'),
                _buildDetailRow('From Project', 'Project A'),
                _buildDetailRow('To Project', 'Project B'),
                _buildDetailRow('Material', 'Steel Beams'),
                _buildDetailRow('Quantity', '10 units'),
                _buildDetailRow('Requested By', 'John Doe'),
                _buildDetailRow('Date', '2024-03-20'),
                _buildDetailRow('Status', 'In Progress'),
                _buildDetailRow(
                  'Reason',
                  'Excess materials available in Project A',
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
            title: Text('Approve Transfer', style: AppTextStyles.heading4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to approve this transfer?',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Comments (Optional)',
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
                  // TODO: Implement approval logic
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                child: const Text('Approve'),
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
            title: Text('Reject Transfer', style: AppTextStyles.heading4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to reject this transfer?',
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
