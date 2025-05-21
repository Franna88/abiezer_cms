import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../placeholder_screen.dart';

class ReportsContent extends StatelessWidget {
  final ProjectModel? selectedProject;

  const ReportsContent({Key? key, required this.selectedProject})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectedProject == null
        ? const Center(child: Text('Please select a project'))
        : PlaceholderScreen(title: 'Reports', icon: Icons.bar_chart_outlined);
  }
}
