import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../placeholder_screen.dart';

class UsersContent extends StatelessWidget {
  final ProjectModel? selectedProject;

  const UsersContent({Key? key, required this.selectedProject})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(title: 'Users', icon: Icons.people_outline);
  }
}
