import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../placeholder_screen.dart';

class ProductivityContent extends StatelessWidget {
  final ProjectModel? selectedProject;

  const ProductivityContent({Key? key, required this.selectedProject})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectedProject == null
        ? const Center(child: Text('Please select a project'))
        : PlaceholderScreen(
          title: 'My Productivity',
          icon: Icons.insert_chart_outlined,
        );
  }
}
