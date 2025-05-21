import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await userProvider.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.verified_user,
                size: 72,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome, ${user?.name ?? 'User'}!',
                style: AppTheme.headingStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Role: ${user?.role ?? 'Unknown'}',
                style: AppTheme.subheadingStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Text(
                'This is a placeholder dashboard screen. The actual dashboard will be implemented in upcoming tasks.',
                style: AppTheme.bodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: 'Sign Out',
                onPressed: () async {
                  await userProvider.signOut();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                type: ButtonType.secondary,
                icon: Icons.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
