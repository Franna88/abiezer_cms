import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../placeholder_screen.dart';

class BomContent extends StatelessWidget {
  final ProjectModel? selectedProject;

  const BomContent({Key? key, required this.selectedProject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectedProject == null
        ? const Center(child: Text('Please select a project'))
        : PlaceholderScreen(
          title: 'Bill of Materials',
          icon: Icons.assignment_outlined,
        );
  }
}
