import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'v1.0.0',
            style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12),
          ),
          TextButton(
            onPressed: () {
              // TODO: Link to support page or email
            },
            child: const Text(
              'Contact Support',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 12,
              ),
            ),
          ),
          const Text(
            '© 2023 Abiezer Construction',
            style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
