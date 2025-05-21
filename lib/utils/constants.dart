import 'package:flutter/material.dart';
import '../models/nav_item_model.dart';

// App version
const String appVersion = 'v1.0.0';

// Support contact
const String supportEmail = 'support@abiezer.com';

// Navigation constants
const double kSideNavWidth = 250.0;
const double kTopBarHeight = 60.0;
const double kFooterHeight = 40.0;

// Responsive breakpoints
const double kMobileBreakpoint = 600.0;
const double kTabletBreakpoint = 900.0;
const double kDesktopBreakpoint = 1200.0;

// Navigation items for the sidebar
final List<NavItemModel> navigationItems = [
  NavItemModel(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    route: '/dashboard',
    allowedRoles: ['admin', 'project_manager'],
  ),
  NavItemModel(
    label: 'Projects',
    icon: Icons.folder_outlined,
    route: '/projects',
    allowedRoles: ['admin'],
  ),
  NavItemModel(
    label: 'Bill of Materials',
    icon: Icons.assignment_outlined,
    route: '/bom',
    allowedRoles: ['admin', 'project_manager'],
  ),
  NavItemModel(
    label: 'Purchases',
    icon: Icons.shopping_cart_outlined,
    route: '/purchases',
    allowedRoles: ['admin', 'project_manager'],
  ),
  NavItemModel(
    label: 'Approvals',
    icon: Icons.check_circle_outline,
    route: '/approvals',
    allowedRoles: ['admin'],
  ),
  NavItemModel(
    label: 'Reports',
    icon: Icons.bar_chart_outlined,
    route: '/reports',
    allowedRoles: ['admin'],
  ),
  NavItemModel(
    label: 'My Productivity',
    icon: Icons.insert_chart_outlined,
    route: '/productivity',
    allowedRoles: ['project_manager'],
  ),
  NavItemModel(
    label: 'Users',
    icon: Icons.people_outline,
    route: '/users',
    allowedRoles: ['admin'],
  ),
  NavItemModel(
    label: 'Settings',
    icon: Icons.settings_outlined,
    route: '/settings',
    allowedRoles: ['admin', 'project_manager'],
  ),
];

// Padding constants
const EdgeInsets kMobilePadding = EdgeInsets.all(16.0);
const EdgeInsets kTabletPadding = EdgeInsets.all(24.0);
const EdgeInsets kDesktopPadding = EdgeInsets.all(32.0);
