import 'package:flutter/material.dart';
import '../../../../core/theme/color_theme.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utilities/utilities.dart';
import '../../../../widgets/common/section_header.dart';
import '../../../../widgets/common/status_badge.dart';

class BomDashboardPage extends StatefulWidget {
  const BomDashboardPage({super.key});

  @override
  State<BomDashboardPage> createState() => _BomDashboardPageState();
}

class _BomDashboardPageState extends State<BomDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: Utils.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'BoM Dashboard'),
            const SizedBox(height: 8),
            Text(
              'Overview of all projects and material management',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: Utils.spacing_lg),
            _buildOverviewCards(),
            const SizedBox(height: Utils.spacing_lg),
            _buildProjectsList(),
            const SizedBox(height: Utils.spacing_lg),
            _buildLowStockAlerts(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildOverviewCard(
          'Total Projects',
          '12',
          Icons.business,
          AppColors.primary,
        ),
        _buildOverviewCard(
          'Active Requests',
          '5',
          Icons.pending_actions,
          AppColors.warning,
        ),
        _buildOverviewCard(
          'Low Stock Items',
          '8',
          Icons.warning,
          AppColors.error,
        ),
        _buildOverviewCard(
          'Total Materials',
          '156',
          Icons.inventory,
          AppColors.success,
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(value, style: AppTextStyles.heading3.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildProjectsList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Active Projects', style: AppTextStyles.heading4),
          ),
          const Divider(height: 1),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Project Name')),
                DataColumn(label: Text('Location')),
                DataColumn(label: Text('Project Manager')),
                DataColumn(label: Text('Total Materials')),
                DataColumn(label: Text('Total Value')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Actions')),
              ],
              rows: [
                // Example row - TODO: Replace with dynamic data
                DataRow(
                  cells: [
                    const DataCell(Text('Project A')),
                    const DataCell(Text('New York')),
                    const DataCell(Text('John Doe')),
                    const DataCell(Text('45 items')),
                    const DataCell(Text('\$125,000')),
                    DataCell(StatusBadge.success('Active')),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility, size: 20),
                            onPressed: () {
                              // TODO: Navigate to project BoM
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () {
                              // TODO: Edit project BoM
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockAlerts() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Low Stock Alerts', style: AppTextStyles.heading4),
          ),
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3, // Example count
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.warning, color: AppColors.warning),
                title: Text(
                  'Cement - Project A',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Current stock: 10 bags (Minimum: 20)',
                  style: AppTextStyles.bodySmall,
                ),
                trailing: TextButton(
                  onPressed: () {
                    // TODO: Navigate to material request
                  },
                  child: const Text('Request More'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
