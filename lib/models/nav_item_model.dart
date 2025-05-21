import 'package:flutter/material.dart';

class NavItemModel {
  final String label;
  final IconData icon;
  final String route;
  final List<String> allowedRoles; // 'admin', 'project_manager'

  NavItemModel({
    required this.label,
    required this.icon,
    required this.route,
    required this.allowedRoles,
  });

  bool isAllowed(String role) {
    return allowedRoles.contains(role);
  }
}
