import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/project_provider.dart';
import '../../../models/bom_item_model.dart';
import '../../../utils/app_theme.dart';

class BoMListView extends StatelessWidget {
  const BoMListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final bomStream = projectProvider.selectedProjectBoMStream;

    if (bomStream == null) {
      return const Center(child: Text('Please select a project'));
    }

    return StreamBuilder<List<BoMItemModel>>(
      stream: bomStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: AppTheme.errorColor),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data!;

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            final isLowStock = item.remaining <= item.lowStockThreshold;

            return Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isLowStock
                                    ? AppTheme.errorColor.withOpacity(0.1)
                                    : AppTheme.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isLowStock ? 'Low Stock' : 'In Stock',
                            style: TextStyle(
                              color:
                                  isLowStock
                                      ? AppTheme.errorColor
                                      : AppTheme.successColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.category,
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildInfoColumn('Total', item.total.toString()),
                        const SizedBox(width: 24),
                        _buildInfoColumn('Used', item.used.toString()),
                        const SizedBox(width: 24),
                        _buildInfoColumn(
                          'Remaining',
                          item.remaining.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
