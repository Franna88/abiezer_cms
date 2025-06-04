import 'package:flutter/material.dart';
import 'dart:io';
import '../../../utils/responsive_helper.dart';
import 'user_card.dart';

class UserTable extends StatefulWidget {
  const UserTable({Key? key}) : super(key: key);

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  // Sample data - replace with actual data from your provider
  late List<Map<String, dynamic>> users;

  @override
  void initState() {
    super.initState();
    users = [
      {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone': '+1 234 567 8900',
        'role': 'Project Manager',
        'projects': ['Project X', 'Project Z'],
        'permissions': ['BoM Access', 'Request Submission'],
        'photoUrl': null,
      },
      {
        'name': 'Jane Smith',
        'email': 'jane.smith@example.com',
        'phone': '+1 234 567 8901',
        'role': 'Project Manager',
        'projects': ['Project Y'],
        'permissions': ['BoM Access'],
        'photoUrl': null,
      },
      {
        'name': 'Mark Brown',
        'email': 'mark.brown@example.com',
        'phone': '+1 234 567 8902',
        'role': 'Admin',
        'projects': ['Project X', 'Project Y', 'Project Z'],
        'permissions': ['Full Access'],
        'photoUrl': null,
      },
    ];
  }

  void _handleUserUpdate(
      int index,
      String name,
      String email,
      String phone,
      String role,
      List<String> projects,
      List<String> permissions,
      File? newPhoto) {
    setState(() {
      users[index] = {
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'projects': projects,
        'permissions': permissions,
        'photoUrl': null, // TODO: Upload photo and get URL
      };
    });
    // TODO: Update user in the database through your provider
    // TODO: If newPhoto is not null, upload it to storage and update photoUrl
  }

  void _handleUserDeactivate(int index) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate User'),
        content: Text(
            'Are you sure you want to deactivate ${users[index]['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Deactivate user in the database through your provider
              setState(() {
                users.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double childAspectRatio;

        // Responsive grid layout
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4; // 4 cards per row on large screens
          childAspectRatio = 0.85;
        } else if (constraints.maxWidth > 900) {
          crossAxisCount = 3; // 3 cards per row on medium screens
          childAspectRatio = 0.85;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 2; // 2 cards per row on small screens
          childAspectRatio = 0.9;
        } else {
          // Single column list view on mobile
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return UserCard(
                name: user['name'],
                email: user['email'],
                phone: user['phone'],
                role: user['role'],
                projects: List<String>.from(user['projects']),
                permissions: List<String>.from(user['permissions']),
                photoUrl: user['photoUrl'],
                onSave: (name, email, phone, role, projects, permissions,
                        newPhoto) =>
                    _handleUserUpdate(index, name, email, phone, role, projects,
                        permissions, newPhoto),
                onDeactivate: () => _handleUserDeactivate(index),
              );
            },
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return UserCard(
              name: user['name'],
              email: user['email'],
              phone: user['phone'],
              role: user['role'],
              projects: List<String>.from(user['projects']),
              permissions: List<String>.from(user['permissions']),
              photoUrl: user['photoUrl'],
              onSave: (name, email, phone, role, projects, permissions,
                      newPhoto) =>
                  _handleUserUpdate(index, name, email, phone, role, projects,
                      permissions, newPhoto),
              onDeactivate: () => _handleUserDeactivate(index),
            );
          },
        );
      },
    );
  }
}
