import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/firebase_options.dart';
import 'providers/user_provider.dart';
import 'providers/project_provider.dart';
import 'providers/projects_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/bom_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/admin/project_details_screen.dart';
import 'screens/admin/projects/add_project_screen.dart';
import 'utils/app_theme.dart';
import 'features/bom/screens/project_overview_screen.dart';
import 'models/project_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ProjectProvider()),
        ChangeNotifierProvider(create: (context) => ProjectsProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => BomProvider()),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return MaterialApp(
            title: 'Abiezer Construction',
            theme: AppTheme.getThemeData(),
            home: const AuthWrapper(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/main': (context) => const MainScreen(),
              '/admin/project-details': (context) {
                // Get the project from route arguments
                final project = ModalRoute.of(context)?.settings.arguments;
                return const ProjectDetailsScreen();
              },
              '/pm/project-details': (context) {
                final project =
                    ModalRoute.of(context)!.settings.arguments as ProjectModel;
                return ProjectOverviewScreen(project: project);
              },
              '/admin/add-project': (context) => const AddProjectScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Use Future.microtask to avoid setState during build
    Future.microtask(() {
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).initializeUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userProvider.isAuthenticated) {
      return const MainScreen();
    } else {
      return const LoginScreen();
    }
  }
}
