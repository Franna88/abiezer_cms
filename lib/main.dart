import 'package:flutter/material.dart';
import 'core/models/user_model.dart';
import 'core/theme/app_theme.dart';
import 'core/utilities/constants.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/bom/bom_screen.dart';
import 'features/bom/create_bom_screen.dart';
import 'features/projects/projects_screen.dart';
import 'features/projects/project_details_screen.dart';

void main() {
  runApp(const AbiezerCMSApp());
}

class AbiezerCMSApp extends StatelessWidget {
  const AbiezerCMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    // This would typically come from authentication or state management
    // Admin user
    final UserModel adminUser = UserModel(
      id: '1',
      name: 'Admin User',
      email: 'admin@abiezer.com',
      role: AppConstants.roleAdmin,
      assignedProjects: ['1', '2', '3'],
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    // Project Manager user
    final UserModel projectManagerUser = UserModel(
      id: '2',
      name: 'Project Manager',
      email: 'pm@abiezer.com',
      role: AppConstants.roleProjectManager,
      assignedProjects: ['1', '2'],
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppConstants.routeLogin,
      routes: {
        AppConstants.routeLogin: (context) => const LoginScreen(),
        AppConstants.routeDashboard: (context) {
          // Get arguments if any
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          final selectedIndex = args?['selectedIndex'] as int?;
          final projectId = args?['projectId'] as String?;
          return DashboardScreen(
            currentUser: adminUser,
            initialIndex: selectedIndex,
            initialProjectId: projectId,
          );
        },
        AppConstants.routeBoM: (context) {
          // Get arguments if any
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          final projectId = args?['projectId'] as String?;
          return BomScreen(currentUser: adminUser, projectId: projectId);
        },
        AppConstants.routeCreateBoM: (context) {
          // Get arguments
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final projectId = args['projectId'] as String;
          final existingBom = args['existingBom'];

          return CreateBomScreen(
            projectId: projectId,
            currentUser: adminUser,
            existingBom: existingBom,
          );
        },
        AppConstants.routeProjects:
            (context) => ProjectsScreen(currentUser: adminUser),
        AppConstants.routeProjectDetails: (context) {
          // Get the projectId from arguments
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;
          final projectId =
              args?['projectId'] as String? ??
              '1'; // Default to project 1 if not specified
          return ProjectDetailsScreen(
            projectId: projectId,
            currentUser: adminUser,
          );
        },
      },
      onGenerateRoute: (settings) {
        // This can be expanded to handle more complex route logic with parameters
        if (settings.name == '/project-manager-dashboard' ||
            settings.name == AppConstants.routeDashboard) {
          final args = settings.arguments as Map<String, dynamic>?;
          final isProjectManager = args?['isProjectManager'] == true;
          final selectedIndex = args?['selectedIndex'] as int?;
          final projectId = args?['projectId'] as String?;

          return MaterialPageRoute(
            builder:
                (context) => DashboardScreen(
                  currentUser:
                      isProjectManager ? projectManagerUser : adminUser,
                  initialIndex: selectedIndex,
                  initialProjectId: projectId,
                ),
            settings: RouteSettings(name: settings.name, arguments: args),
          );
        }
        if (settings.name == AppConstants.routeBoM) {
          // Check if coming from project manager dashboard
          final args = settings.arguments as Map<String, dynamic>?;
          final projectId = args?['projectId'] as String?;

          if (args != null &&
              args.containsKey('isProjectManager') &&
              args['isProjectManager'] == true) {
            return MaterialPageRoute(
              builder:
                  (context) => BomScreen(
                    currentUser: projectManagerUser,
                    projectId: projectId,
                  ),
            );
          }
          // Default handler is now in the routes map
          return null;
        }
        if (settings.name == AppConstants.routeProjects) {
          // Check if coming from project manager dashboard
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null &&
              args.containsKey('isProjectManager') &&
              args['isProjectManager'] == true) {
            return MaterialPageRoute(
              builder:
                  (context) => ProjectsScreen(currentUser: projectManagerUser),
            );
          }
          // Default handler is in the routes map
          return null;
        }
        if (settings.name == AppConstants.routeProjectDetails) {
          // Check if coming from project manager dashboard
          final args = settings.arguments as Map<String, dynamic>?;
          final projectId = args?['projectId'] as String? ?? '1';

          if (args != null &&
              args.containsKey('isProjectManager') &&
              args['isProjectManager'] == true) {
            return MaterialPageRoute(
              builder:
                  (context) => ProjectDetailsScreen(
                    projectId: projectId,
                    currentUser: projectManagerUser,
                  ),
            );
          }
          // Default handler is in the routes map
          return null;
        }
        return null;
      },
    );
  }
}
