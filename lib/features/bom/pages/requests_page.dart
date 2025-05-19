import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';
import '../../../widgets/common/empty_state.dart';
import '../../../widgets/common/section_header.dart';
import '../../../widgets/common/status_badge.dart';

class RequestsPage extends StatefulWidget {
  final String? projectId;

  const RequestsPage({super.key, this.projectId});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data
    setState(() {
      _requests = [
        {
          'id': '1',
          'material': 'Cement',
          'category': 'Cement & Aggregates',
          'quantity': 20,
          'unit': 'Bag',
          'projectName': 'Office Building Phase 1',
          'requester': 'John Smith',
          'status': 'pending',
          'date': DateTime.now().subtract(const Duration(days: 1)),
          'reason': 'Need additional cement for foundation work',
          'available': 15,
          'unavailable': 5,
        },
        {
          'id': '2',
          'material': 'Bricks',
          'category': 'Masonry',
          'quantity': 500,
          'unit': 'Each',
          'projectName': 'Residential Complex A',
          'requester': 'Sarah Johnson',
          'status': 'pending',
          'date': DateTime.now().subtract(const Duration(days: 2)),
          'reason': 'Wall construction for Building B',
          'available': 300,
          'unavailable': 200,
        },
        {
          'id': '3',
          'material': 'Steel Bars',
          'category': 'Metals & Steel',
          'quantity': 100,
          'unit': 'Kg',
          'projectName': 'Bridge Construction',
          'requester': 'Mike Thompson',
          'status': 'approved',
          'date': DateTime.now().subtract(const Duration(days: 5)),
          'reason': 'Reinforcement for concrete pillars',
          'available': 100,
          'unavailable': 0,
        },
        {
          'id': '4',
          'material': 'Paint',
          'category': 'Paint & Finishing',
          'quantity': 15,
          'unit': 'Bucket',
          'projectName': 'School Renovation',
          'requester': 'Lisa Rogers',
          'status': 'rejected',
          'date': DateTime.now().subtract(const Duration(days: 3)),
          'reason': 'Interior walls finish',
          'available': 0,
          'unavailable': 0,
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Requests'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textButton,
      ),
      backgroundColor: AppColors.background,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _requests.isEmpty
              ? const EmptyState(
                icon: Icons.request_page_outlined,
                title: 'No Material Requests',
                message: 'There are no pending material requests.',
              )
              : SingleChildScrollView(
                padding: Utils.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Material Requests'),
                    const SizedBox(height: Utils.spacing_lg),
                    ..._buildRequestsList(),
                  ],
                ),
              ),
    );
  }

  List<Widget> _buildRequestsList() {
    return _requests.map((request) {
      return Container(
        margin: const EdgeInsets.only(bottom: Utils.spacing_md),
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
            Padding(
              padding: Utils.paddingMD,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request['material'],
                          style: AppTextStyles.heading4,
                        ),
                        const SizedBox(height: Utils.spacing_xs),
                        Text(
                          request['category'],
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    text: _getStatusText(request['status']),
                    type: _getStatusType(request['status']),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: Utils.paddingMD,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    'Quantity',
                    '${request['quantity']} ${request['unit']}',
                  ),
                  _buildInfoRow('Project', request['projectName']),
                  _buildInfoRow('Requester', request['requester']),
                  _buildInfoRow('Date', Utils.formatDate(request['date'])),
                  _buildInfoRow('Reason', request['reason']),
                  const SizedBox(height: Utils.spacing_md),
                  if (request['status'] == 'pending')
                    _buildAvailabilitySection(request),
                  if (request['status'] == 'pending')
                    _buildActionButtons(request),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  StatusType _getStatusType(String status) {
    switch (status) {
      case 'pending':
        return StatusType.pending;
      case 'approved':
        return StatusType.approved;
      case 'rejected':
        return StatusType.rejected;
      default:
        return StatusType.custom;
    }
  }

  Widget _buildInfoRow(String label, String value) {
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

  Widget _buildAvailabilitySection(Map<String, dynamic> request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Material Availability', style: AppTextStyles.label),
        const SizedBox(height: Utils.spacing_sm),
        Row(
          children: [
            Expanded(
              child: _buildAvailabilityCard(
                'Available',
                '${request['available']} ${request['unit']}',
                AppColors.success,
              ),
            ),
            const SizedBox(width: Utils.spacing_sm),
            Expanded(
              child: _buildAvailabilityCard(
                'Need to Purchase',
                '${request['unavailable']} ${request['unit']}',
                request['unavailable'] > 0
                    ? AppColors.warning
                    : AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: Utils.spacing_md),
      ],
    );
  }

  Widget _buildAvailabilityCard(String label, String value, Color color) {
    return Container(
      padding: Utils.paddingSM,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: Utils.borderSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          const SizedBox(height: Utils.spacing_xs),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> request) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _handleApproveRequest(request),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: Utils.spacing_sm),
            ),
            child: const Text('Approve'),
          ),
        ),
        const SizedBox(width: Utils.spacing_sm),
        Expanded(
          child: OutlinedButton(
            onPressed: () => _handleRejectRequest(request),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: Utils.spacing_sm),
            ),
            child: const Text('Reject'),
          ),
        ),
      ],
    );
  }

  void _handleApproveRequest(Map<String, dynamic> request) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Approve Request'),
          content: Text(
            'Are you sure you want to approve the request for ${request['quantity']} ${request['unit']} of ${request['material']}?\n\n'
            'Available: ${request['available']} ${request['unit']}\n'
            'Need to Purchase: ${request['unavailable']} ${request['unit']}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Process approval
                setState(() {
                  request['status'] = 'approved';
                });
                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Request for ${request['material']} approved. ${request['unavailable']} ${request['unit']} added to shopping list.',
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.success),
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );
  }

  void _handleRejectRequest(Map<String, dynamic> request) {
    // Show rejection dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String reason = '';
        return AlertDialog(
          title: const Text('Reject Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to reject the request for ${request['quantity']} ${request['unit']} of ${request['material']}?',
              ),
              const SizedBox(height: Utils.spacing_md),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Reason for rejection',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  reason = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Process rejection
                setState(() {
                  request['status'] = 'rejected';
                  request['rejectionReason'] = reason;
                });
                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Request for ${request['material']} rejected.',
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }
}
