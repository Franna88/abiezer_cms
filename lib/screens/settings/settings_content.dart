import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../placeholder_screen.dart';

class SettingsContent extends StatelessWidget {
  final ProjectModel? selectedProject;

  const SettingsContent({Key? key, required this.selectedProject})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(title: 'Settings', icon: Icons.settings_outlined);
  }
}
