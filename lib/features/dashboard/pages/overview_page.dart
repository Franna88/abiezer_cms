import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';
import '../../../widgets/common/responsive_layout.dart';
import '../../../widgets/common/section_header.dart';
import '../widgets/metric_card.dart';
import '../widgets/material_status_card.dart';
import '../widgets/recent_activity_card.dart';

class OverviewPage extends StatelessWidget {
  final String? projectId;

  const OverviewPage({super.key, this.projectId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: Utils.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back, Admin!', style: AppTextStyles.heading2),
                    const SizedBox(height: 8),
                    Text(
                      'Here\'s what\'s happening with your projects today.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to a new project creation screen
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Project'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Quick metrics
          const SizedBox(height: 16),
          ResponsiveLayout(
            mobile: _buildMetricsGrid(context, crossAxisCount: 1),
            tablet: _buildMetricsGrid(context, crossAxisCount: 2),
            desktop: _buildMetricsGrid(context, crossAxisCount: 4),
          ),

          // Materials status
          const SizedBox(height: 32),
          const DashboardSectionHeader(
            title: 'Materials Status',
            subtitle:
                'Current inventory levels and materials that need attention',
            trailing: Icon(Icons.arrow_forward),
          ),
          const SizedBox(height: 16),
          _buildMaterialsStatus(context),

          // Recent activity
          const SizedBox(height: 32),
          const DashboardSectionHeader(
            title: 'Recent Activity',
            subtitle: 'Latest transactions and updates',
            trailing: Icon(Icons.arrow_forward),
          ),
          const SizedBox(height: 16),
          _buildRecentActivity(context),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(
    BuildContext context, {
    required int crossAxisCount,
  }) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: const [
        MetricCard(
          title: 'Active Projects',
          value: '4',
          icon: Icons.business,
          color: AppColors.primary,
          trend: '+1 this month',
          isTrendPositive: true,
        ),
        MetricCard(
          title: 'Pending Approvals',
          value: '7',
          icon: Icons.pending_actions,
          color: AppColors.warning,
          trend: '3 new today',
          isTrendPositive: false,
        ),
        MetricCard(
          title: 'Low Stock Items',
          value: '12',
          icon: Icons.inventory,
          color: AppColors.lowStock,
          trend: '5 critical',
          isTrendPositive: false,
        ),
        MetricCard(
          title: 'Total Purchases',
          value: 'R 45,672',
          icon: Icons.shopping_cart,
          color: AppColors.success,
          trend: '+12% vs last month',
          isTrendPositive: true,
        ),
      ],
    );
  }

  Widget _buildMaterialsStatus(BuildContext context) {
    return ResponsiveLayout(
      mobile: Column(
        children: const [
          MaterialStatusCard(
            category: 'Adhesives & Chemicals',
            totalItems: 24,
            lowStockItems: 3,
            outOfStockItems: 1,
          ),
          SizedBox(height: 16),
          MaterialStatusCard(
            category: 'Boards & Sheets',
            totalItems: 18,
            lowStockItems: 5,
            outOfStockItems: 2,
          ),
          SizedBox(height: 16),
          MaterialStatusCard(
            category: 'Fasteners & Fixings',
            totalItems: 36,
            lowStockItems: 0,
            outOfStockItems: 0,
          ),
        ],
      ),
      tablet: Row(
        children: [
          Expanded(
            child: Column(
              children: const [
                MaterialStatusCard(
                  category: 'Adhesives & Chemicals',
                  totalItems: 24,
                  lowStockItems: 3,
                  outOfStockItems: 1,
                ),
                SizedBox(height: 16),
                MaterialStatusCard(
                  category: 'Fasteners & Fixings',
                  totalItems: 36,
                  lowStockItems: 0,
                  outOfStockItems: 0,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: const [
                MaterialStatusCard(
                  category: 'Boards & Sheets',
                  totalItems: 18,
                  lowStockItems: 5,
                  outOfStockItems: 2,
                ),
                SizedBox(height: 16),
                MaterialStatusCard(
                  category: 'Tools & Accessories',
                  totalItems: 15,
                  lowStockItems: 2,
                  outOfStockItems: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return ResponsiveLayout(
      mobile: Column(
        children: const [
          RecentActivityCard(
            title: 'New Purchase',
            description: 'Cement (50 bags) - Project Alpha',
            date: '2 hours ago',
            icon: Icons.shopping_cart,
            color: AppColors.primary,
          ),
          SizedBox(height: 16),
          RecentActivityCard(
            title: 'Material Used',
            description: 'Black Sheets (20 units) - Project Beta',
            date: '5 hours ago',
            icon: Icons.inventory_2,
            color: AppColors.info,
          ),
          SizedBox(height: 16),
          RecentActivityCard(
            title: 'Low Stock Alert',
            description: 'Adhesive (2 units remaining)',
            date: '1 day ago',
            icon: Icons.warning,
            color: AppColors.warning,
          ),
        ],
      ),
      tablet: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: const [
                RecentActivityCard(
                  title: 'New Purchase',
                  description: 'Cement (50 bags) - Project Alpha',
                  date: '2 hours ago',
                  icon: Icons.shopping_cart,
                  color: AppColors.primary,
                ),
                SizedBox(height: 16),
                RecentActivityCard(
                  title: 'Low Stock Alert',
                  description: 'Adhesive (2 units remaining)',
                  date: '1 day ago',
                  icon: Icons.warning,
                  color: AppColors.warning,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: const [
                RecentActivityCard(
                  title: 'Material Used',
                  description: 'Black Sheets (20 units) - Project Beta',
                  date: '5 hours ago',
                  icon: Icons.inventory_2,
                  color: AppColors.info,
                ),
                SizedBox(height: 16),
                RecentActivityCard(
                  title: 'Purchase Approved',
                  description: 'Concrete Mix (10 bags) - Project Gamma',
                  date: '1 day ago',
                  icon: Icons.check_circle,
                  color: AppColors.success,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
