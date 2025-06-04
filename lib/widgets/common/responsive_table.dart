import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ResponsiveTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool isLoading;
  final String emptyMessage;
  final double? minWidth;

  const ResponsiveTable({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.emptyMessage = 'No data available',
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (rows.isEmpty) {
          return Center(child: Text(emptyMessage, style: AppTextStyles.body2));
        }

        if (isSmallScreen) {
          // For small screens, show a list view instead of a table
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rows.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final row = rows[index];
              return Card(
                margin: EdgeInsets.symmetric(
                  vertical: AppSpacing.xs,
                  horizontal: AppSpacing.sm,
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      columns.length,
                      (colIndex) => Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                columns[colIndex].label.toString(),
                                style: AppTextStyles.body2,
                              ),
                            ),
                            Expanded(flex: 3, child: row.cells[colIndex].child),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        // For larger screens, show a scrollable table
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: minWidth ?? constraints.maxWidth,
            child: DataTable(
              columns: columns,
              rows: rows,
              columnSpacing: AppSpacing.lg,
              horizontalMargin: AppSpacing.md,
              headingRowHeight: AppSpacing.minButtonHeight,
              dataRowHeight: AppSpacing.minButtonHeight,
            ),
          ),
        );
      },
    );
  }
}
