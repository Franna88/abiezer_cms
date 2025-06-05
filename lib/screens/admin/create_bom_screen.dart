import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../../features/bom/widgets/create_bom_widget.dart';
import '../../utils/app_theme.dart';

class CreateBomScreen extends StatelessWidget {
  final Project project;

  const CreateBomScreen({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create BOM - ${project.name}'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: CreateBoMWidget(
          projectId: project.id,
          onBomCreated: () {
            // Show success message and navigate back
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Bill of Materials created successfully'),
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
