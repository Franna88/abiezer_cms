import 'package:flutter/material.dart';
import '../../../../core/theme/color_theme.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utilities/utilities.dart';
import '../../../../widgets/common/section_header.dart';

class AuditTrailPage extends StatefulWidget {
  final String? projectId;

  const AuditTrailPage({super.key, this.projectId});

  @override
  State<AuditTrailPage> createState() => _AuditTrailPageState();
}

class _AuditTrailPageState extends State<AuditTrailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: Utils.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Audit Trail'),
            const SizedBox(height: 8),
            Text(
              'Review all system actions and changes',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: Utils.spacing_lg),
            _buildAuditTrailList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditTrailList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildAuditTrailHeader(),
          const Divider(height: 1),
          _buildAuditTrailTable(),
        ],
      ),
    );
  }

  Widget _buildAuditTrailHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('All Actions', style: AppTextStyles.heading4),
          Row(
            children: [
              _buildSearchField(),
              const SizedBox(width: 16),
              _buildFilterButton('All'),
              const SizedBox(width: 8),
              _buildFilterButton('Material Changes'),
              const SizedBox(width: 8),
              _buildFilterButton('User Actions'),
              const SizedBox(width: 8),
              _buildFilterButton('System Events'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search actions...',
          prefixIcon: const Icon(Icons.search, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          hintStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        style: AppTextStyles.bodySmall,
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.warning,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAuditTrailTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Timestamp')),
          DataColumn(label: Text('Action')),
          DataColumn(label: Text('User')),
          DataColumn(label: Text('Entity')),
          DataColumn(label: Text('Details')),
          DataColumn(label: Text('Status')),
        ],
        rows: const [
          // TODO: Implement dynamic rows based on data
          DataRow(
            cells: [
              DataCell(Text('2024-03-20 14:30')),
              DataCell(Text('Material Updated')),
              DataCell(Text('John Doe')),
              DataCell(Text('Cement')),
              DataCell(Text('Updated stock level')),
              DataCell(Text('Success')),
            ],
          ),
        ],
      ),
    );
  }
}
