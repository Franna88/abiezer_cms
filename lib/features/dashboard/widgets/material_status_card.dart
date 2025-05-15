import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/status_badge.dart';

class MaterialStatusCard extends StatelessWidget {
  final String category;
  final int totalItems;
  final int lowStockItems;
  final int outOfStockItems;

  const MaterialStatusCard({
    super.key,
    required this.category,
    required this.totalItems,
    required this.lowStockItems,
    required this.outOfStockItems,
  });

  @override
  Widget build(BuildContext context) {
    final int normalStockItems = totalItems - lowStockItems - outOfStockItems;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category name
            Text(category, style: AppTextStyles.heading4),
            const SizedBox(height: 4),
            Text(
              '$totalItems items',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Progress bars
            if (totalItems > 0) ...[
              // Normal stock
              if (normalStockItems > 0)
                _buildStockBar(
                  label: 'Normal Stock',
                  count: normalStockItems,
                  color: AppColors.success,
                  percentage: normalStockItems / totalItems,
                ),

              // Low stock
              if (lowStockItems > 0)
                _buildStockBar(
                  label: 'Low Stock',
                  count: lowStockItems,
                  color: AppColors.lowStock,
                  percentage: lowStockItems / totalItems,
                ),

              // Out of stock
              if (outOfStockItems > 0)
                _buildStockBar(
                  label: 'Out of Stock',
                  count: outOfStockItems,
                  color: AppColors.outOfStock,
                  percentage: outOfStockItems / totalItems,
                ),
            ],

            const SizedBox(height: 16),

            // Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Navigate to category details
                  },
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
                  child: const Text('View Details'),
                ),

                // Status summary
                Row(
                  children: [
                    if (outOfStockItems > 0)
                      StatusBadge.outOfStock('$outOfStockItems'),
                    if (outOfStockItems > 0 && lowStockItems > 0)
                      const SizedBox(width: 8),
                    if (lowStockItems > 0)
                      StatusBadge.lowStock('$lowStockItems'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockBar({
    required String label,
    required int count,
    required Color color,
    required double percentage,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.bodyMedium),
              Text(
                '$count items',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              // Background
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Progress
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
