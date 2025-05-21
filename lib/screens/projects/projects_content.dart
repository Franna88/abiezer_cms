import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../placeholder_screen.dart';

class ProjectsContent extends StatelessWidget {
  final ProjectModel? selectedProject;

  const ProjectsContent({Key? key, required this.selectedProject})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(title: 'Projects', icon: Icons.folder_outlined);
  }
}
