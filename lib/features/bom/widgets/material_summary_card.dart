import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/status_badge.dart';

class MaterialSummaryCard extends StatelessWidget {
  final int totalMaterials;
  final int lowStockCount;
  final int outOfStockCount;
  final int leftoverCount;
  final VoidCallback? onRequestMaterial;

  const MaterialSummaryCard({
    super.key,
    required this.totalMaterials,
    required this.lowStockCount,
    required this.outOfStockCount,
    required this.leftoverCount,
    this.onRequestMaterial,
  });

  @override
  Widget build(BuildContext context) {
    final int normalStockCount =
        totalMaterials - lowStockCount - outOfStockCount;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and action button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Material Summary', style: AppTextStyles.heading4),
                OutlinedButton.icon(
                  onPressed: onRequestMaterial,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Request Material'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Material counts
            Wrap(
              spacing: 24,
              runSpacing: 16,
              children: [
                _buildCountBox(
                  title: 'Total Materials',
                  count: totalMaterials,
                  icon: Icons.inventory_2_outlined,
                  color: AppColors.info,
                ),
                _buildCountBox(
                  title: 'Normal Stock',
                  count: normalStockCount,
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                ),
                _buildCountBox(
                  title: 'Low Stock',
                  count: lowStockCount,
                  icon: Icons.warning_amber_outlined,
                  color: AppColors.lowStock,
                  badge:
                      lowStockCount > 0 ? StatusBadge.warning('Warning') : null,
                ),
                _buildCountBox(
                  title: 'Out of Stock',
                  count: outOfStockCount,
                  icon: Icons.error_outline,
                  color: AppColors.outOfStock,
                  badge:
                      outOfStockCount > 0
                          ? StatusBadge.error('Critical')
                          : null,
                ),
                _buildCountBox(
                  title: 'Leftover',
                  count: leftoverCount,
                  icon: Icons.recycling_outlined,
                  color: AppColors.accent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountBox({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    Widget? badge,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              if (badge != null) badge,
            ],
          ),
          const SizedBox(height: 8),
          Text('$count', style: AppTextStyles.heading3.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
