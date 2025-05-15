import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';

class MaterialListItem extends StatelessWidget {
  final String name;
  final String category;
  final String unit;
  final int totalQuantity;
  final int usedQuantity;
  final int remainingQuantity;
  final double unitPrice;
  final bool isLowStock;
  final bool isLeftover;
  final bool canMarkAsUsed;
  final VoidCallback? onTap;
  final Function(double)? onMarkUsed; // Callback to mark material as used

  const MaterialListItem({
    super.key,
    required this.name,
    required this.category,
    required this.unit,
    required this.totalQuantity,
    required this.usedQuantity,
    required this.remainingQuantity,
    required this.unitPrice,
    required this.isLowStock,
    this.isLeftover = false,
    this.canMarkAsUsed = false,
    this.onTap,
    this.onMarkUsed,
  });

  @override
  Widget build(BuildContext context) {
    final double percentUsed =
        totalQuantity > 0 ? (usedQuantity / totalQuantity) * 100 : 0;

    final Color stockColor =
        remainingQuantity <= 0
            ? AppColors.outOfStock
            : (isLowStock ? AppColors.lowStock : AppColors.success);

    final String stockStatus =
        remainingQuantity <= 0
            ? 'Out of Stock'
            : (isLowStock ? 'Low Stock' : 'In Stock');

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isLeftover ? AppColors.accent : Colors.transparent,
          width: isLeftover ? 1.5 : 0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with name, status and actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and leftover badge
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isLeftover)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Tooltip(
                              message: 'Leftover material from another project',
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                  vertical: 2.0,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                    color: AppColors.accent,
                                    width: 1.0,
                                  ),
                                ),
                                child: Text(
                                  'Leftover',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Stock status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: stockColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      stockStatus,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: stockColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Category and unit
              Text(
                '$category · $unit',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Used: $usedQuantity / $totalQuantity',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${percentUsed.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: percentUsed / 100,
                      backgroundColor: AppColors.progressBackground,
                      color: stockColor,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Price and remaining
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price: R${unitPrice.toStringAsFixed(2)} per $unit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '$remainingQuantity remaining',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: stockColor,
                    ),
                  ),
                ],
              ),

              // Mark as used button (only for project managers/admins)
              if (canMarkAsUsed && remainingQuantity > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _showMarkAsUsedDialog(context),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Mark as Used'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMarkAsUsedDialog(BuildContext context) {
    if (onMarkUsed == null) return;

    double quantity = 1; // Default quantity to mark as used

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Mark $name as Used'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How much of this material was used?'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: '1',
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          suffixText: unit,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          try {
                            quantity = double.parse(value);
                          } catch (e) {
                            // Invalid input
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Available: $remainingQuantity $unit',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
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
                  Navigator.pop(context);
                  if (quantity > 0 && quantity <= remainingQuantity) {
                    onMarkUsed!(quantity);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please enter a valid quantity between 1 and $remainingQuantity',
                        ),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                child: const Text('Mark as Used'),
              ),
            ],
          ),
    );
  }
}
