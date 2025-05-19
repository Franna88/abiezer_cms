import 'package:flutter/material.dart';
import '../../../../core/theme/color_theme.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utilities/utilities.dart';
import '../../../../widgets/common/section_header.dart';
import '../../../../widgets/common/status_badge.dart';

class MaterialRequestsPage extends StatefulWidget {
  final String? projectId;

  const MaterialRequestsPage({super.key, this.projectId});

  @override
  State<MaterialRequestsPage> createState() => _MaterialRequestsPageState();
}

class _MaterialRequestsPageState extends State<MaterialRequestsPage> {
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
            const SectionHeader(title: 'Material Requests'),
            const SizedBox(height: 8),
            Text(
              'Review and manage material requests from projects',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: Utils.spacing_lg),
            _buildRequestsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new request creation
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRequestsList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildRequestsHeader(),
          const Divider(height: 1),
          _buildRequestsTable(),
        ],
      ),
    );
  }

  Widget _buildRequestsHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('All Requests', style: AppTextStyles.heading5),
          Row(
            children: [
              _buildFilterButton('All'),
              const SizedBox(width: 8),
              _buildFilterButton('Pending'),
              const SizedBox(width: 8),
              _buildFilterButton('Approved'),
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

  Widget _buildRequestsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Request ID')),
          DataColumn(label: Text('Project')),
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
              const DataCell(Text('#REQ-001')),
              const DataCell(Text('Project A')),
              const DataCell(Text('Cement')),
              const DataCell(Text('50 bags')),
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
                        _showRequestDetails();
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
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      color: AppColors.warning,
                      onPressed: () {
                        _showAdjustDialog();
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

  void _showRequestDetails() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Request Details', style: AppTextStyles.heading4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Request ID', '#REQ-001'),
                _buildDetailRow('Project', 'Project A'),
                _buildDetailRow('Material', 'Cement'),
                _buildDetailRow('Quantity', '50 bags'),
                _buildDetailRow('Requested By', 'John Doe'),
                _buildDetailRow('Date', '2024-03-20'),
                _buildDetailRow('Status', 'Pending'),
                _buildDetailRow(
                  'Reason',
                  'Running low on cement for foundation work',
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
            title: Text('Approve Request', style: AppTextStyles.heading4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to approve this request?',
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
            title: Text('Reject Request', style: AppTextStyles.heading4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to reject this request?',
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

  void _showAdjustDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Adjust Request', style: AppTextStyles.heading4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Adjust the requested quantity',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'New Quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Reason for Adjustment',
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
                  // TODO: Implement adjustment logic
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                ),
                child: const Text('Adjust'),
              ),
            ],
          ),
    );
  }
}
