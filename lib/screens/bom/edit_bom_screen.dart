import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../../models/project_bom_model.dart';
import '../../features/bom/widgets/create_bom_widget.dart';
import '../../utils/app_theme.dart';

class EditBomScreen extends StatelessWidget {
  final Project project;
  final List<ProjectBoMModel> existingBomMaterials;

  const EditBomScreen({
    super.key,
    required this.project,
    required this.existingBomMaterials,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit BOM - ${project.name}'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: CreateBoMWidget(
          projectId: project.id,
          existingBomMaterials: existingBomMaterials,
          onBomCreated: () {
            // Show success message and navigate back
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Bill of Materials updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // Return true to indicate success
          },
        ),
      ),
    );
  }
}
