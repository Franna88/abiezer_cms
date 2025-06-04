import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/material_model.dart';
import '../../../models/project_bom_model.dart';
import '../../../services/bom_service.dart';
import '../../../widgets/common/responsive_table.dart';

class ProjectBoMView extends StatefulWidget {
  final String projectId;

  const ProjectBoMView({super.key, required this.projectId});

  @override
  State<ProjectBoMView> createState() => _ProjectBoMViewState();
}

class _ProjectBoMViewState extends State<ProjectBoMView> {
  final BoMService _bomService = BoMService();
  final _quantityController = TextEditingController();
  final _thresholdController = TextEditingController();

  Future<void> _showAdjustDialog(ProjectBoMModel material) async {
    _quantityController.text = material.totalQuantity.toString();
    _thresholdController.text = material.threshold.toString();

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Adjust Material'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Total Quantity',
                    hintText: 'Enter new quantity',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _thresholdController,
                  decoration: const InputDecoration(
                    labelText: 'Low Stock Threshold',
                    hintText: 'Enter threshold value',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final newQuantity = double.parse(_quantityController.text);
                    final newThreshold = double.parse(
                      _thresholdController.text,
                    );

                    await _bomService.adjustQuantity(
                      widget.projectId,
                      material.id,
                      newQuantity,
                    );

                    await _bomService.setThreshold(
                      widget.projectId,
                      material.id,
                      newThreshold,
                    );

                    if (mounted) Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  List<DataColumn> get _projectColumns => [
    DataColumn(label: Text('Material', style: AppTextStyles.heading2)),
    DataColumn(label: Text('Total', style: AppTextStyles.heading2)),
    DataColumn(label: Text('Used', style: AppTextStyles.heading2)),
    DataColumn(label: Text('Remaining', style: AppTextStyles.heading2)),
    DataColumn(label: Text('Threshold', style: AppTextStyles.heading2)),
    DataColumn(label: Text('Status', style: AppTextStyles.heading2)),
    const DataColumn(label: Text('Actions')),
  ];

  List<DataRow> _buildProjectRows(List<ProjectBoMModel> materials) {
    return materials.map((material) {
      final isLowStock = material.isLowStock;

      return DataRow(
        color:
            isLowStock
                ? MaterialStateProperty.all(AppColors.warning.withOpacity(0.1))
                : null,
        cells: [
          DataCell(Text(material.materialId)), // TODO: Join with material name
          DataCell(Text(material.totalQuantity.toString())),
          DataCell(Text(material.usedQuantity.toString())),
          DataCell(Text(material.remainingQuantity.toString())),
          DataCell(Text(material.threshold.toString())),
          DataCell(
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isLowStock ? AppColors.warning : AppColors.success,
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              child: Text(
                isLowStock ? 'Low Stock' : 'OK',
                style: AppTextStyles.body2.copyWith(color: Colors.white),
              ),
            ),
          ),
          DataCell(
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showAdjustDialog(material),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProjectBoMModel>>(
      stream: _bomService.getProjectBoM(widget.projectId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final materials = snapshot.data!;

        return ResponsiveTable(
          columns: _projectColumns,
          rows: _buildProjectRows(materials),
          minWidth: 800,
        );
      },
    );
  }
}
