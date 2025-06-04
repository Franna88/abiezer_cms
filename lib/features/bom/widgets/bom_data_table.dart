import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/project_provider.dart';
import '../../../models/bom_item_model.dart';
import '../../../utils/app_theme.dart';

class BoMDataTable extends StatelessWidget {
  const BoMDataTable({Key? key}) : super(key: key);

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

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Material')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Unit')),
              DataColumn(label: Text('Total')),
              DataColumn(label: Text('Used')),
              DataColumn(label: Text('Remaining')),
              DataColumn(label: Text('Status')),
            ],
            rows:
                items.map((item) {
                  final isLowStock = item.remaining <= item.lowStockThreshold;
                  return DataRow(
                    cells: [
                      DataCell(Text(item.name)),
                      DataCell(Text(item.category)),
                      DataCell(Text(item.unit)),
                      DataCell(Text(item.total.toString())),
                      DataCell(Text(item.used.toString())),
                      DataCell(Text(item.remaining.toString())),
                      DataCell(
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
                      ),
                    ],
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
