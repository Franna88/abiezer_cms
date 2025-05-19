import 'package:flutter/material.dart';
import '../../../../core/theme/color_theme.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utilities/utilities.dart';
import '../../../../widgets/common/section_header.dart';

class ReportsPage extends StatefulWidget {
  final String? projectId;

  const ReportsPage({super.key, this.projectId});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: Utils.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Reports & Analysis'),
            const SizedBox(height: 8),
            Text(
              'Generate reports and analyze material usage',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: Utils.spacing_lg),
            _buildReportsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildReportCard(
          'Material Usage Report',
          'Track material consumption across projects',
          Icons.assessment_outlined,
          AppColors.info,
          () {
            // TODO: Implement material usage report
          },
        ),
        _buildReportCard(
          'Inventory Status',
          'Current stock levels and status',
          Icons.inventory_2_outlined,
          AppColors.success,
          () {
            // TODO: Implement inventory status report
          },
        ),
        _buildReportCard(
          'Request Analysis',
          'Analyze material request patterns',
          Icons.analytics_outlined,
          AppColors.primary,
          () {
            // TODO: Implement request analysis report
          },
        ),
        _buildReportCard(
          'Transfer History',
          'Track material transfers between projects',
          Icons.swap_horiz_outlined,
          AppColors.secondary,
          () {
            // TODO: Implement transfer history report
          },
        ),
        _buildReportCard(
          'Return Analysis',
          'Analyze material returns and reasons',
          Icons.assignment_return_outlined,
          AppColors.accent,
          () {
            // TODO: Implement return analysis report
          },
        ),
        _buildReportCard(
          'Cost Analysis',
          'Track material costs and expenses',
          Icons.attach_money_outlined,
          AppColors.warning,
          () {
            // TODO: Implement cost analysis report
          },
        ),
      ],
    );
  }

  Widget _buildReportCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward, color: color, size: 20),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: AppTextStyles.heading5,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
