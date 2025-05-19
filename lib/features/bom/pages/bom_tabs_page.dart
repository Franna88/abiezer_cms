import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';
import '../../../widgets/common/responsive_layout.dart';
import '../../../widgets/common/section_header.dart';
import 'pages/material_requests_page.dart';
import 'pages/material_transfers_page.dart';
import 'pages/material_returns_page.dart';
import 'pages/material_catalog_page.dart';
import 'pages/reports_page.dart';
import 'pages/audit_trail_page.dart';
import 'pages/notifications_page.dart';

class BomTabsPage extends StatelessWidget {
  final String? projectId;

  const BomTabsPage({super.key, this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: Utils.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Bill of Materials Management'),
            const SizedBox(height: 8),
            Text(
              'Manage materials, requests, transfers, and inventory across projects',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: Utils.spacing_lg),
            ResponsiveLayout(
              mobile: _buildMobileView(context),
              tablet: _buildTabletView(context),
              desktop: _buildDesktopView(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileView(BuildContext context) {
    return Column(
      children: [
        _buildSectionCard(
          context,
          'Material Requests',
          'Review and manage material requests from projects',
          'View Requests',
          Icons.assignment_outlined,
          AppColors.primary,
          '5',
          () => _navigateToMaterialRequestsPage(context),
        ),
        const SizedBox(height: Utils.spacing_md),
        _buildSectionCard(
          context,
          'Material Transfers',
          'Handle material transfers between projects',
          'View Transfers',
          Icons.swap_horiz_outlined,
          AppColors.secondary,
          '3',
          () => _navigateToMaterialTransfersPage(context),
        ),
        const SizedBox(height: Utils.spacing_md),
        _buildSectionCard(
          context,
          'Material Returns',
          'Process returned materials and manage inventory',
          'View Returns',
          Icons.assignment_return_outlined,
          AppColors.accent,
          '2',
          () => _navigateToMaterialReturnsPage(context),
        ),
        const SizedBox(height: Utils.spacing_md),
        _buildSectionCard(
          context,
          'Material Catalog',
          'Manage the master list of materials',
          'View Catalog',
          Icons.inventory_2_outlined,
          AppColors.success,
          '48',
          () => _navigateToMaterialCatalogPage(context),
        ),
        const SizedBox(height: Utils.spacing_md),
        _buildSectionCard(
          context,
          'Reports & Analysis',
          'Generate reports and analyze material usage',
          'View Reports',
          Icons.assessment_outlined,
          AppColors.info,
          '12',
          () => _navigateToReportsPage(context),
        ),
        const SizedBox(height: Utils.spacing_md),
        _buildSectionCard(
          context,
          'Audit Trail',
          'Review all system actions and changes',
          'View Audit Trail',
          Icons.history_outlined,
          AppColors.warning,
          '156',
          () => _navigateToAuditTrailPage(context),
        ),
        const SizedBox(height: Utils.spacing_md),
        _buildSectionCard(
          context,
          'Notifications',
          'View alerts and system notifications',
          'View Notifications',
          Icons.notifications_outlined,
          AppColors.error,
          '8',
          () => _navigateToNotificationsPage(context),
        ),
      ],
    );
  }

  Widget _buildTabletView(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSectionCard(
                context,
                'Material Requests',
                'Review and manage material requests from projects',
                'View Requests',
                Icons.assignment_outlined,
                AppColors.primary,
                '5',
                () => _navigateToMaterialRequestsPage(context),
              ),
            ),
            const SizedBox(width: Utils.spacing_md),
            Expanded(
              child: _buildSectionCard(
                context,
                'Material Transfers',
                'Handle material transfers between projects',
                'View Transfers',
                Icons.swap_horiz_outlined,
                AppColors.secondary,
                '3',
                () => _navigateToMaterialTransfersPage(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: Utils.spacing_md),
        Row(
          children: [
            Expanded(
              child: _buildSectionCard(
                context,
                'Material Returns',
                'Process returned materials and manage inventory',
                'View Returns',
                Icons.assignment_return_outlined,
                AppColors.accent,
                '2',
                () => _navigateToMaterialReturnsPage(context),
              ),
            ),
            const SizedBox(width: Utils.spacing_md),
            Expanded(
              child: _buildSectionCard(
                context,
                'Material Catalog',
                'Manage the master list of materials',
                'View Catalog',
                Icons.inventory_2_outlined,
                AppColors.success,
                '48',
                () => _navigateToMaterialCatalogPage(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: Utils.spacing_md),
        Row(
          children: [
            Expanded(
              child: _buildSectionCard(
                context,
                'Reports & Analysis',
                'Generate reports and analyze material usage',
                'View Reports',
                Icons.assessment_outlined,
                AppColors.info,
                '12',
                () => _navigateToReportsPage(context),
              ),
            ),
            const SizedBox(width: Utils.spacing_md),
            Expanded(
              child: _buildSectionCard(
                context,
                'Audit Trail',
                'Review all system actions and changes',
                'View Audit Trail',
                Icons.history_outlined,
                AppColors.warning,
                '156',
                () => _navigateToAuditTrailPage(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: Utils.spacing_md),
        _buildSectionCard(
          context,
          'Notifications',
          'View alerts and system notifications',
          'View Notifications',
          Icons.notifications_outlined,
          AppColors.error,
          '8',
          () => _navigateToNotificationsPage(context),
        ),
      ],
    );
  }

  Widget _buildDesktopView(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildSectionCard(
                context,
                'Material Requests',
                'Review and manage material requests from projects',
                'View Requests',
                Icons.assignment_outlined,
                AppColors.primary,
                '5',
                () => _navigateToMaterialRequestsPage(context),
              ),
              const SizedBox(height: Utils.spacing_md),
              _buildSectionCard(
                context,
                'Material Returns',
                'Process returned materials and manage inventory',
                'View Returns',
                Icons.assignment_return_outlined,
                AppColors.accent,
                '2',
                () => _navigateToMaterialReturnsPage(context),
              ),
              const SizedBox(height: Utils.spacing_md),
              _buildSectionCard(
                context,
                'Reports & Analysis',
                'Generate reports and analyze material usage',
                'View Reports',
                Icons.assessment_outlined,
                AppColors.info,
                '12',
                () => _navigateToReportsPage(context),
              ),
            ],
          ),
        ),
        const SizedBox(width: Utils.spacing_md),
        Expanded(
          child: Column(
            children: [
              _buildSectionCard(
                context,
                'Material Transfers',
                'Handle material transfers between projects',
                'View Transfers',
                Icons.swap_horiz_outlined,
                AppColors.secondary,
                '3',
                () => _navigateToMaterialTransfersPage(context),
              ),
              const SizedBox(height: Utils.spacing_md),
              _buildSectionCard(
                context,
                'Material Catalog',
                'Manage the master list of materials',
                'View Catalog',
                Icons.inventory_2_outlined,
                AppColors.success,
                '48',
                () => _navigateToMaterialCatalogPage(context),
              ),
              const SizedBox(height: Utils.spacing_md),
              _buildSectionCard(
                context,
                'Audit Trail',
                'Review all system actions and changes',
                'View Audit Trail',
                Icons.history_outlined,
                AppColors.warning,
                '156',
                () => _navigateToAuditTrailPage(context),
              ),
            ],
          ),
        ),
        const SizedBox(width: Utils.spacing_md),
        Expanded(
          child: Column(
            children: [
              _buildSectionCard(
                context,
                'Notifications',
                'View alerts and system notifications',
                'View Notifications',
                Icons.notifications_outlined,
                AppColors.error,
                '8',
                () => _navigateToNotificationsPage(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    String title,
    String description,
    String buttonText,
    IconData icon,
    Color color,
    String count,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
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
            padding: const EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppTextStyles.heading4,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                count,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    buttonText,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: color, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToMaterialRequestsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MaterialRequestsPage(projectId: projectId),
      ),
    );
  }

  void _navigateToMaterialTransfersPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MaterialTransfersPage(projectId: projectId),
      ),
    );
  }

  void _navigateToMaterialReturnsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MaterialReturnsPage(projectId: projectId),
      ),
    );
  }

  void _navigateToMaterialCatalogPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MaterialCatalogPage(projectId: projectId),
      ),
    );
  }

  void _navigateToReportsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportsPage(projectId: projectId),
      ),
    );
  }

  void _navigateToAuditTrailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuditTrailPage(projectId: projectId),
      ),
    );
  }

  void _navigateToNotificationsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationsPage(projectId: projectId),
      ),
    );
  }
}
