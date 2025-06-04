import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../models/material_model.dart';
import '../../models/material_history_model.dart';
import '../../services/bom_service.dart';
import '../../utils/currency_formatter.dart';

class MaterialCard extends StatelessWidget {
  final MaterialModel material;
  final VoidCallback onEdit;

  const MaterialCard({super.key, required this.material, required this.onEdit});

  Future<void> _showHistoryDialog(BuildContext context) async {
    final bomService = BoMService();

    return showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Usage History - ${material.name}',
                        style: AppTextStyles.heading2,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: StreamBuilder<List<MaterialHistoryModel>>(
                      stream: bomService.getMaterialHistory(material.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final history = snapshot.data!;
                        if (history.isEmpty) {
                          return const Center(
                            child: Text('No usage history available'),
                          );
                        }

                        return ListView.separated(
                          itemCount: history.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final record = history[index];
                            return ListTile(
                              title: Text(
                                'Project: ${record.projectName}',
                                style: AppTextStyles.body1,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${record.action.toUpperCase()}: ${record.quantity} ${material.unit}',
                                    style: AppTextStyles.body2,
                                  ),
                                  Text(
                                    record.date.toString(),
                                    style: AppTextStyles.body2.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _showAddStockDialog(BuildContext context) async {
    final _quantityController = TextEditingController();
    final _reasonController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final bomService = BoMService();

    return showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Stock - ${material.name}',
                      style: AppTextStyles.heading2,
                    ),
                    SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity*',
                        hintText: 'Enter quantity',
                        suffixText: material.unit,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        final quantity = double.parse(value);
                        if (quantity <= 0) {
                          return 'Quantity must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _reasonController,
                      decoration: const InputDecoration(
                        labelText: 'Reason (Optional)',
                        hintText: 'Enter reason for adding stock',
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        SizedBox(width: AppSpacing.md),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await bomService.addStock(
                                  material.id,
                                  double.parse(_quantityController.text),
                                  reason:
                                      _reasonController.text.isNotEmpty
                                          ? _reasonController.text
                                          : null,
                                );
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Stock added successfully'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Add Stock'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bomService = BoMService();

    return Card(
      margin: EdgeInsets.all(AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              material.name,
                              style: AppTextStyles.heading2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AppSpacing.xs),
                            Text(material.category, style: AppTextStyles.body2),
                          ],
                        ),
                      ),
                      StreamBuilder<double>(
                        stream: bomService.getCurrentStock(material.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasError || !snapshot.hasData) {
                            return const SizedBox.shrink();
                          }

                          final stockLevel = snapshot.data!;
                          Widget? alert;

                          if (stockLevel <= 0) {
                            alert = Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  AppBorderRadius.sm,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: AppColors.error,
                                    size: 16,
                                  ),
                                  SizedBox(width: AppSpacing.xs),
                                  Text(
                                    'URGENT: Empty Stock',
                                    style: AppTextStyles.body2.copyWith(
                                      color: AppColors.error,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (stockLevel <= 10) {
                            alert = Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  AppBorderRadius.sm,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning_amber_outlined,
                                    color: AppColors.warning,
                                    size: 16,
                                  ),
                                  SizedBox(width: AppSpacing.xs),
                                  Text(
                                    'Low Stock Alert',
                                    style: AppTextStyles.body2.copyWith(
                                      color: AppColors.warning,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return alert ?? const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _InfoItem(label: 'Unit', value: material.unit),
                SizedBox(width: AppSpacing.md),
                _InfoItem(
                  label: 'Cost',
                  value: CurrencyFormatter.format(material.cost),
                ),
                SizedBox(width: AppSpacing.md),
                _InfoItem(label: 'Supplier', value: material.supplier),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            StreamBuilder<double>(
              stream: bomService.getCurrentStock(material.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error loading stock level');
                }

                if (!snapshot.hasData) {
                  return const LinearProgressIndicator();
                }

                final stockLevel = snapshot.data!;
                final stockText = stockLevel.toStringAsFixed(0);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Stock Level: $stockText', style: AppTextStyles.body2),
                    Row(
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add Stock'),
                          onPressed: () => _showAddStockDialog(context),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        TextButton.icon(
                          icon: const Icon(Icons.history),
                          label: const Text('History'),
                          onPressed: () => _showHistoryDialog(context),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: onEdit,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.body1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
