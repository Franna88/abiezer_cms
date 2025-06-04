import 'package:flutter/material.dart';
import '../../../utils/app_theme.dart';

class NoProjectsView extends StatelessWidget {
  const NoProjectsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off,
            size: 64,
            color: AppTheme.primaryColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Projects Assigned',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'You currently have no projects assigned to you.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondaryColor),
          ),
          const SizedBox(height: 24),
          const Text(
            'Please contact your administrator to get assigned to a project.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppTheme.textLightColor),
          ),
        ],
      ),
    );
  }
}
